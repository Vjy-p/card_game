# Phase 8 — Production Deployment, Scheduling, and Security

Implemented:

- Supabase local/project configuration;
- hardened maintenance Edge Function with a dedicated shared scheduler secret;
- request IDs and structured failure logging;
- sequential lifecycle maintenance ordering;
- direct mutation revocation for authoritative game tables;
- explicit RPC grants;
- production maintenance indexes;
- deployment script;
- one-minute GitHub Actions scheduler example;
- contract tests for deployment and security invariants.

## Production setup

1. Create a long random `GAME_MAINTENANCE_SECRET`.
2. Set `SUPABASE_PROJECT_REF` and `GAME_MAINTENANCE_SECRET`.
3. Run `scripts/deploy_supabase_phase8.sh`.
4. Add these GitHub repository secrets:
   - `GAME_MAINTENANCE_WORKER_URL`
   - `GAME_MAINTENANCE_SECRET`
5. Enable the `Game maintenance` workflow.

The worker URL is:

`https://<project-ref>.supabase.co/functions/v1/resolve-game-timeouts`

Do not place the service-role key or maintenance secret in Flutter, source control,
mobile build variables, or public web configuration.
