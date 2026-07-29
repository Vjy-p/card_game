# Phase 6 — Presence, Recovery, Timeout Worker, and Cleanup

Implemented:

- authenticated presence heartbeats;
- stale-presence detection;
- reconnect recovery with snapshot plus missed ordered events;
- batch resolution of overdue turns;
- cleanup of old abandoned/finished rooms;
- a service-role Edge Function that performs maintenance.

Deploy the Edge Function and invoke it from a trusted scheduler. The service
role key must remain server-side and must never be bundled into Flutter.
