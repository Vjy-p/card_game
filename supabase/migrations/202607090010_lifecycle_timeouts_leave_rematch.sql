-- Supabase Backend Phase 5 — lifecycle, disconnects, timeouts, leave, rematch.

alter table public.rooms drop constraint if exists rooms_game_status_check;
alter table public.rooms add constraint rooms_game_status_check
  check (game_status in (
    'waiting', 'playing', 'round_ended', 'finished', 'abandoned'
  ));

alter table public.players
  add column if not exists rematch_requested boolean not null default false,
  add column if not exists disconnected_at timestamptz;

create or replace function public.next_connected_player(
  p_room_id text,
  p_after_seat_index integer
)
returns public.players
language plpgsql
security definer
set search_path = public
as $$
declare
  v_player public.players;
begin
  select * into v_player
  from public.players
  where room_id = p_room_id
    and is_connected
    and seat_index > p_after_seat_index
  order by seat_index
  limit 1;

  if not found then
    select * into v_player
    from public.players
    where room_id = p_room_id and is_connected
    order by seat_index
    limit 1;
  end if;

  return v_player;
end;
$$;

create or replace function public.set_game_connection_state(
  p_room_id text,
  p_is_connected boolean
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_player public.players%rowtype;
begin
  if auth.uid() is null then
    perform public.raise_game_error('unauthenticated', 'Authentication required');
  end if;

  update public.players
  set is_connected = p_is_connected,
      disconnected_at = case when p_is_connected then null else now() end
  where room_id = p_room_id and user_id = auth.uid()
  returning * into v_player;

  if not found then
    perform public.raise_game_error('not_room_member', 'Player is not in this room');
  end if;

  return jsonb_build_object(
    'player_id', v_player.id,
    'is_connected', v_player.is_connected
  );
end;
$$;

create or replace function public.leave_game(
  p_room_id text,
  p_expected_revision bigint
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_room public.rooms%rowtype;
  v_player public.players%rowtype;
  v_next public.players%rowtype;
  v_connected_count integer;
begin
  select * into v_room from public.rooms where id = p_room_id for update;
  if not found then perform public.raise_game_error('room_not_found', 'Room not found'); end if;
  if v_room.revision <> p_expected_revision then
    perform public.raise_game_error('revision_conflict', 'Game state changed');
  end if;

  select * into v_player
  from public.players
  where room_id = p_room_id and user_id = auth.uid()
  for update;
  if not found then perform public.raise_game_error('not_room_member', 'Player is not in this room'); end if;

  update public.players
  set is_connected = false, disconnected_at = now(), rematch_requested = false
  where id = v_player.id;

  select count(*) into v_connected_count
  from public.players where room_id = p_room_id and is_connected;

  if v_connected_count = 0 then
    update public.rooms
    set game_status = 'abandoned',
        current_player_id = null,
        turn_phase = null,
        turn_deadline = null,
        revision = revision + 1,
        updated_at = now()
    where id = p_room_id returning * into v_room;
  elsif v_room.current_player_id = v_player.id and v_room.game_status = 'playing' then
    select * into v_next
    from public.next_connected_player(p_room_id, v_player.seat_index);

    update public.rooms
    set current_player_id = v_next.id,
        turn_phase = 'must_draw',
        turn_deadline = now() + make_interval(secs => timeout_seconds),
        revision = revision + 1,
        updated_at = now()
    where id = p_room_id returning * into v_room;
  else
    update public.rooms
    set revision = revision + 1, updated_at = now()
    where id = p_room_id returning * into v_room;
  end if;

  perform public.append_game_event(
    p_room_id,
    v_room.revision,
    'player_left',
    v_player.name || ' left the game',
    jsonb_build_object(
      'player_id', v_player.id,
      'current_player_id', v_room.current_player_id,
      'status', v_room.game_status
    )
  );

  return jsonb_build_object(
    'revision', v_room.revision,
    'current_player_id', v_room.current_player_id,
    'status', v_room.game_status
  );
end;
$$;


drop function if exists public.resolve_turn_timeout(text);

create function public.resolve_turn_timeout(p_room_id text)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_room public.rooms%rowtype;
  v_current public.players%rowtype;
  v_next public.players%rowtype;
begin
  select * into v_room from public.rooms where id = p_room_id for update;
  if not found then return jsonb_build_object('resolved', false, 'reason', 'room_not_found'); end if;
  if v_room.game_status <> 'playing' then return jsonb_build_object('resolved', false, 'reason', 'not_playing'); end if;
  if v_room.turn_deadline is null or v_room.turn_deadline > now() then
    return jsonb_build_object('resolved', false, 'reason', 'not_due');
  end if;

  select * into v_current from public.players where id = v_room.current_player_id;
  select * into v_next
  from public.next_connected_player(p_room_id, coalesce(v_current.seat_index, -1));

  if v_next.id is null then
    update public.rooms
    set game_status = 'abandoned',
        current_player_id = null,
        turn_phase = null,
        turn_deadline = null,
        revision = revision + 1,
        updated_at = now()
    where id = p_room_id returning * into v_room;
  else
    update public.rooms
    set current_player_id = v_next.id,
        turn_phase = 'must_draw',
        turn_deadline = now() + make_interval(secs => timeout_seconds),
        revision = revision + 1,
        updated_at = now()
    where id = p_room_id returning * into v_room;
  end if;

  perform public.append_game_event(
    p_room_id,
    v_room.revision,
    'turn_timeout',
    'Turn timed out',
    jsonb_build_object(
      'timed_out_player_id', v_current.id,
      'next_player_id', v_room.current_player_id,
      'turn_deadline', v_room.turn_deadline
    )
  );

  return jsonb_build_object(
    'resolved', true,
    'revision', v_room.revision,
    'current_player_id', v_room.current_player_id,
    'turn_deadline', v_room.turn_deadline
  );
end;
$$;

create or replace function public.request_rematch(
  p_room_id text,
  p_expected_revision bigint
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_room public.rooms%rowtype;
  v_player public.players%rowtype;
  v_connected_count integer;
  v_ready_count integer;
begin
  select * into v_room from public.rooms where id = p_room_id for update;
  if not found then perform public.raise_game_error('room_not_found', 'Room not found'); end if;
  if v_room.revision <> p_expected_revision then
    perform public.raise_game_error('revision_conflict', 'Game state changed');
  end if;
  if v_room.game_status <> 'round_ended' then
    perform public.raise_game_error('invalid_action', 'Rematch is not available');
  end if;

  select * into v_player
  from public.players
  where room_id = p_room_id and user_id = auth.uid() and is_connected;
  if not found then perform public.raise_game_error('not_room_member', 'Connected player required'); end if;

  update public.players set rematch_requested = true where id = v_player.id;

  select count(*) into v_connected_count
  from public.players where room_id = p_room_id and is_connected;
  select count(*) into v_ready_count
  from public.players
  where room_id = p_room_id and is_connected and rematch_requested;

  if v_connected_count >= 2 and v_ready_count = v_connected_count then
    update public.players
    set rematch_requested = false, is_ready = false
    where room_id = p_room_id;

    update public.rooms
    set game_status = 'waiting',
        current_player_id = null,
        turn_phase = null,
        turn_deadline = null,
        revision = revision + 1,
        updated_at = now()
    where id = p_room_id returning * into v_room;

    perform public.append_game_event(
      p_room_id, v_room.revision, 'rematch_ready', 'All players accepted the rematch',
      jsonb_build_object('status', v_room.game_status)
    );
  else
    update public.rooms
    set revision = revision + 1, updated_at = now()
    where id = p_room_id returning * into v_room;

    perform public.append_game_event(
      p_room_id, v_room.revision, 'rematch_requested',
      v_player.name || ' requested a rematch',
      jsonb_build_object('player_id', v_player.id)
    );
  end if;

  return jsonb_build_object(
    'revision', v_room.revision,
    'status', v_room.game_status,
    'rematch_ready_count', v_ready_count,
    'connected_player_count', v_connected_count
  );
end;
$$;

grant execute on function public.set_game_connection_state(text, boolean) to authenticated;
grant execute on function public.leave_game(text, bigint) to authenticated;
grant execute on function public.request_rematch(text, bigint) to authenticated;

revoke all on function public.resolve_turn_timeout(text)
  from public, anon, authenticated;
