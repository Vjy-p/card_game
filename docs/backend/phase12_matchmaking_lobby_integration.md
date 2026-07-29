# Phase 12 — Matchmaking and Lobby Backend Integration

Implemented:

- public, private, and matchmaking room visibility;
- named tables and configurable 2–10 player limits;
- public table discovery and joining;
- concurrency-safe oldest-room-first quick matchmaking;
- private opaque invite tokens in addition to join codes;
- active-session discovery for app launch and rejoin;
- Phase 11 rate limiting on room creation and public entry points;
- explicit authenticated RPC grants;
- contract tests for all lobby entry paths.

The existing Flutter lobby controllers can now be connected to these RPCs in
the next client-integration phase. Server authority remains unchanged once a
room transitions from waiting to playing.

Run:

```bash
supabase db reset
flutter analyze
flutter test
```
