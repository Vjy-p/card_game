-- TEST ONLY. Never push this file to production.
-- Loaded only by scripts/run_supabase_phase10_e2e.sh after `supabase db reset`.

create schema if not exists test_support;

create or replace function test_support.seed_round_fixture(
  p_room_id text,
  p_current_user_id uuid,
  p_turn_deadline timestamptz default now() - interval '1 second'
)
returns jsonb
language plpgsql
security definer
set search_path = public, test_support
as $$
declare
  v_player public.players%rowtype;
  v_other public.players%rowtype;
  v_revision bigint;
  v_cards jsonb;
begin
  select * into v_player
  from public.players
  where room_id = p_room_id and user_id = p_current_user_id;

  if not found then
    raise exception 'fixture_player_not_found';
  end if;

  select * into v_other
  from public.players
  where room_id = p_room_id and id <> v_player.id
  order by seat_index
  limit 1;

  delete from public.game_cards where room_id = p_room_id;

  -- Deterministic winning hand: 7♣ 8♣ 9♣ and four 5s.
  insert into public.game_cards(
    room_id, deck_index, suit, rank, zone, owner_player_id, pile_position
  )
  values
    (p_room_id, 0, 'clubs',    7, 'player_hand', v_player.id, null),
    (p_room_id, 0, 'clubs',    8, 'player_hand', v_player.id, null),
    (p_room_id, 0, 'clubs',    9, 'player_hand', v_player.id, null),
    (p_room_id, 0, 'clubs',    5, 'player_hand', v_player.id, null),
    (p_room_id, 0, 'diamonds', 5, 'player_hand', v_player.id, null),
    (p_room_id, 0, 'hearts',   5, 'player_hand', v_player.id, null),
    (p_room_id, 0, 'spades',   5, 'player_hand', v_player.id, null),
    (p_room_id, 0, 'hearts',  13, 'player_hand', v_other.id, null),
    (p_room_id, 0, 'spades',  12, 'player_hand', v_other.id, null);

  update public.players p
  set card_count = (
    select count(*) from public.game_cards c
    where c.room_id = p_room_id
      and c.owner_player_id = p.id
      and c.zone = 'player_hand'
  )
  where p.room_id = p_room_id;

  update public.rooms
  set game_status = 'playing',
      current_player_id = v_player.id,
      turn_phase = 'must_draw',
      turn_deadline = p_turn_deadline,
      revision = revision + 1,
      updated_at = now()
  where id = p_room_id
  returning revision into v_revision;

  select jsonb_agg(id order by id) into v_cards
  from public.game_cards
  where room_id = p_room_id
    and owner_player_id = v_player.id
    and zone = 'player_hand';

  return jsonb_build_object(
    'revision', v_revision,
    'player_id', v_player.id,
    'other_player_id', v_other.id,
    'card_ids', v_cards
  );
end;
$$;

revoke all on schema test_support from public, anon, authenticated;
revoke all on all functions in schema test_support from public, anon, authenticated;
