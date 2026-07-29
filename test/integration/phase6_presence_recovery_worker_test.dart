import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('presence and recovery RPCs are authenticated', () {
    final sql = File(
      'supabase/migrations/202607090014_presence_recovery_cleanup.sql',
    ).readAsStringSync();

    expect(sql, contains('heartbeat_game_presence'));
    expect(sql, contains('recover_game_session'));
    expect(sql, contains('last_seen_at'));
    expect(sql, contains("'snapshot'"));
    expect(sql, contains("'events'"));
  });

  test('maintenance RPCs are unavailable to app clients', () {
    final sql = File(
      'supabase/migrations/202607090014_presence_recovery_cleanup.sql',
    ).readAsStringSync();

    expect(sql, contains('resolve_due_game_timeouts'));
    expect(sql, contains('cleanup_abandoned_game_rooms'));
    expect(sql, contains('from public, anon, authenticated'));
  });

  test('timeout worker uses service-role credentials', () {
    final source = File(
      'supabase/functions/resolve-game-timeouts/index.ts',
    ).readAsStringSync();

    expect(source, contains('SUPABASE_SERVICE_ROLE_KEY'));
    expect(source, contains("client.rpc('mark_stale_game_presence'"));
    expect(source, contains("client.rpc('resolve_due_game_timeouts'"));
    expect(source, contains("client.rpc('cleanup_abandoned_game_rooms'"));
  });
}
