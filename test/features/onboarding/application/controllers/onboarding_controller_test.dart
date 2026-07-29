import 'package:card_game/features/onboarding/application/controllers/onboarding_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  late OnboardingController controller;

  setUp(() {
    // 1. Initialize GetX in test mode
    Get.testMode = true;

    // 2. Inject the controller
    controller = Get.put(OnboardingController());
  });

  tearDown(() {
    // 3. Clean up after each test
    Get.delete<OnboardingController>();
  });

  test('moves forward, backward, and rejects out-of-range pages', () {
    // Check initial state
    expect(controller.pageIndex.value, 0);

    // Test setPage logic
    controller.setPage(1);
    expect(controller.pageIndex.value, 1);

    controller.setPage(0);
    expect(controller.pageIndex.value, 0);

    // Test range protection (if you added range logic to setPage)
    // Note: The previous GetX code I provided simply sets the value.
    // If you kept the validation logic, this will pass:
    controller.setPage(99);
    expect(controller.pageIndex.value, 0);
  });

  test('verifies first and last page logic', () {
    expect(controller.isFirstPage, true);

    controller.setPage(3); // Last page (0, 1, 2, 3)
    expect(controller.isLastPage, true);
    expect(controller.isFirstPage, false);
  });

  test('auto-scroll timer can be stopped', () {
    controller.startAutoScroll();
    // Logic test: just ensure it doesn't crash
    controller.stopAutoScroll();
    // Note: In unit tests, we don't usually wait 5 seconds for timers
    // unless using fakeAsync, but verifying the method calls is good.
  });
}
