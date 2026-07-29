-- Supabase Backend Phase 11 — observability, audit, rate limiting, health.

create table if not exists public.backend_audit_log (
  id bigint generated always as identity primary key,
  room_id text references public.rooms(id) on delete set null,
  actor_user_id uuid references auth.users(id) on delete set null,
  action text not null,
  outcome text not null check (outcome in ('success', 'rejected', 'failure')),
  request_id uuid,
  revision bigint,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create table if not exists public.rpc_rate_limits (
  bucket_key text primary key,
  window_started_at timestamptz not null,
  request_count integer not null default 0 check (request_count >= 0),
  updated_at timestamptz not null default now()
);

create or replace function public.enforce_rpc_rate_limit(
  p_scope text, p_limit integer, p_window_seconds integer
)
returns void language plpgsql security definer set search_path = public as $$
declare
  v_key text;
  v_row public.rpc_rate_limits%rowtype;
begin
  v_key := p_scope || ':' || coalesce(auth.uid()::text, 'anonymous');
  insert into public.rpc_rate_limits(
    bucket_key, window_started_at, request_count, updated_at
  ) values (v_key, now(), 1, now())
  on conflict (bucket_key) do update set
    window_started_at = case
      when public.rpc_rate_limits.window_started_at
        <= now() - make_interval(secs => p_window_seconds)
      then now() else public.rpc_rate_limits.window_started_at end,
    request_count = case
      when public.rpc_rate_limits.window_started_at
        <= now() - make_interval(secs => p_window_seconds)
      then 1 else public.rpc_rate_limits.request_count + 1 end,
    updated_at = now()
  returning * into v_row;

  if v_row.request_count > p_limit then
    perform public.raise_game_error('rate_limited', 'Too many requests');
  end if;
end;
$$;

create or replace function public.backend_health()
returns jsonb language plpgsql security definer set search_path = public as $$
begin
  return jsonb_build_object(
    'status', 'ok',
    'checked_at', now(),
    'rooms', (select count(*) from public.rooms),
    'players', (select count(*) from public.players),
    'stale_command_receipts', (
      select count(*) from public.game_command_receipts
      where created_at < now() - interval '24 hours'
    ),
    'due_turn_timeouts', (
      select count(*) from public.rooms
      where game_status = 'playing'
        and turn_deadline is not null
        and turn_deadline <= now()
    )
  );
end;
$$;

create or replace function public.cleanup_backend_operational_data()
returns jsonb language plpgsql security definer set search_path = public as $$
declare
  v_receipts integer;
  v_rate_buckets integer;
  v_audit_rows integer;
begin
  delete from public.game_command_receipts
    where created_at < now() - interval '24 hours';
  get diagnostics v_receipts = row_count;

  delete from public.rpc_rate_limits
    where updated_at < now() - interval '1 day';
  get diagnostics v_rate_buckets = row_count;

  delete from public.backend_audit_log
    where created_at < now() - interval '30 days';
  get diagnostics v_audit_rows = row_count;

  return jsonb_build_object(
    'deleted_command_receipts', v_receipts,
    'deleted_rate_limit_buckets', v_rate_buckets,
    'deleted_audit_rows', v_audit_rows
  );
end;
$$;

alter table public.backend_audit_log enable row level security;
alter table public.rpc_rate_limits enable row level security;

revoke all on public.backend_audit_log from public, anon, authenticated;
revoke all on public.rpc_rate_limits from public, anon, authenticated;
revoke all on function public.backend_health() from public, anon, authenticated;
revoke all on function public.cleanup_backend_operational_data()
  from public, anon, authenticated;
