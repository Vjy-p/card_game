import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('accessible pile widgets keep the established callback contract', () {
    final draw = File(
      'lib/features/game_table/presentation/widgets/'
      'accessible_draw_pile.dart',
    ).readAsStringSync();
    final discard = File(
      'lib/features/game_table/presentation/widgets/'
      'accessible_discard_pile.dart',
    ).readAsStringSync();

    expect(draw, contains('required this.onDrawRequested'));
    expect(discard, contains('required this.onDrawRequested'));
    expect(draw, isNot(contains('onAuthoritativeDraw')));
    expect(discard, isNot(contains('onAuthoritativeDraw')));
  });

  test('Flame pile components keep one callback path', () {
    for (final path in [
      'lib/features/game_table/presentation/flame/components/'
          'closed_draw_pile_component.dart',
      'lib/features/game_table/presentation/flame/components/'
          'open_discard_pile_component.dart',
    ]) {
      final source = File(path).readAsStringSync();
      expect(source, contains('required this.onDrawRequested'));
      expect(source, contains('onDrawRequested()'));
      expect(source, isNot(contains('onAuthoritativeDraw')));
    }
  });

  test('backend actions delegate to the existing authoritative coordinator', () {
    final source = File(
      'lib/features/game_table/presentation/controllers/'
      'game_table_backend_actions.dart',
    ).readAsStringSync();

    expect(source, contains('gameTableBackendCoordinatorProvider'));
    expect(source, contains('_coordinator.draw(DrawSource.closedPile)'));
    expect(source, contains('_coordinator.draw(DrawSource.openPile)'));
    expect(source, contains('_coordinator.discardSelected()'));
  });

  test('temporary duplicate action architecture is removed', () {
    expect(
      File(
        'lib/features/game_table/presentation/controllers/'
        'game_table_action_controller.dart',
      ).existsSync(),
      isFalse,
    );
    expect(
      File(
        'lib/features/game_table/presentation/controllers/'
        'game_table_authoritative_callbacks.dart',
      ).existsSync(),
      isFalse,
    );
  });
}
