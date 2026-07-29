import 'package:card_game/features/home/application/controllers/home_controller.dart';
import 'package:card_game/features/home/application/state/home_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('tracks and clears the pending home action', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final controller = container.read(homeControllerProvider.notifier);

    controller.beginAction(HomePrimaryAction.playOnline);
    expect(container.read(homeControllerProvider).pendingAction, HomePrimaryAction.playOnline);

    controller.completeAction();
    expect(container.read(homeControllerProvider).pendingAction, isNull);
  });
}
