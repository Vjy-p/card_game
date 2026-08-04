import 'package:card_game/features/home/application/controllers/home_controller.dart';
import 'package:card_game/features/home/application/state/home_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/instance_manager.dart';

void main() {
  test('tracks and clears the pending home action', () {
    final controller = Get.put(HomeController());

    // addTearDown(controller);

    controller.beginAction(HomePrimaryAction.playOnline);
    expect(controller.pendingAction, HomePrimaryAction.playOnline);
    expect(controller.isBusy, true);
    controller.completeAction();
    expect(controller.pendingAction, isNull);
  });
}
