import 'dart:async';
import 'dart:developer';

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
      AppRoute.home.offAll();
    } else {
      final path = Uri.base.path;
      final String queryParams = Uri.base.query; //
      log('splash base url $path query $queryParams');

      // GitHub Pages base path:
      // https://vjy-p.github.io/card_game/...
      // const basePath = '/card_game';

      final route = queryParams;

      if (route.contains('privacy')) {
        AppRoute.privacy.offAll();
      } else if (route.contains('terms')) {
        AppRoute.terms.offAll();
      } else if (route.contains('delete')) {
        AppRoute.delete.offAll();
      } else {
        AppRoute.onboarding.offAll();
      }
    }

    initializing.value = false;
  }
}
