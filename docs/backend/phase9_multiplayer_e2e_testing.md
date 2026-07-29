# Phase 9 — Multiplayer End-to-End Testing

This phase adds an opt-in local Supabase E2E harness with two independent
authenticated users.

Covered executable flows:

- host creates a room;
- guest joins;
- one user commits a revision;
- the other user intentionally sends a stale revision and receives
  `revision_conflict`;
- the stale client recovers with `recover_game_session`;
- recovery returns an authoritative snapshot plus missed ordered events;
- a player leaves using the latest revision;
- the production maintenance worker rejects unauthenticated scheduler calls.

Run:

```bash
scripts/run_supabase_multiplayer_e2e.sh
```

The local Supabase project must allow immediate email/password sessions. If
email confirmation is enabled, disable it for the local test project.

Win, timeout, and rematch are also protected by static cross-phase contract
tests. Fully deterministic executable win tests require a dedicated trusted
test-fixture RPC that can seed exact hands; that fixture is intentionally not
added to production migrations.
