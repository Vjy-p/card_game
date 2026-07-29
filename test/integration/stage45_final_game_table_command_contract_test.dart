import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late String repository;
  late String sql;

  setUpAll(() {
    repository = File(
      'lib/features/game_table/data/repositories/'
      'supabase_game_table_repository.dart',
    ).readAsStringSync();

    sql = File(
      'supabase/migrations/202607090009_draw_source_compatibility.sql',
    ).readAsStringSync();
  });

  test('existing repository directly owns final draw contract', () {
    expect(repository, contains("'draw_card'"));
    expect(repository, contains("'p_source'"));
    expect(repository, contains("'p_expected_revision'"));
    expect(repository, contains("'p_command_id'"));
    expect(repository, contains('DrawSource.closedPile'));
  });

  test('existing repository directly owns final discard contract', () {
    expect(repository, contains("'discard_card'"));
    expect(repository, contains("'p_card_id'"));
    expect(repository, contains("'p_command_id'"));
  });

  test('SQL supports both closed and open pile draw sources', () {
    expect(sql, contains("'closed_pile'"));
    expect(sql, contains("'open_pile'"));
    expect(sql, contains("zone = 'draw_pile'"));
    expect(sql, contains("zone = 'discard_pile'"));
  });

  test('temporary command adapter architecture is removed', () {
    expect(
      File(
        'lib/features/game_table/data/repositories/'
        'authoritative_game_table_commands.dart',
      ).existsSync(),
      isFalse,
    );
    expect(
      File(
        'lib/features/game_table/presentation/controllers/'
        'authoritative_table_action_bridge.dart',
      ).existsSync(),
      isFalse,
    );
  });

  test('new server errors map into existing domain failure model', () {
    expect(repository, contains('revision_conflict'));
    expect(repository, contains('not_your_turn'));
    expect(repository, contains('invalid_phase'));
    expect(repository, contains('card_not_owned'));
  });
}
