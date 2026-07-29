import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late String sql;

  setUpAll(() {
    sql = File(
      'supabase/migrations/'
      '202607090012_authoritative_gameplay_event_producers.sql',
    ).readAsStringSync();
  });

  test('event helper rejects revision drift', () {
    expect(sql, contains('v_room_revision <> p_revision'));
    expect(sql, contains('emit_authoritative_game_event'));
    expect(sql, contains('append_game_event'));
  });

  test('draw emits event with returned room revision', () {
    expect(sql, contains("'card_drawn'"));
    expect(sql, contains('p_room_id,\n    v_room.revision'));
  });

  test('discard emits event with returned room revision', () {
    expect(sql, contains("'card_discarded'"));
    expect(sql, contains("'next_player_id'"));
    expect(sql, contains("'turn_deadline'"));
  });

  test('event emission occurs before idempotency receipt persistence', () {
    final drawEvent = sql.indexOf("'card_drawn'");
    final drawReceipt = sql.indexOf(
      "p_room_id, v_user_id, p_command_id, 'draw_card'",
    );
    final discardEvent = sql.indexOf("'card_discarded'");
    final discardReceipt = sql.indexOf(
      "p_room_id, v_user_id, p_command_id, 'discard_card'",
    );

    expect(drawEvent, lessThan(drawReceipt));
    expect(discardEvent, lessThan(discardReceipt));
  });
}
