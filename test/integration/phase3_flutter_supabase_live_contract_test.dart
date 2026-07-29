import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Flutter snapshot RPC returns the DTO contract', () {
    final sql = File(
      'supabase/migrations/202607090009_flutter_live_snapshot_contract.sql',
    ).readAsStringSync();

    for (final field in [
      "'revision'",
      "'current_turn_player_name'",
      "'turn_seconds_remaining'",
      "'turn_phase'",
      "'players'",
      "'local_hand'",
      "'draw_pile'",
      "'discard_pile'",
    ]) {
      expect(sql, contains(field));
    }
  });

  test('repository uses authoritative snapshot and command RPCs', () {
    final source = File(
      'lib/features/game_table/data/repositories/'
      'supabase_game_table_repository.dart',
    ).readAsStringSync();

    expect(source, contains("'get_game_state_snapshot'"));
    expect(source, contains("'draw_card'"));
    expect(source, contains("'discard_card'"));
    expect(source, contains("'p_expected_revision'"));
    expect(source, contains("'p_command_id'"));
  });

  test('event DTO accepts physical event table columns', () {
    final source = File(
      'lib/features/game_table/data/dto/game_event_dto.dart',
    ).readAsStringSync();

    expect(source, contains("json['id']"));
    expect(source, contains("json['message']"));
    expect(source, contains("'card_drawn'"));
    expect(source, contains("'card_discarded'"));
  });
}
