import 'package:card_game/core/router/app_pages.dart';
import 'package:card_game/core/theme/app_theme.dart';
import 'package:card_game/features/offline/controllers/bindings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await Supabase.initialize(url: 'https://v.supabase.co', publishableKey: 'sb');
  await GetStorage.init();
  runApp(ProviderScope(child: const CardGameApp()));
}

class CardGameApp extends ConsumerWidget {
  const CardGameApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GetMaterialApp(
      title: 'Card Game',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      getPages: AppPages.routes,
      initialBinding: OfflineBinding(),
      builder: FToastBuilder(),
    );
  }
}
