-- Supabase Backend Phase 3 — Flutter live snapshot contract.

create or replace function public.get_game_state_snapshot(
  p_room_id text,
  p_after_revision bigint default 0
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_room public.rooms%rowtype;
  v_local_player_id bigint;
  v_now timestamptz := now();
begin
  perform public.assert_room_member(p_room_id);

  select * into v_room
  from public.rooms
  where id = p_room_id;

  if not found then
    perform public.raise_game_error('room_not_found', 'Room not found');
  end if;

  select id into v_local_player_id
  from public.players
  where room_id = p_room_id and user_id = auth.uid();

  return jsonb_build_object(
    'revision', v_room.revision,
    'current_turn_player_name', coalesce((
      select p.name from public.players p where p.id = v_room.current_player_id
    ), ''),
    'turn_seconds_remaining', greatest(
      0,
      floor(extract(epoch from (coalesce(v_room.turn_deadline, v_now) - v_now)))::integer
    ),
    'turn_phase', coalesce(v_room.turn_phase, 'waiting_for_turn'),
    'players', coalesce((
      select jsonb_agg(
        jsonb_build_object(
          'player_id', p.id,
          'display_name', p.name,
          'card_count', p.card_count,
          'is_current_turn', p.id = v_room.current_player_id,
          'is_connected', p.is_connected,
          'is_local_player', p.id = v_local_player_id
        )
        order by p.seat_index
      )
      from public.players p
      where p.room_id = p_room_id
    ), '[]'::jsonb),
    'local_hand', coalesce((
      select jsonb_agg(
        jsonb_build_object(
          'card_id', c.id,
          'rank', c.rank,
          'suit', c.suit
        )
        order by c.id
      )
      from public.game_cards c
      where c.room_id = p_room_id
        and c.zone = 'player_hand'
        and c.owner_player_id = v_local_player_id
    ), '[]'::jsonb),
    'draw_pile', jsonb_build_object(
      'cards_remaining', (
        select count(*) from public.game_cards c
        where c.room_id = p_room_id and c.zone = 'draw_pile'
      ),
      'can_draw',
        v_room.current_player_id = v_local_player_id
        and v_room.turn_phase = 'must_draw'
    ),
    'discard_pile', jsonb_build_object(
      'cards_count', (
        select count(*) from public.game_cards c
        where c.room_id = p_room_id and c.zone = 'discard_pile'
      ),
      'can_draw',
        v_room.current_player_id = v_local_player_id
        and v_room.turn_phase = 'must_draw'
        and exists (
          select 1 from public.game_cards c
          where c.room_id = p_room_id and c.zone = 'discard_pile'
        ),
      'top_card', (
        select jsonb_build_object(
          'card_id', c.id,
          'rank', c.rank,
          'suit', c.suit
        )
        from public.game_cards c
        where c.room_id = p_room_id and c.zone = 'discard_pile'
        order by c.pile_position desc
        limit 1
      )
    )
  );
end;
$$;

grant execute on function public.get_game_state_snapshot(text, bigint)
to authenticated;
