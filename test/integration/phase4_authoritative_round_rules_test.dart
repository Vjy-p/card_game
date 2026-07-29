import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  late String sql;

  setUpAll(() {
    sql = File(
      'supabase/migrations/202607090003_authoritative_round_rules.sql',
    ).readAsStringSync();
  });

  test('win declaration is revision protected and server authoritative', () {
    expect(sql, contains('p_expected_revision bigint'));
    expect(sql, contains("'revision_conflict'"));
    expect(sql, contains('return public.finish_round'));
  });

  test('complete hand rejects duplicate physical cards', () {
    expect(sql, contains('v_submitted_ids'));
    expect(sql, contains('count(distinct value)'));
    expect(sql, contains('v_total <> v_distinct_total'));
  });

  test('groups support same-rank sets and same-suit runs', () {
    expect(sql, contains('validate_same_rank_group'));
    expect(sql, contains('validate_run_group'));
    expect(sql, contains('v_suit_count = 1'));
  });

  test('round result, scores, and event share the committed revision', () {
    expect(sql, contains("game_status = 'round_ended'"));
    expect(sql, contains('calculate_player_round_penalty'));
    expect(sql, contains("'round_ended'"));
    expect(sql, contains("'scores', v_scores"));
  });
}
