import 'dart:developer';

import 'package:card_game/core/router/app_route.dart';
import 'package:flutter/foundation.dart';

class WebRouteHelper {
  static String getInitialRoute() {
    if (!kIsWeb) {
      return '/';
    }

    final path = Uri.base.path;
    final String queryParams = Uri.base.query; //
    log('web base url $path query $queryParams');

    // GitHub Pages base path:
    // https://vjy-p.github.io/card_game/...
    // const basePath = '/card_game';

    var route = queryParams;

    if (route.contains('privacy')) {
      route = AppRoute.privacy.path;
    } else if (route.contains('terms')) {
      route = AppRoute.terms.path;
    } else if (route.contains('delete')) {
      route = AppRoute.delete.path;
    } else {
      route = AppRoute.splash.path;
    }

    return route;
  }
}
