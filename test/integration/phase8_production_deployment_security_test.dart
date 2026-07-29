import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maintenance worker requires the dedicated scheduler secret', () {
    final source = File(
      'supabase/functions/resolve-game-timeouts/index.ts',
    ).readAsStringSync();

    expect(source, contains('GAME_MAINTENANCE_SECRET'));
    expect(source, contains('x-game-maintenance-secret'));
    expect(source, contains("error: 'unauthorized'"));
  });

  test('maintenance operations execute in lifecycle order', () {
    final source = File(
      'supabase/functions/resolve-game-timeouts/index.ts',
    ).readAsStringSync();

    final presence = source.indexOf("'mark_stale_game_presence'");
    final timeouts = source.indexOf("'resolve_due_game_timeouts'");
    final cleanup = source.indexOf("'cleanup_abandoned_game_rooms'");

    expect(presence, greaterThanOrEqualTo(0));
    expect(timeouts, greaterThan(presence));
    expect(cleanup, greaterThan(timeouts));
  });

  test('authoritative tables reject direct app mutations', () {
    final sql = File(
      'supabase/migrations/'
      '202607090015_production_security_hardening.sql',
    ).readAsStringSync();

    expect(
      sql,
      contains(
        'revoke insert, update, delete on table public.rooms '
        'from anon, authenticated;',
      ),
    );
    expect(sql, contains('alter default privileges in schema public'));
  });

  test('deployment assets include function and scheduler configuration', () {
    expect(File('supabase/config.toml').existsSync(), isTrue);
    expect(File('scripts/deploy_supabase_phase8.sh').existsSync(), isTrue);
    expect(
      File('.github/workflows/game-maintenance.yml').existsSync(),
      isTrue,
    );
  });
}
