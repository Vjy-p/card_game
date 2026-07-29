-- Supabase Backend Phase 1: private room lifecycle and authoritative game start.

create policy "members can read public card zones" on public.game_cards
for select to authenticated using (
  public.is_room_member(room_id)
  and (zone <> 'player_hand' or owner_player_id in (
    select id from public.players where user_id = auth.uid()
  ))
);

create or replace function public.raise_game_error(p_code text, p_message text)
returns void language plpgsql as $$
begin
  raise exception using errcode = 'P0001', message = p_code || ': ' || p_message;
end;
$$;

create or replace function public.generate_join_code()
returns text language plpgsql volatile set search_path = public as $$
declare
  v_code text;
begin
  loop
    v_code := upper(substr(encode(gen_random_bytes(6), 'hex'), 1, 8));
    exit when not exists (select 1 from public.rooms where join_code = v_code);
  end loop;
  return v_code;
end;
$$;

create or replace function public.get_room_lobby_snapshot(p_room_id text)
returns jsonb language plpgsql security definer set search_path = public as $$
declare
  v_user_id uuid := auth.uid();
  v_room public.rooms%rowtype;
  v_local_player_id bigint;
begin
  if v_user_id is null then perform public.raise_game_error('unauthenticated', 'Authentication required'); end if;
  if not public.is_room_member(p_room_id) then perform public.raise_game_error('forbidden', 'Room membership required'); end if;

  select * into v_room from public.rooms where id = p_room_id;
  select id into v_local_player_id from public.players where room_id = p_room_id and user_id = v_user_id;

  return jsonb_build_object(
    'room_id', v_room.id,
    'join_code', v_room.join_code,
    'status', v_room.game_status,
    'revision', v_room.revision,
    'local_player_id', v_local_player_id,
    'host_player_id', (select id from public.players where room_id = p_room_id and user_id = v_room.host_user_id),
    'players', coalesce((
      select jsonb_agg(jsonb_build_object(
        'player_id', p.id,
        'display_name', p.display_name,
        'seat_index', p.seat_index,
        'is_host', p.user_id = v_room.host_user_id,
        'is_connected', p.is_connected,
        'is_ready', p.is_ready
      ) order by p.seat_index)
      from public.players p where p.room_id = p_room_id
    ), '[]'::jsonb)
  );
end;
$$;

create or replace function public.create_game_room(p_display_name text)
returns jsonb language plpgsql security definer set search_path = public as $$
declare
  v_user_id uuid := auth.uid();
  v_room_id text;
begin
  if v_user_id is null then perform public.raise_game_error('unauthenticated', 'Authentication required'); end if;
  if length(trim(p_display_name)) = 0 or char_length(trim(p_display_name)) > 40 then perform public.raise_game_error('invalid_display_name', 'Display name must be 1-40 characters'); end if;

  insert into public.rooms(join_code, host_user_id)
  values (public.generate_join_code(), v_user_id)
  returning id into v_room_id;

  insert into public.players(room_id, user_id, display_name, seat_index, is_ready)
  values (v_room_id, v_user_id, trim(p_display_name), 0, true);

  return public.get_room_lobby_snapshot(v_room_id);
end;
$$;

create or replace function public.join_game_room(p_join_code text, p_display_name text)
returns jsonb language plpgsql security definer set search_path = public as $$
declare
  v_user_id uuid := auth.uid();
  v_room public.rooms%rowtype;
  v_player_count integer;
  v_seat_index integer;
begin
  if v_user_id is null then perform public.raise_game_error('unauthenticated', 'Authentication required'); end if;
  if length(trim(p_display_name)) = 0 or char_length(trim(p_display_name)) > 40 then perform public.raise_game_error('invalid_display_name', 'Display name must be 1-40 characters'); end if;

  select * into v_room from public.rooms
  where join_code = upper(replace(trim(p_join_code), ' ', ''))
  for update;

  if not found then perform public.raise_game_error('room_not_found', 'Room code not found'); end if;
  if v_room.game_status <> 'waiting' then perform public.raise_game_error('game_already_started', 'Room is not accepting players'); end if;

  select count(*) into v_player_count from public.players where room_id = v_room.id;
  if v_player_count >= v_room.max_players then perform public.raise_game_error('room_full', 'Room is full'); end if;

  select coalesce(max(seat_index), -1) + 1 into v_seat_index from public.players where room_id = v_room.id;

  insert into public.players(room_id, user_id, display_name, seat_index)
  values (v_room.id, v_user_id, trim(p_display_name), v_seat_index)
  on conflict (room_id, user_id) do update set
    display_name = excluded.display_name,
    is_connected = true;

  update public.rooms set revision = revision + 1, updated_at = now() where id = v_room.id;
  return public.get_room_lobby_snapshot(v_room.id);
end;
$$;

create or replace function public.set_player_ready(p_room_id text, p_is_ready boolean, p_expected_revision bigint)
returns jsonb language plpgsql security definer set search_path = public as $$
declare v_room public.rooms%rowtype;
begin
  select * into v_room from public.rooms where id = p_room_id for update;
  if not found then perform public.raise_game_error('room_not_found', 'Room not found'); end if;
  if not public.is_room_member(p_room_id) then perform public.raise_game_error('forbidden', 'Room membership required'); end if;
  if v_room.revision <> p_expected_revision then perform public.raise_game_error('revision_conflict', 'Lobby changed'); end if;
  if v_room.game_status <> 'waiting' then perform public.raise_game_error('invalid_status', 'Game already started'); end if;

  update public.players set is_ready = p_is_ready, is_connected = true
  where room_id = p_room_id and user_id = auth.uid();
  update public.rooms set revision = revision + 1, updated_at = now() where id = p_room_id;
  return public.get_room_lobby_snapshot(p_room_id);
end;
$$;

create or replace function public.start_game(p_room_id text, p_expected_revision bigint)
returns jsonb language plpgsql security definer set search_path = public as $$
declare
  v_user_id uuid := auth.uid();
  v_room public.rooms%rowtype;
  v_player_count integer;
  v_deck_count integer;
begin
  select * into v_room from public.rooms where id = p_room_id for update;
  if not found then perform public.raise_game_error('room_not_found', 'Room not found'); end if;
  if v_room.host_user_id <> v_user_id then perform public.raise_game_error('host_only', 'Only the host can start'); end if;
  if v_room.revision <> p_expected_revision then perform public.raise_game_error('revision_conflict', 'Lobby changed'); end if;
  if v_room.game_status <> 'waiting' then perform public.raise_game_error('invalid_status', 'Game already started'); end if;

  select count(*) into v_player_count from public.players where room_id = p_room_id and is_connected;
  if v_player_count < 2 then perform public.raise_game_error('not_enough_players', 'At least two players required'); end if;
  if exists (select 1 from public.players where room_id = p_room_id and user_id <> v_room.host_user_id and (not is_ready or not is_connected)) then
    perform public.raise_game_error('players_not_ready', 'All connected guests must be ready');
  end if;

  v_deck_count := case when v_player_count <= 4 then 2 else 3 end;
  delete from public.game_cards where room_id = p_room_id;

  insert into public.game_cards(room_id, deck_index, suit, rank, zone, pile_position)
  select p_room_id, d.deck_index, s.suit, r.rank, 'draw_pile',
         row_number() over (order by random())
  from generate_series(1, v_deck_count) d(deck_index)
  cross join (values ('clubs'),('diamonds'),('hearts'),('spades')) s(suit)
  cross join generate_series(1, 13) r(rank);

  with dealt as (
    select id, row_number() over (order by pile_position) as deal_no
    from public.game_cards where room_id = p_room_id and zone = 'draw_pile'
    order by pile_position
    limit v_player_count * 7
  ), seated as (
    select id, row_number() over (order by seat_index) as player_no
    from public.players where room_id = p_room_id and is_connected
  )
  update public.game_cards c
  set zone = 'player_hand', owner_player_id = s.id, pile_position = null
  from dealt d join seated s on s.player_no = ((d.deal_no - 1) % v_player_count) + 1
  where c.id = d.id;

  update public.players p set card_count = 7 where room_id = p_room_id and is_connected;
  update public.rooms set
    game_status = 'playing',
    current_player_id = (select id from public.players where room_id = p_room_id and is_connected order by seat_index limit 1),
    turn_phase = 'must_draw',
    turn_deadline = now() + make_interval(secs => timeout_seconds),
    revision = revision + 1,
    updated_at = now()
  where id = p_room_id;

  return jsonb_build_object('room_id', p_room_id, 'revision', (select revision from public.rooms where id = p_room_id));
end;
$$;

grant execute on function public.create_game_room(text) to authenticated;
grant execute on function public.join_game_room(text, text) to authenticated;
grant execute on function public.get_room_lobby_snapshot(text) to authenticated;
grant execute on function public.set_player_ready(text, boolean, bigint) to authenticated;
grant execute on function public.start_game(text, bigint) to authenticated;
