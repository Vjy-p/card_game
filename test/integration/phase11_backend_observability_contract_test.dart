import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('phase 11 operational storage stays private', () {
    final sql = File(
      'supabase/migrations/'
      '202607100001_observability_rate_limits_health.sql',
    ).readAsStringSync();

    expect(sql, contains('backend_audit_log'));
    expect(sql, contains('rpc_rate_limits'));
    expect(sql, contains('enable row level security'));
    expect(sql, contains('backend_health()'));
    expect(sql, contains('cleanup_backend_operational_data()'));
  });

  test('health endpoint requires secret and emits request ids', () {
    final source = File(
      'supabase/functions/backend-health/index.ts',
    ).readAsStringSync();

    expect(source, contains('x-maintenance-secret'));
    expect(source, contains('crypto.randomUUID()'));
    expect(source, contains('backend_health'));
  });
}
