# Supabase Backend Phase 1

Implemented the first production backend slice for private rooms and lobby lifecycle.

## Included

- authenticated room ownership and membership;
- unique join-code generation;
- room creation and joining;
- authoritative lobby snapshots;
- revision-protected ready state;
- host-only, revision-protected game start;
- server-side physical deck creation, shuffle, and seven-card deal;
- 2 decks for 2–4 players and 3 decks for 5–10 players;
- RLS that exposes rooms to members and hand cards only to their owner;
- service-role-only timeout resolver boundary for the later lifecycle phase.

## Next backend phase

Implement authoritative gameplay commands and event/revision pipeline: draw, discard, game snapshots, private hand state, realtime revisions, reconnect recovery, and idempotency receipts.
