-- Compatibility contract for Flutter repositories and later gameplay migrations.
alter table public.rooms add column if not exists join_code text;
alter table public.rooms add column if not exists host_user_id uuid;
alter table public.rooms add column if not exists max_players integer not null default 4;
alter table public.rooms add column if not exists revision bigint not null default 0;
alter table public.rooms add column if not exists game_status text not null default 'waiting';
alter table public.players add column if not exists seat_index integer;
alter table public.players add column if not exists is_connected boolean not null default true;
alter table public.players add column if not exists card_count integer not null default 0;

create or replace function public.resolve_turn_timeout(p_room_id text)
returns void language plpgsql security definer set search_path = public as $$
begin
  -- Implemented fully in the gameplay lifecycle phase. Kept service-role only.
  perform 1 from public.rooms where id = p_room_id for update;
end;
$$;
revoke all on function public.resolve_turn_timeout(text) from public, anon, authenticated;
grant execute on function public.resolve_turn_timeout(text) to service_role;
