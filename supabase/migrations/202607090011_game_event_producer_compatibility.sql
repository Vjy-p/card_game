-- Stable event producer compatibility contract.
create or replace function public.append_game_event(
  p_room_id text,
  p_revision bigint,
  p_event_type text,
  p_message text,
  p_payload jsonb default '{}'::jsonb
)
returns public.game_events
language plpgsql
security definer
set search_path = public
as $$
declare
  v_event public.game_events;
begin
  insert into public.game_events(room_id, revision, event_type, message, payload)
  values (p_room_id, p_revision, p_event_type, p_message,
    coalesce(p_payload, '{}'::jsonb) || jsonb_build_object('revision', p_revision))
  returning * into v_event;
  return v_event;
end;
$$;
