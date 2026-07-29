# Phase 11 — Observability, Audit, Rate Limiting, and Health

Implemented private audit storage, reusable RPC rate limiting, idempotency
receipt cleanup, health metrics for overdue turns and stale receipts, a
secret-protected health Edge Function, structured request IDs, and contract
tests.

Run:

```bash
supabase db reset
flutter analyze
flutter test
```

Deploy:

```bash
supabase db push
supabase functions deploy backend-health --no-verify-jwt
```

Use the existing `MAINTENANCE_SECRET` and send it through the
`x-maintenance-secret` header from trusted infrastructure only.
