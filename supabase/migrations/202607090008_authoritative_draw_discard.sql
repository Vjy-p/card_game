-- Supabase Backend Phase 2 — Authoritative gameplay engine.
-- Draw/discard mutations, idempotency receipts, snapshots, and ordered events.

create table if not exists public.game_command_receipts (
  room_id text not null references public.rooms(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  command_id uuid not null,
  command_name text not null,
  response jsonb not null,
  created_at timestamptz not null default now(),
  primary key (room_id, user_id, command_id)
);

alter table public.game_command_receipts enable row level security;
drop policy if exists "members can read game events" on public.game_events;
create policy "members can read game events"
on public.game_events for select to authenticated
using (
  exists (
    select 1 from public.players p
    where p.room_id = game_events.room_id
      and p.user_id = auth.uid()
  )
);

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
  insert into public.game_events(
    room_id, revision, event_type, message, payload
  ) values (
    p_room_id,
    p_revision,
    p_event_type,
    p_message,
    coalesce(p_payload, '{}'::jsonb) || jsonb_build_object('revision', p_revision)
  )
  returning * into v_event;

  return v_event;
end;
$$;

create or replace function public.get_public_game_snapshot(p_room_id text)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_room public.rooms%rowtype;
begin
  perform public.assert_room_member(p_room_id);

  select * into v_room from public.rooms where id = p_room_id;
  if not found then
    perform public.raise_game_error('room_not_found', 'Room not found');
  end if;

  return jsonb_build_object(
    'room_id', v_room.id,
    'status', v_room.game_status,
    'revision', v_room.revision,
    'current_player_id', v_room.current_player_id,
    'turn_phase', v_room.turn_phase,
    'turn_deadline', v_room.turn_deadline,
    'players', coalesce((
      select jsonb_agg(jsonb_build_object(
        'id', p.id,
        'name', p.name,
        'seat_index', p.seat_index,
        'hand_count', p.card_count,
        'is_current_turn', p.id = v_room.current_player_id,
        'is_connected', p.is_connected
      ) order by p.seat_index)
      from public.players p
      where p.room_id = p_room_id
    ), '[]'::jsonb),
    'open_discard', (
      select jsonb_build_object(
        'id', c.id,
        'rank', c.rank,
        'suit', c.suit
      )
      from public.game_cards c
      where c.room_id = p_room_id and c.zone = 'discard_pile'
      order by c.pile_position desc
      limit 1
    ),
    'draw_pile_count', (
      select count(*) from public.game_cards c
      where c.room_id = p_room_id and c.zone = 'draw_pile'
    )
  );
end;
$$;

create or replace function public.get_private_hand_snapshot(p_room_id text)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_player_id bigint;
  v_revision bigint;
begin
  select p.id into v_player_id
  from public.players p
  where p.room_id = p_room_id and p.user_id = auth.uid();

  if v_player_id is null then
    perform public.raise_game_error('not_room_member', 'Player is not in this room');
  end if;

  select revision into v_revision from public.rooms where id = p_room_id;

  return jsonb_build_object(
    'room_id', p_room_id,
    'player_id', v_player_id,
    'revision', v_revision,
    'cards', coalesce((
      select jsonb_agg(jsonb_build_object(
        'id', c.id,
        'rank', c.rank,
        'suit', c.suit,
        'deck_index', c.deck_index
      ) order by c.id)
      from public.game_cards c
      where c.room_id = p_room_id
        and c.zone = 'player_hand'
        and c.owner_player_id = v_player_id
    ), '[]'::jsonb)
  );
end;
$$;

create or replace function public.draw_card(
  p_room_id text,
  p_source text,
  p_expected_revision bigint,
  p_command_id uuid
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user_id uuid := auth.uid();
  v_room public.rooms%rowtype;
  v_player public.players%rowtype;
  v_card public.game_cards%rowtype;
  v_cached jsonb;
  v_response jsonb;
begin
  if v_user_id is null then
    perform public.raise_game_error('unauthenticated', 'Authentication required');
  end if;
  if p_source not in ('closed_pile', 'open_pile') then
    perform public.raise_game_error('invalid_draw_source', 'Unknown draw source');
  end if;

  select response into v_cached
  from public.game_command_receipts
  where room_id = p_room_id and user_id = v_user_id and command_id = p_command_id;
  if v_cached is not null then return v_cached; end if;

  select * into v_room from public.rooms where id = p_room_id for update;
  if not found then perform public.raise_game_error('room_not_found', 'Room not found'); end if;
  if v_room.revision <> p_expected_revision then perform public.raise_game_error('revision_conflict', 'Game state changed'); end if;
  if v_room.game_status <> 'playing' or v_room.turn_phase <> 'must_draw' then perform public.raise_game_error('invalid_phase', 'Draw is not available'); end if;

  select * into v_player
  from public.players
  where room_id = p_room_id and user_id = v_user_id
  for update;
  if not found or v_player.id <> v_room.current_player_id then perform public.raise_game_error('not_your_turn', 'It is not your turn'); end if;

  if p_source = 'closed_pile' then
    select * into v_card
    from public.game_cards
    where room_id = p_room_id and zone = 'draw_pile'
    order by pile_position asc
    limit 1 for update skip locked;
  else
    select * into v_card
    from public.game_cards
    where room_id = p_room_id and zone = 'discard_pile'
    order by pile_position desc
    limit 1 for update;
  end if;
  if not found then perform public.raise_game_error('draw_pile_empty', 'No card available'); end if;

  update public.game_cards
  set zone = 'player_hand', owner_player_id = v_player.id, pile_position = null
  where id = v_card.id;

  update public.players set card_count = card_count + 1 where id = v_player.id;

  update public.rooms
  set turn_phase = 'must_discard', revision = revision + 1, updated_at = now()
  where id = p_room_id returning * into v_room;

  perform public.append_game_event(
    p_room_id, v_room.revision, 'card_drawn', 'A player drew a card',
    jsonb_build_object('player_id', v_player.id, 'source', p_source)
  );

  v_response := jsonb_build_object(
    'room_id', p_room_id,
    'revision', v_room.revision,
    'turn_phase', v_room.turn_phase,
    'drawn_card_id', v_card.id
  );

  insert into public.game_command_receipts(room_id, user_id, command_id, command_name, response)
  values (p_room_id, v_user_id, p_command_id, 'draw_card', v_response);

  return v_response;
end;
$$;

create or replace function public.discard_card(
  p_room_id text,
  p_card_id bigint,
  p_expected_revision bigint,
  p_command_id uuid
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user_id uuid := auth.uid();
  v_room public.rooms%rowtype;
  v_player public.players%rowtype;
  v_next_player public.players%rowtype;
  v_cached jsonb;
  v_response jsonb;
  v_next_position integer;
begin
  if v_user_id is null then perform public.raise_game_error('unauthenticated', 'Authentication required'); end if;

  select response into v_cached
  from public.game_command_receipts
  where room_id = p_room_id and user_id = v_user_id and command_id = p_command_id;
  if v_cached is not null then return v_cached; end if;

  select * into v_room from public.rooms where id = p_room_id for update;
  if not found then perform public.raise_game_error('room_not_found', 'Room not found'); end if;
  if v_room.revision <> p_expected_revision then perform public.raise_game_error('revision_conflict', 'Game state changed'); end if;
  if v_room.game_status <> 'playing' or v_room.turn_phase <> 'must_discard' then perform public.raise_game_error('invalid_phase', 'Discard is not available'); end if;

  select * into v_player
  from public.players
  where room_id = p_room_id and user_id = v_user_id
  for update;
  if not found or v_player.id <> v_room.current_player_id then perform public.raise_game_error('not_your_turn', 'It is not your turn'); end if;

  perform 1 from public.game_cards
  where id = p_card_id and room_id = p_room_id
    and zone = 'player_hand' and owner_player_id = v_player.id
  for update;
  if not found then perform public.raise_game_error('card_not_owned', 'Card is not in your hand'); end if;

  select coalesce(max(pile_position), 0) + 1 into v_next_position
  from public.game_cards where room_id = p_room_id and zone = 'discard_pile';

  update public.game_cards
  set zone = 'discard_pile', owner_player_id = null, pile_position = v_next_position
  where id = p_card_id;

  update public.players set card_count = greatest(card_count - 1, 0) where id = v_player.id;

  select * into v_next_player
  from public.players
  where room_id = p_room_id and is_connected = true and seat_index > v_player.seat_index
  order by seat_index limit 1;

  if not found then
    select * into v_next_player
    from public.players
    where room_id = p_room_id and is_connected = true
    order by seat_index limit 1;
  end if;
  if not found then perform public.raise_game_error('no_next_player', 'No connected next player'); end if;

  update public.rooms
  set current_player_id = v_next_player.id,
      turn_phase = 'must_draw',
      turn_deadline = now() + make_interval(secs => timeout_seconds),
      revision = revision + 1,
      updated_at = now()
  where id = p_room_id returning * into v_room;

  perform public.append_game_event(
    p_room_id, v_room.revision, 'card_discarded', 'A player discarded a card',
    jsonb_build_object(
      'player_id', v_player.id,
      'card_id', p_card_id,
      'next_player_id', v_next_player.id,
      'turn_deadline', v_room.turn_deadline
    )
  );

  v_response := jsonb_build_object(
    'room_id', p_room_id,
    'revision', v_room.revision,
    'turn_phase', v_room.turn_phase,
    'current_player_id', v_room.current_player_id,
    'turn_deadline', v_room.turn_deadline,
    'discarded_card_id', p_card_id
  );

  insert into public.game_command_receipts(room_id, user_id, command_id, command_name, response)
  values (p_room_id, v_user_id, p_command_id, 'discard_card', v_response);

  return v_response;
end;
$$;

grant execute on function public.get_public_game_snapshot(text) to authenticated;
grant execute on function public.get_private_hand_snapshot(text) to authenticated;
grant execute on function public.draw_card(text, text, bigint, uuid) to authenticated;
grant execute on function public.discard_card(text, bigint, bigint, uuid) to authenticated;

-- Legacy contract alias: zone = 'hand'
