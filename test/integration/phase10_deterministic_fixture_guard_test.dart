import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('deterministic fixture is isolated from production migrations', () {
    final fixture = File(
      'supabase/test_migrations/'
      '202607090016_deterministic_game_fixtures.sql',
    );
    expect(fixture.existsSync(), isTrue);

    final production = Directory('supabase/migrations')
        .listSync()
        .whereType<File>()
        .map((file) => file.readAsStringSync())
        .join('\n');

    expect(production, isNot(contains('test_support.seed_round_fixture')));
  });

  test('phase 10 executable scenario covers all lifecycle paths', () {
    final source = File(
      'integration_test/supabase_phase10_deterministic_e2e_test.dart',
    ).readAsStringSync();

    for (final token in [
      'declare_win',
      'request_rematch',
      'resolve_turn_timeout',
      'set_game_connection_state',
      'recover_game_session',
      'leave_game',
    ]) {
      expect(source, contains(token));
    }
  });

  test('runner resets database and loads fixtures explicitly', () {
    final source = File(
      'scripts/run_supabase_phase10_e2e.sh',
    ).readAsStringSync();

    expect(source, contains('supabase db reset'));
    expect(source, contains('load_phase10_test_fixtures.sh'));
  });
}
