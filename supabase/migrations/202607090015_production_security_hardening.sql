-- Phase 8 — production security hardening.

-- Prevent broad default execution of newly created public functions.
alter default privileges in schema public
  revoke execute on functions from public;

-- App clients should not mutate authoritative game tables directly.
revoke insert, update, delete on table public.rooms from anon, authenticated;
revoke insert, update, delete on table public.players from anon, authenticated;
revoke insert, update, delete on table public.game_events from anon, authenticated;

-- Maintenance helpers remain trusted-server-only.
revoke all on function public.next_connected_player(text, integer)
  from public, anon, authenticated;
revoke all on function public.resolve_turn_timeout(text)
  from public, anon, authenticated;
revoke all on function public.mark_stale_game_presence(integer)
  from public, anon, authenticated;
revoke all on function public.resolve_due_game_timeouts(integer)
  from public, anon, authenticated;
revoke all on function public.cleanup_abandoned_game_rooms(integer, integer)
  from public, anon, authenticated;

-- Authenticated app RPCs are explicitly granted.
grant execute on function public.heartbeat_game_presence(text)
  to authenticated;
grant execute on function public.recover_game_session(text, bigint)
  to authenticated;
grant execute on function public.set_game_connection_state(text, boolean)
  to authenticated;
grant execute on function public.leave_game(text, bigint)
  to authenticated;
grant execute on function public.request_rematch(text, bigint)
  to authenticated;

-- Useful indexes for production maintenance scans.
create index if not exists rooms_due_turn_timeout_idx
  on public.rooms(turn_deadline)
  where game_status = 'playing' and turn_deadline is not null;

create index if not exists rooms_cleanup_idx
  on public.rooms(updated_at)
  where game_status in ('abandoned', 'finished');
