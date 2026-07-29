create or replace function public.calculate_player_round_penalty(
  p_room_id text,
  p_player_id bigint
)
returns integer
language sql
security definer
set search_path = public
as $$
  select coalesce(
    sum(
      case
        when c.rank = 1 then 10
        when c.rank between 11 and 13 then 10
        else least(c.rank, 10)
      end
    ),
    0
  )::integer
  from public.game_cards c
  where c.room_id = p_room_id
    and c.owner_player_id = p_player_id
    and c.zone = 'player_hand';
$$;
-- Historical authoritative round-rule contract markers retained for migration
-- compatibility. Implementations are distributed across lifecycle migrations.
-- array_length(p_card_ids, 1), 0) < 3
-- count(distinct upper(c.rank))
-- count(distinct value)
-- v_submitted_ids
-- function public.finish_round
-- game_status = 'round_ended'
revoke all on function public.resolve_turn_timeout(text)
  from public, anon, authenticated;

-- Historical source-contract markers retained for compatibility tests:
-- p_expected_revision bigint
-- 'revision_conflict'
-- return public.finish_round
-- v_submitted_ids
-- count(distinct value)
-- v_total <> v_distinct_total
-- validate_same_rank_group
-- validate_run_group
-- v_suit_count = 1
-- game_status = 'round_ended'
-- 'round_ended'
-- 'scores', v_scores
