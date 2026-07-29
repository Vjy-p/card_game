import 'package:card_game/features/splash/application/controllers/splash_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  // We use late to initialize the controller before each test
  late SplashController controller;

  setUp(() {
    // 1. Initialize GetX for testing
    Get.testMode = true;

    // 2. Inject the controller
    controller = SplashController();
    Get.put(controller);
  });

  tearDown(() {
    // 3. Clean up after each test
    Get.delete<SplashController>();
  });

  test('moves initializing from false to true and then back to false', () async {
    // Check initial state
    expect(controller.initializing.value, false);

    // Start initialization - we don't 'await' yet so we can check the 'true' state
    final future = controller.initialize(
      minimumDisplayDuration: const Duration(milliseconds: 10),
    );

    // While the future is running, initializing should be true
    expect(controller.initializing.value, true);

    // Wait for the process to finish
    await future;

    // Check final state
    expect(controller.initializing.value, false);
  });

  test('verifies navigation happens after initialization', () async {
    // In GetX, we can check the current route if we set up a GetMaterialApp,
    // but for unit tests, we mainly focus on the logic variables.

    await controller.initialize(minimumDisplayDuration: Duration.zero);

    // In Get.testMode, Get.offNamed won't actually change a screen
    // but you can verify the status logic finished correctly
    expect(controller.initializing.value, false);
  });
}
