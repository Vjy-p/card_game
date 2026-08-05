import 'dart:developer';

import 'package:card_game/core/router/app_pages.dart';
import 'package:card_game/core/router/app_route.dart';
import 'package:card_game/core/router/bindings.dart';
import 'package:card_game/core/theme/app_theme.dart';
import 'package:card_game/firebase_options.dart';
import 'package:card_game/utils/constants/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(
    url: Constants.supabaseUrl,
    publishableKey: Constants.supabaseKey,
  );
  Supabase.instance.client.realtime.onOpen(() {
    log('Realtime OPEN');
  });

  Supabase.instance.client.realtime.onClose((v) {
    log('Realtime CLOSED $v');
  });

  Supabase.instance.client.realtime.onError((error) {
    log('Realtime ERROR: $error');
  });
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
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      getPages: AppPages.routes,
      initialRoute: AppRoute.splash.path,
      initialBinding: AppBinding(),
      builder: FToastBuilder(),
    );
  }
}
