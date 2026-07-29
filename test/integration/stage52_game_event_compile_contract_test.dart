import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('GameEvent DTO maps revision into the domain entity', () {
    final source = File(
      'lib/features/game_table/data/dto/game_event_dto.dart',
    ).readAsStringSync();

    expect(source, contains('required this.revision'));
    expect(source, contains('final int revision'));
    expect(source, contains('revision: revision'));
  });

  test('all production GameEvent constructors provide revision', () {
    final missing = <String>[];

    for (final file in Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'))) {
      final source = file.readAsStringSync();
      final matches = RegExp(r'\bGameEvent\s*\(').allMatches(source);

      for (final match in matches) {
        final end = (match.start + 900).clamp(0, source.length);
        final tail = source.substring(match.start, end);
        if (!tail.contains('revision:')) {
          missing.add(file.path);
        }
      }
    }

    expect(missing, isEmpty);
  });

  test('database exposes one stable event producer helper', () {
    final sql = File(
      'supabase/migrations/'
      '202607090011_game_event_producer_compatibility.sql',
    ).readAsStringSync();

    expect(sql, contains('public.append_game_event'));
    expect(sql, contains('p_revision bigint'));
    expect(sql, contains("jsonb_build_object('revision', p_revision)"));
  });
}
