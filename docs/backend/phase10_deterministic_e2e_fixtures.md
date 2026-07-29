# Phase 10 — Deterministic Multiplayer E2E Fixtures

Implemented:

- test-only SQL fixture schema outside `supabase/migrations`;
- deterministic winning hand seeding;
- executable win declaration;
- unanimous rematch flow;
- overdue-turn resolution;
- disconnect and reconnection recovery;
- revision-protected leave flow;
- production guard ensuring fixture helpers are never shipped by `supabase db push`.

Run:

```bash
scripts/run_supabase_phase10_e2e.sh
```

The fixture SQL is intentionally loaded only after a local database reset. Never
copy `supabase/test_migrations` into production migrations.
