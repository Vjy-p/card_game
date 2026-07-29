# Phase 5 — Lifecycle, Disconnects, Timeouts, Leave, and Rematch

Implemented:

- explicit connected/disconnected presence state;
- revision-protected leave-game mutation;
- automatic turn advancement when the active player leaves;
- abandonment when no connected players remain;
- service-role-only overdue turn resolution;
- one revision and one ordered event per lifecycle mutation;
- unanimous connected-player rematch voting;
- transition from `round_ended` back to the waiting/start flow.

The timeout resolver is deliberately revoked from `anon` and `authenticated`.
It is intended for a trusted scheduled worker or Edge Function.
