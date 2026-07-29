-- Phase 12 — matchmaking, public/private tables, invites, and rejoin discovery.

alter table public.rooms
  add column if not exists visibility text not null default 'private'
    check (visibility in ('private', 'public', 'matchmaking')),
  add column if not exists table_name text,
  add column if not exists invite_token uuid not null default gen_random_uuid();

create index if not exists rooms_public_waiting_idx
  on public.rooms(created_at)
  where game_status = 'waiting' and visibility = 'public';

create index if not exists rooms_matchmaking_waiting_idx
  on public.rooms(max_players, created_at)
  where game_status = 'waiting' and visibility = 'matchmaking';

create or replace function public.create_table(
  p_display_name text,
  p_table_name text,
  p_max_players integer default 4,
  p_visibility text default 'private'
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user_id uuid := auth.uid();
  v_room_id text;
begin
  if v_user_id is null then
    perform public.raise_game_error('unauthenticated', 'Authentication required');
  end if;
  if p_max_players not between 2 and 10 then
    perform public.raise_game_error('invalid_player_limit', 'Player limit must be 2-10');
  end if;
  if p_visibility not in ('private', 'public') then
    perform public.raise_game_error('invalid_visibility', 'Unsupported visibility');
  end if;

  perform public.enforce_rpc_rate_limit('create_table', 10, 60);

  insert into public.rooms(
    join_code, host_user_id, max_players, visibility, table_name
  )
  values (
    public.generate_join_code(),
    v_user_id,
    p_max_players,
    p_visibility,
    nullif(trim(p_table_name), '')
  )
  returning id into v_room_id;

  insert into public.players(
    room_id, user_id, display_name, seat_index, is_ready
  )
  values (v_room_id, v_user_id, trim(p_display_name), 0, true);

  return public.get_room_lobby_snapshot(v_room_id);
end;
$$;

create or replace function public.list_public_tables(p_limit integer default 30)
returns jsonb
language sql
security definer
set search_path = public
as $$
  select coalesce(jsonb_agg(row_data order by created_at), '[]'::jsonb)
  from (
    select
      r.created_at,
      jsonb_build_object(
        'room_id', r.id,
        'table_name', coalesce(r.table_name, 'Public Table'),
        'max_players', r.max_players,
        'player_count', count(p.id),
        'created_at', r.created_at
      ) as row_data
    from public.rooms r
    left join public.players p on p.room_id = r.id and p.is_connected
    where r.game_status = 'waiting'
      and r.visibility = 'public'
    group by r.id
    having count(p.id) < r.max_players
    limit least(greatest(p_limit, 1), 100)
  ) available;
$$;

create or replace function public.join_public_table(
  p_room_id text,
  p_display_name text
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_room public.rooms%rowtype;
  v_count integer;
  v_seat integer;
begin
  perform public.enforce_rpc_rate_limit('join_public_table', 30, 60);

  select * into v_room
  from public.rooms
  where id = p_room_id
    and visibility = 'public'
  for update;

  if not found then
    perform public.raise_game_error('room_not_found', 'Public table not found');
  end if;
  if v_room.game_status <> 'waiting' then
    perform public.raise_game_error('game_already_started', 'Table is closed');
  end if;

  select count(*) into v_count from public.players where room_id = p_room_id;
  if v_count >= v_room.max_players then
    perform public.raise_game_error('room_full', 'Table is full');
  end if;

  select coalesce(max(seat_index), -1) + 1 into v_seat
  from public.players where room_id = p_room_id;

  insert into public.players(room_id, user_id, display_name, seat_index)
  values (p_room_id, auth.uid(), trim(p_display_name), v_seat)
  on conflict (room_id, user_id) do update
    set display_name = excluded.display_name, is_connected = true;

  update public.rooms
  set revision = revision + 1, updated_at = now()
  where id = p_room_id;

  return public.get_room_lobby_snapshot(p_room_id);
end;
$$;

create or replace function public.join_matchmaking(
  p_display_name text,
  p_max_players integer default 4
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_room public.rooms%rowtype;
  v_seat integer;
begin
  perform public.enforce_rpc_rate_limit('join_matchmaking', 20, 60);

  select r.* into v_room
  from public.rooms r
  where r.visibility = 'matchmaking'
    and r.game_status = 'waiting'
    and r.max_players = p_max_players
    and (select count(*) from public.players p where p.room_id = r.id)
      < r.max_players
  order by r.created_at
  for update skip locked
  limit 1;

  if not found then
    insert into public.rooms(
      join_code, host_user_id, max_players, visibility, table_name
    )
    values (
      public.generate_join_code(), auth.uid(), p_max_players,
      'matchmaking', 'Quick Match'
    )
    returning * into v_room;
  end if;

  select coalesce(max(seat_index), -1) + 1 into v_seat
  from public.players where room_id = v_room.id;

  insert into public.players(room_id, user_id, display_name, seat_index, is_ready)
  values (
    v_room.id, auth.uid(), trim(p_display_name), v_seat,
    auth.uid() = v_room.host_user_id
  )
  on conflict (room_id, user_id) do update
    set is_connected = true, display_name = excluded.display_name;

  update public.rooms
  set revision = revision + 1, updated_at = now()
  where id = v_room.id;

  return public.get_room_lobby_snapshot(v_room.id);
end;
$$;

create or replace function public.get_private_invite(p_room_id text)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_room public.rooms%rowtype;
begin
  select * into v_room from public.rooms where id = p_room_id;
  if not found or not public.is_room_member(p_room_id) then
    perform public.raise_game_error('forbidden', 'Room membership required');
  end if;
  if v_room.visibility <> 'private' then
    perform public.raise_game_error('invalid_room_type', 'Not a private room');
  end if;

  return jsonb_build_object(
    'room_id', v_room.id,
    'join_code', v_room.join_code,
    'invite_token', v_room.invite_token
  );
end;
$$;

create or replace function public.join_private_invite(
  p_invite_token uuid,
  p_display_name text
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_code text;
begin
  select join_code into v_code
  from public.rooms
  where invite_token = p_invite_token
    and visibility = 'private'
    and game_status = 'waiting';

  if v_code is null then
    perform public.raise_game_error('invite_invalid', 'Invite is invalid or expired');
  end if;

  return public.join_game_room(v_code, p_display_name);
end;
$$;

create or replace function public.discover_rejoinable_sessions()
returns jsonb
language sql
security definer
set search_path = public
as $$
  select coalesce(jsonb_agg(jsonb_build_object(
    'room_id', r.id,
    'table_name', coalesce(r.table_name, 'Card Table'),
    'status', r.game_status,
    'revision', r.revision,
    'seat_index', p.seat_index,
    'is_host', r.host_user_id = auth.uid(),
    'updated_at', r.updated_at
  ) order by r.updated_at desc), '[]'::jsonb)
  from public.players p
  join public.rooms r on r.id = p.room_id
  where p.user_id = auth.uid()
    and r.game_status in ('waiting', 'playing');
$$;

grant execute on function public.create_table(text, text, integer, text)
  to authenticated;
grant execute on function public.list_public_tables(integer)
  to authenticated;
grant execute on function public.join_public_table(text, text)
  to authenticated;
grant execute on function public.join_matchmaking(text, integer)
  to authenticated;
grant execute on function public.get_private_invite(text)
  to authenticated;
grant execute on function public.join_private_invite(uuid, text)
  to authenticated;
grant execute on function public.discover_rejoinable_sessions()
  to authenticated;
