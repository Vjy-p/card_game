# Phase 4 — Authoritative Round Rules

Implemented on the server:

- complete-hand declaration validation;
- duplicate physical-card rejection;
- ownership verification;
- same-rank groups of at least three cards;
- same-suit consecutive runs of at least three cards;
- revision-protected `declare_win`;
- server-side penalty scoring;
- persisted round results;
- one exact-revision `round_ended` event.

The current rule engine intentionally validates natural sets and runs. Joker
substitution is not enabled until the project's joker semantics are finalized,
so the backend does not invent a rule that could conflict with gameplay.
