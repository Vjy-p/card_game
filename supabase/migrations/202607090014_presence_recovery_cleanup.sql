-- Phase 6 — presence heartbeats, reconnection recovery, timeout scanning, cleanup.

alter table public.players
  add column if not exists last_seen_at timestamptz not null default now();

create index if not exists players_presence_idx
  on public.players(room_id, is_connected, last_seen_at);

create or replace function public.heartbeat_game_presence(p_room_id text)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_player public.players%rowtype;
begin
  update public.players
  set is_connected = true,
      disconnected_at = null,
      last_seen_at = now()
  where room_id = p_room_id and user_id = auth.uid()
  returning * into v_player;

  if not found then
    perform public.raise_game_error('not_room_member', 'Player is not in this room');
  end if;

  return jsonb_build_object(
    'player_id', v_player.id,
    'last_seen_at', v_player.last_seen_at
  );
end;
$$;

create or replace function public.recover_game_session(
  p_room_id text,
  p_after_revision bigint default 0
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_player public.players%rowtype;
  v_snapshot jsonb;
begin
  update public.players
  set is_connected = true,
      disconnected_at = null,
      last_seen_at = now()
  where room_id = p_room_id and user_id = auth.uid()
  returning * into v_player;

  if not found then
    perform public.raise_game_error('not_room_member', 'Player is not in this room');
  end if;

  v_snapshot := public.get_game_state_snapshot(p_room_id, p_after_revision);

  return jsonb_build_object(
    'player_id', v_player.id,
    'snapshot', v_snapshot,
    'events', coalesce((
      select jsonb_agg(to_jsonb(e) order by e.revision)
      from public.game_events e
      where e.room_id = p_room_id
        and e.revision > p_after_revision
    ), '[]'::jsonb)
  );
end;
$$;

create or replace function public.mark_stale_game_presence(
  p_stale_after_seconds integer default 45
)
returns integer
language plpgsql
security definer
set search_path = public
as $$
declare
  v_count integer;
begin
  update public.players
  set is_connected = false,
      disconnected_at = coalesce(disconnected_at, now())
  where is_connected
    and last_seen_at < now() - make_interval(secs => p_stale_after_seconds);

  get diagnostics v_count = row_count;
  return v_count;
end;
$$;

create or replace function public.resolve_due_game_timeouts(
  p_limit integer default 100
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_room record;
  v_results jsonb := '[]'::jsonb;
begin
  for v_room in
    select id
    from public.rooms
    where game_status = 'playing'
      and turn_deadline is not null
      and turn_deadline <= now()
    order by turn_deadline
    limit greatest(1, least(p_limit, 500))
  loop
    v_results := v_results || jsonb_build_array(
      public.resolve_turn_timeout(v_room.id)
    );
  end loop;

  return v_results;
end;
$$;

create or replace function public.cleanup_abandoned_game_rooms(
  p_older_than_hours integer default 24,
  p_limit integer default 100
)
returns integer
language plpgsql
security definer
set search_path = public
as $$
declare
  v_count integer;
begin
  with doomed as (
    select id
    from public.rooms
    where game_status in ('abandoned', 'finished')
      and updated_at < now() - make_interval(hours => p_older_than_hours)
    order by updated_at
    limit greatest(1, least(p_limit, 500))
  )
  delete from public.rooms r
  using doomed d
  where r.id = d.id;

  get diagnostics v_count = row_count;
  return v_count;
end;
$$;

grant execute on function public.heartbeat_game_presence(text) to authenticated;
grant execute on function public.recover_game_session(text, bigint) to authenticated;

revoke all on function public.mark_stale_game_presence(integer)
  from public, anon, authenticated;
revoke all on function public.resolve_due_game_timeouts(integer)
  from public, anon, authenticated;
revoke all on function public.cleanup_abandoned_game_rooms(integer, integer)
  from public, anon, authenticated;
