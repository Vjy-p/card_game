import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late String coordinator;
  late String classifier;

  setUpAll(() {
    coordinator = File(
      'lib/features/game_table/application/controllers/'
      'game_table_backend_coordinator.dart',
    ).readAsStringSync();

    classifier = File(
      'lib/features/game_table/application/errors/'
      'game_table_command_error_classifier.dart',
    ).readAsStringSync();
  });

  test('revision conflicts are classified centrally', () {
    expect(classifier, contains('revision_conflict'));
    expect(classifier, contains('stale_revision'));
  });

  test('coordinator recovers revision conflicts through synchronization', () {
    expect(coordinator, contains('GameTableCommandErrorClassifier'));
    expect(coordinator, contains('_recoverRevisionConflict'));
    expect(coordinator, contains('retrySynchronization'));
  });

  test('coordinator does not optimistically mutate authoritative state', () {
    expect(coordinator, isNot(contains('hand.add')));
    expect(coordinator, isNot(contains('hand.remove')));
    expect(coordinator, isNot(contains('revision++')));
    expect(coordinator, isNot(contains('currentPlayerId =')));
  });

  test('backend coordinator remains the single UI command owner', () {
    expect(
      File(
        'lib/features/game_table/presentation/controllers/'
        'game_table_action_controller.dart',
      ).existsSync(),
      isFalse,
    );
  });
}
