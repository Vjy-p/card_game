# Phase 7 — Flutter Presence and App Lifecycle Recovery

Implemented:

- 15-second foreground presence heartbeat;
- heartbeat suspension while the app is backgrounded;
- realtime subscription suspension while backgrounded;
- authoritative `recover_game_session` call on resume;
- fallback full synchronization if recovery fails;
- lifecycle observation in the game-table backend host.

The client never decides whether a player timed out. It only reports liveness.
The trusted backend worker remains authoritative for stale presence and turns.
