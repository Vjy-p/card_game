import 'dart:developer';
import 'dart:ui';

import 'package:card_game/core/router/app_pages.dart';
import 'package:card_game/core/router/bindings.dart';
import 'package:card_game/core/router/web_route_helper.dart';
import 'package:card_game/core/theme/app_theme.dart';
import 'package:card_game/firebase_options.dart';
import 'package:card_game/utils/constants/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(
    url: Constants.supabaseUrl,
    publishableKey: Constants.supabaseKey,
  );
  await GoogleSignIn.instance.initialize(
    serverClientId: kIsWeb ? null : Constants.googleServerClientKey,
  );
  usePathUrlStrategy();
  Supabase.instance.client.realtime.onOpen(() {
    log('Realtime OPEN');
  });

  Supabase.instance.client.realtime.onClose((v) {
    log('Realtime CLOSED $v');
  });

  Supabase.instance.client.realtime.onError((error) {
    log('Realtime ERROR: $error');
  });

  if (!kIsWeb) {
    MobileAds.instance.initialize();
  }

  await GetStorage.init();
  runApp(const CardGameApp());
}

class CardGameApp extends StatelessWidget {
  const CardGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Card Game',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      scrollBehavior: MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.stylus,
          PointerDeviceKind.touch,
          PointerDeviceKind.trackpad,
          PointerDeviceKind.unknown,
        },
      ),
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      getPages: AppPages.routes,
      initialRoute: WebRouteHelper.getInitialRoute(),
      initialBinding: AppBinding(),
      builder: FToastBuilder(),
    );
  }
}
