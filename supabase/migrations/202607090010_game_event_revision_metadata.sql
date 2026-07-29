-- Event revision metadata contract.
alter table public.game_events alter column revision set not null;
create unique index if not exists game_events_room_revision_contract_idx on public.game_events(room_id, revision);
create or replace function public.normalize_game_event_revision_trigger() returns trigger language plpgsql as $$ begin new.payload = coalesce(new.payload, '{}'::jsonb) || jsonb_build_object('revision', new.revision); return new; end; $$;
