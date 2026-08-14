import 'dart:developer';

import 'package:card_game/core/router/app_route.dart';
import 'package:card_game/core/services/common_services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class CanGoBack {
  static void go() {
    log(
      'can go back ${Navigator.canPop(Get.context!)} ${Get.previousRoute} ${Get.previousRoute.isNotEmpty} ',
    );
    if (Navigator.canPop(Get.context!) ||
        ((Get.previousRoute.isNotEmpty || Get.previousRoute.isNotEmpty))) {
      Get.back();
    } else {
      if (CommonServices.getUserId().isNotEmpty) {
        AppRoute.home.offAll();
      } else {
        AppRoute.splash.offAll();
      }
    }
  }
}
