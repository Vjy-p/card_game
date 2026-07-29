create table if not exists public.game_events (
  id bigint generated always as identity primary key,
  room_id text not null references public.rooms(id) on delete cascade,
  revision bigint not null,
  event_type text not null,
  message text not null,
  payload jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  unique (room_id, revision)
);

create index if not exists game_events_room_revision_idx
  on public.game_events(room_id, revision);

alter table public.game_events enable row level security;

do $$
begin
  if not exists (
    select 1
    from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'rooms'
  ) then
    alter publication supabase_realtime add table public.rooms;
  end if;

  if not exists (
    select 1
    from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'game_events'
  ) then
    alter publication supabase_realtime add table public.game_events;
  end if;
end $$;

create index if not exists rooms_active_timeout_idx
  on public.rooms(turn_deadline)
  where game_status = 'playing' and turn_deadline is not null;
