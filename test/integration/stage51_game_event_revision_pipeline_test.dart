import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late String event;
  late String coordinator;
  late String migration;

  setUpAll(() {
    event = File(
      'lib/features/game_table/domain/entities/game_event.dart',
    ).readAsStringSync();

    coordinator = File(
      'lib/features/game_table/application/controllers/'
      'game_table_backend_coordinator.dart',
    ).readAsStringSync();

    migration = File(
      'supabase/migrations/202607090010_game_event_revision_metadata.sql',
    ).readAsStringSync();
  });

  test('GameEvent exposes stable authoritative revision metadata', () {
    expect(event, contains('required this.revision'));
    expect(event, contains('final int revision'));
  });

  test('event stream rejects duplicates and resynchronizes gaps', () {
    expect(coordinator, contains('incomingRevision: event.revision'));
    expect(coordinator, contains('ignoreDuplicateOrOld'));
    expect(coordinator, contains('resynchronizeGap'));
    expect(coordinator, contains('await synchronize()'));
  });

  test('database enforces room-local event revision ordering', () {
    expect(migration, contains('alter column revision set not null'));
    expect(migration, contains('(room_id, revision)'));
    expect(migration, contains('normalize_game_event_revision_trigger'));
  });

  test('event payload remains revision-compatible', () {
    expect(
      migration,
      contains("jsonb_build_object('revision', new.revision)"),
    );
  });
}
