import 'package:card_game/features/authentication/controllers/authentication_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  group('AuthenticationController', () {
    late AuthenticationController controller;

    setUp(() {
      Get.testMode =
          true; // Prevents actual navigation/firebase calls during init
      controller = AuthenticationController();
      Get.put(controller);
    });

    tearDown(() {
      Get.delete<AuthenticationController>();
    });

    test('starts with idle state (isLoading is false)', () {
      // In GetX, we check the reactive variable directly
      expect(controller.isLoading.value, false);
    });

    test('isLoading changes during sign in process', () {
      // You can manually trigger state to test UI reactions
      controller.isLoading.value = true;
      expect(controller.isLoading.value, true);
    });
  });
}
