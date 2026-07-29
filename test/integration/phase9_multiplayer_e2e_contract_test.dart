import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  late String e2e;

  setUpAll(() {
    e2e = File(
      'integration_test/supabase_multiplayer_e2e_test.dart',
    ).readAsStringSync();
  });

  test('uses two independent authenticated Supabase users', () {
    expect(e2e, contains('host-\$suffix@example.com'));
    expect(e2e, contains('guest-\$suffix@example.com'));
    expect(e2e, contains('create_game_room'));
    expect(e2e, contains('join_game_room'));
  });

  test('covers revision conflict and authoritative recovery', () {
    expect(e2e, contains('revision_conflict'));
    expect(e2e, contains('recover_game_session'));
    expect(e2e, contains("'snapshot'"));
    expect(e2e, contains("'events'"));
  });

  test('covers leave flow and worker authentication', () {
    expect(e2e, contains('leave_game'));
    expect(e2e, contains('resolve-game-timeouts'));
    expect(e2e, contains('response.statusCode, 401'));
  });

  test('runner provisions local Supabase before the E2E suite', () {
    final runner = File(
      'scripts/run_supabase_multiplayer_e2e.sh',
    ).readAsStringSync();

    expect(runner, contains('supabase start'));
    expect(runner, contains('supabase status --output json'));
    expect(runner, contains('flutter test integration_test/'));
  });
}
