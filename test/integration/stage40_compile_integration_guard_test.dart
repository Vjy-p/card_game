import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('no production Dart file imports deleted pre-game artifacts', () {
    final deletedNames = [
      'create_private_table_controller.dart',
      'create_private_table_state.dart',
      'join_table_controller.dart',
      'join_table_state.dart',
      'backend_room_flow_screen.dart',
      'designed_room_entry_screen.dart',
      'backend_lobby_bridge.dart',
      'backend_lobby_screen_binding.dart',
    ];

    for (final file in Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'))) {
      final source = file.readAsStringSync();
      for (final deletedName in deletedNames) {
        expect(source, isNot(contains(deletedName)), reason: file.path);
      }
    }
  });

  test('room lobby controller disposes subscription through StateNotifier', () {
    final source = File(
      'lib/features/room/application/controllers/'
      'room_lobby_controller.dart',
    ).readAsStringSync();

    expect(source, contains('_revisionSubscription?.cancel()'));
    expect(source, contains('super.dispose()'));
  });

  test('room join validates identity and display name server-side', () {
    final sql = File(
      'supabase/migrations/202607090005_room_lobby_and_game_start.sql',
    ).readAsStringSync();

    expect(sql, contains('v_user_id is null'));
    expect(sql, contains('length(trim(p_display_name)) = 0'));
  });
}
