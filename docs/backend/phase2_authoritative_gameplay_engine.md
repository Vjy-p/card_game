# Supabase Backend Phase 2 — Authoritative Gameplay Engine

Implemented:

- idempotent draw and discard commands;
- expected-revision conflict protection;
- server-owned turn and phase validation;
- private hand snapshots;
- public game snapshots;
- ordered `game_events` rows keyed by room revision;
- realtime publication for game events;
- command receipt replay for duplicate command IDs.

The server is authoritative. Clients submit intent plus the last revision they
observed. Successful mutations increment the room revision exactly once and
emit one event with that same revision.
