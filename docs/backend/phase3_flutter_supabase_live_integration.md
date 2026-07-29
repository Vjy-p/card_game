# Phase 3 — Flutter ↔ Supabase Live Integration

The Flutter game-table repository now speaks the production backend contract.

- `get_game_state_snapshot` returns one composite public/private snapshot.
- draw and discard responses are normalized into `GameCommandResult`.
- physical bigint card IDs are accepted by the discard RPC.
- realtime `game_events` rows map `id`, `message`, and exact `revision`.
- revision gaps continue to trigger full snapshot resynchronization through the
  existing `GameRevisionGuard` and backend coordinator.
