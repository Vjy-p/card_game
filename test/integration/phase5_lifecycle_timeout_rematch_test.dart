import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  late String sql;

  setUpAll(() {
    sql = File(
      'supabase/migrations/202607090010_lifecycle_timeouts_leave_rematch.sql',
    ).readAsStringSync();
  });

  test('leave game is revision protected and advances an active turn', () {
    expect(sql, contains('function public.leave_game'));
    expect(sql, contains('p_expected_revision bigint'));
    expect(sql, contains("'revision_conflict'"));
    expect(sql, contains('v_room.current_player_id = v_player.id'));
  });

  test('timeout resolver only commits when the deadline is due', () {
    expect(sql, contains('function public.resolve_turn_timeout'));
    expect(sql, contains('v_room.turn_deadline > now()'));
    expect(sql, contains("'turn_timeout'"));
  });

  test('timeout resolver is unavailable to app clients', () {
    expect(
      sql,
      contains(
        'revoke all on function public.resolve_turn_timeout(text)\n'
        '  from public, anon, authenticated;',
      ),
    );
  });

  test('rematch waits for every connected player', () {
    expect(sql, contains('rematch_requested boolean'));
    expect(sql, contains('v_ready_count = v_connected_count'));
    expect(sql, contains("'rematch_ready'"));
  });

  test(
    'disconnect state is tracked separately from permanent leave intent',
    () {
      expect(sql, contains('function public.set_game_connection_state'));
      expect(sql, contains('disconnected_at'));
    },
  );
}
