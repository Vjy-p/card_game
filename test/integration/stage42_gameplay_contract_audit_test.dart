import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Map<String, dynamic> contract;
  late String migration;

  setUpAll(() {
    contract = jsonDecode(
      File(
        'docs/backend/gameplay_state_machine_contract.json',
      ).readAsStringSync(),
    ) as Map<String, dynamic>;

    migration = File(
      'supabase/migrations/202607090007_gameplay_contract_guards.sql',
    ).readAsStringSync();
  });

  test('contract covers the complete authoritative gameplay lifecycle', () {
    final commands = contract['commands'] as Map<String, dynamic>;

    for (final command in [
      'draw_card',
      'discard_card',
      'resolve_turn_timeout',
      'declare_win',
      'request_rematch',
      'leave_game',
      'reconnect_game',
      'get_game_snapshot',
    ]) {
      expect(commands.containsKey(command), isTrue, reason: command);
    }
  });

  test('turn phases are explicit and mutually constrained', () {
    expect(
      contract['turn_phases'],
      containsAll(['must_draw', 'must_discard']),
    );
    expect(migration, contains('rooms_turn_phase_check'));
  });

  test('room lifecycle statuses are constrained', () {
    for (final status in [
      'waiting',
      'playing',
      'round_complete',
      'finished',
    ]) {
      expect(migration, contains("'$status'"));
    }
  });

  test('timeout resolver remains service-role only', () {
    expect(migration, contains('resolve_turn_timeout(text)'));
    expect(migration, contains('to service_role'));
  });

  test('clients cannot directly mutate game-critical room state', () {
    expect(migration, contains('revoke update'));
    expect(migration, contains('game_status'));
    expect(migration, contains('turn_phase'));
    expect(migration, contains('turn_deadline'));
    expect(migration, contains('revision'));
  });
}
