import 'dart:async';

import 'package:card_game/core/router/app_route.dart';
import 'package:card_game/core/services/common_services.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  RxBool initializing = false.obs;

  Future<void> initialize({
    Duration minimumDisplayDuration = const Duration(milliseconds: 900),
  }) async {
    initializing.value = true;

    await Future.delayed(minimumDisplayDuration);
    if (CommonServices.getUserName().isNotEmpty) {
      Get.offNamed(AppRoute.home.path);
    } else {
      Get.offNamed(AppRoute.onboarding.path);
    }

    initializing.value = false;
  }
}
