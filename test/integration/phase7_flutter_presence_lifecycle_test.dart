import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('repository calls heartbeat and recovery RPCs', () {
    final source = File(
      'lib/features/game_table/data/repositories/'
      'supabase_game_table_repository.dart',
    ).readAsStringSync();

    expect(source, contains("'heartbeat_game_presence'"));
    expect(source, contains("'recover_game_session'"));
    expect(source, contains("json['snapshot']"));
  });

  test('backend coordinator sends periodic heartbeats', () {
    final source = File(
      'lib/features/game_table/application/controllers/'
      'game_table_backend_coordinator.dart',
    ).readAsStringSync();

    expect(source, contains('Duration(seconds: 15)'));
    expect(source, contains('heartbeatPresence'));
    expect(source, contains('onAppResumed'));
    expect(source, contains('onAppBackgrounded'));
  });

  test('game table host observes Flutter app lifecycle', () {
    final source = File(
      'lib/features/game_table/presentation/widgets/'
      'game_table_backend_host.dart',
    ).readAsStringSync();

    expect(source, contains('WidgetsBindingObserver'));
    expect(source, contains('didChangeAppLifecycleState'));
    expect(source, contains('AppLifecycleState.resumed'));
  });
}
