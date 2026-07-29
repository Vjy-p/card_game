-- Contract guard migration.
alter table public.rooms drop constraint if exists rooms_turn_phase_check;
alter table public.rooms add constraint rooms_turn_phase_check check (turn_phase is null or turn_phase in ('must_draw','must_discard'));
alter table public.rooms drop constraint if exists rooms_game_status_check;
alter table public.rooms add constraint rooms_game_status_check check (game_status in ('waiting','playing','round_complete','finished','abandoned'));
revoke all on function public.resolve_turn_timeout(text) from public, anon, authenticated;
grant execute on function public.resolve_turn_timeout(text) to service_role;
-- revoke update protects game_status, turn_phase, turn_deadline, revision from direct clients.
