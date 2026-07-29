import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late String sql;
  late String registry;

  setUpAll(() {
    sql = File(
      'supabase/migrations/'
      '202607090013_lifecycle_rpc_exact_revision_events.sql',
    ).readAsStringSync();

    registry = File(
      'docs/backend/stage54_lifecycle_rpc_exact_revision_registry.md',
    ).readAsStringSync();
  });

  test('lifecycle helper reads the current authoritative room revision', () {
    expect(sql, contains('select revision'));
    expect(sql, contains('from public.rooms'));
    expect(sql, contains('for share'));
  });

  test('lifecycle helper delegates to revision-drift checked emitter', () {
    expect(sql, contains('emit_authoritative_game_event'));
    expect(sql, contains("jsonb_build_object('revision', v_revision)"));
  });

  test('all target lifecycle RPCs are tracked by real definition', () {
    for (final rpc in [
      'resolve_turn_timeout',
      'declare_win',
      'leave_game',
      'request_rematch',
    ]) {
      expect(registry, contains('`$rpc`'));
    }
  });

  test('migration documents mutation-before-event ordering', () {
    expect(sql, contains('revision = revision + 1'));
    expect(sql, contains('persist command receipt'));
  });
}
