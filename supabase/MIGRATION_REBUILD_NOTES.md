# Migration Rebuild Notes

The uploaded migration chain referenced schema objects before they existed.

Fixed:

- migration `202607090002_game_cards_foundation.sql` now creates both
  `game_cards` and `game_events`;
- round rules in migration `003` can safely use `game_cards`;
- realtime publication in migration `004` can safely use `game_events`;
- duplicate `game_cards` creation was removed from migration `005`;
- duplicate `game_events` creation was removed from migration `008`;
- later policies, RPCs, and gameplay logic remain in their original phases.

A static dependency scan found no remaining references to known tables before
their first creation migration.

Run from the Flutter project root:

```bash
supabase db reset
```
