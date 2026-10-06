import 'package:card_game/features/home/controllers/home_controller.dart';
import 'package:card_game/features/home/models/home_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  setUp(() {
    Get.testMode = true;
  });

  tearDown(() {
    Get.delete<HomeController>();
    Get.reset();
  });

  test('tracks and clears the pending home action', () {
    final controller = Get.put(HomeController());

    controller.beginAction(HomePrimaryAction.playOnline);
    expect(controller.pendingAction.value, HomePrimaryAction.playOnline);
    expect(controller.isBusy, true);
    controller.completeAction();
    expect(controller.pendingAction.value, isNull);
  });
}
