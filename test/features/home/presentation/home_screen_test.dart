import 'package:card_game/core/router/app_route.dart';
import 'package:card_game/features/home/controllers/home_controller.dart';
import 'package:card_game/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  setUp(() {
    Get.testMode = true;
    Get.put(HomeController());
  });

  tearDown(() {
    Get.delete<HomeController>();
    Get.reset();
  });

  testWidgets('shows the four primary game entry actions', (tester) async {
    await tester.pumpWidget(GetMaterialApp(home: HomeScreen()));
    expect(find.text('Play Online'), findsOneWidget);
    expect(find.text('Create Private Table'), findsOneWidget);
    expect(find.text('Join Table'), findsOneWidget);
    expect(find.text('Play Offline'), findsOneWidget);
  });

  testWidgets('navigates to matchmaking when Play Online is tapped', (
    tester,
  ) async {
    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: AppRoute.home.path,
        getPages: [
          GetPage(
            name: AppRoute.home.path,
            page: () => HomeScreen(),
          ),
          GetPage(
            name: AppRoute.publicMatchmaking.path,
            page: () =>
                const Scaffold(body: Text('Matchmaking destination')),
          ),
        ],
      ),
    );
    await tester.tap(find.text('Play Online'));
    await tester.pumpAndSettle();
    expect(find.text('Matchmaking destination'), findsOneWidget);
  });

  testWidgets('fits a small phone without horizontal overflow', (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(GetMaterialApp(home: HomeScreen()));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
