import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  late String sql;

  setUpAll(() {
    sql = File(
      'supabase/migrations/'
      '202607100002_matchmaking_public_private_rejoin.sql',
    ).readAsStringSync();
  });

  test('supports public, private, and matchmaking table modes', () {
    expect(sql, contains("'private', 'public', 'matchmaking'"));
    expect(sql, contains('create_table'));
    expect(sql, contains('list_public_tables'));
    expect(sql, contains('join_matchmaking'));
  });

  test('matchmaking uses locked oldest compatible room', () {
    expect(sql, contains('order by r.created_at'));
    expect(sql, contains('for update skip locked'));
    expect(sql, contains('p_max_players'));
  });

  test('private invites use opaque tokens', () {
    expect(sql, contains('invite_token uuid'));
    expect(sql, contains('get_private_invite'));
    expect(sql, contains('join_private_invite'));
  });

  test('rejoin discovery only returns active memberships', () {
    expect(sql, contains('discover_rejoinable_sessions'));
    expect(sql, contains("r.game_status in ('waiting', 'playing')"));
    expect(sql, contains('p.user_id = auth.uid()'));
  });

  test('new entry RPCs use backend rate limiting', () {
    expect(sql, contains("enforce_rpc_rate_limit('create_table'"));
    expect(sql, contains("enforce_rpc_rate_limit('join_public_table'"));
    expect(sql, contains("enforce_rpc_rate_limit('join_matchmaking'"));
  });
}
