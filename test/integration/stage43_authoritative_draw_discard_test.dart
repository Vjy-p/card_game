import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late String sql;
  late String repository;

  setUpAll(() {
    sql = File(
      'supabase/migrations/202607090008_authoritative_draw_discard.sql',
    ).readAsStringSync();

    repository = File(
      'lib/features/game_table/data/repositories/'
      'supabase_game_table_repository.dart',
    ).readAsStringSync();
  });

  test('draw is revision-protected, turn-owned, phased, and idempotent', () {
    expect(sql, contains('v_room.revision <> p_expected_revision'));
    expect(sql, contains("v_room.turn_phase <> 'must_draw'"));
    expect(sql, contains('v_player.id <> v_room.current_player_id'));
    expect(sql, contains('game_command_receipts'));
    expect(sql, contains('command_name, response'));
  });

  test('discard verifies ownership and advances to a connected player', () {
    expect(sql, contains("zone = 'hand'"));
    expect(sql, contains('owner_player_id = v_player.id'));
    expect(sql, contains('is_connected = true'));
    expect(sql, contains("turn_phase = 'must_draw'"));
    expect(sql, contains('turn_deadline = now()'));
  });

  test('Flutter repository parameters match SQL RPCs', () {
    for (final value in [
      "'draw_card'",
      "'discard_card'",
      "'p_room_id'",
      "'p_card_id'",
      "'p_expected_revision'",
      "'p_command_id'",
    ]) {
      expect(repository, contains(value));
    }
  });
}
