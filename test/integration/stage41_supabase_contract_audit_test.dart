import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Map<String, dynamic> contract;
  late String repository;
  late String migration;

  setUpAll(() {
    contract = jsonDecode(
      File('docs/backend/rpc_contract_registry.json').readAsStringSync(),
    ) as Map<String, dynamic>;

    repository = File(
      'lib/features/room/data/repositories/'
      'supabase_room_repository.dart',
    ).readAsStringSync();

    migration = File(
      'supabase/migrations/202607090006_schema_rpc_compatibility.sql',
    ).readAsStringSync();
  });

  test('room repository RPC names match the registered contract', () {
    for (final name in [
      'create_game_room',
      'join_game_room',
      'get_room_lobby_snapshot',
      'start_game',
    ]) {
      expect(contract.containsKey(name), isTrue);
      expect(repository, contains("'$name'"));
    }
  });

  test('room repository parameter names match the contract', () {
    for (final param in [
      'p_display_name',
      'p_join_code',
      'p_room_id',
      'p_expected_revision',
    ]) {
      expect(repository, contains("'$param'"));
    }
  });

  test('compatibility migration stabilizes required columns', () {
    for (final column in [
      'join_code',
      'host_user_id',
      'max_players',
      'revision',
      'game_status',
      'seat_index',
      'is_connected',
      'card_count',
    ]) {
      expect(migration, contains(column));
    }
  });

  test('timeout resolver is service-role only', () {
    expect(
      migration,
      contains(
        'revoke all on function public.resolve_turn_timeout(text) '
        'from public, anon, authenticated',
      ),
    );
    expect(
      migration,
      contains(
        'grant execute on function public.resolve_turn_timeout(text) '
        'to service_role',
      ),
    );
  });
}
