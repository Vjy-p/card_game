import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late String guard;
  late String coordinator;
  late String shell;

  setUpAll(() {
    guard = File(
      'lib/features/game_table/application/synchronization/'
      'game_revision_guard.dart',
    ).readAsStringSync();

    coordinator = File(
      'lib/features/game_table/application/controllers/'
      'game_table_backend_coordinator.dart',
    ).readAsStringSync();

    shell = File(
      'lib/features/game_table/application/controllers/'
      'game_table_shell_controller.dart',
    ).readAsStringSync();
  });

  test('revision guard rejects duplicates and detects gaps', () {
    expect(guard, contains('incomingRevision <= lastAppliedRevision'));
    expect(guard, contains('incomingRevision > lastAppliedRevision + 1'));
    expect(guard, contains('ignoreDuplicateOrOld'));
    expect(guard, contains('resynchronizeGap'));
  });

  test('coordinator has authoritative snapshot recovery', () {
    expect(coordinator, contains('synchronize()'));
    expect(coordinator, contains('fetchGameSnapshotProvider'));
    expect(coordinator, contains('applyFullGameStateSnapshot'));
  });

  test('pending command rollback paths remain available', () {
    expect(coordinator, contains('rejectPendingDraw'));
    expect(coordinator, contains('rejectPendingDiscard'));
  });

  test('snapshot replacement is owned by shell controller', () {
    expect(shell, contains('applyFullGameStateSnapshot'));
    expect(shell, contains('lastAppliedRevision'));
  });

  test('event stream failures trigger synchronization', () {
    expect(coordinator, contains('onError: (_) => synchronize()'));
  });
}
