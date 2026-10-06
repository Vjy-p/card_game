import 'package:card_game/core/router/app_route.dart';
import 'package:card_game/features/onboarding/controllers/onboarding_controller.dart';
import 'package:card_game/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  setUp(() {
    Get.testMode = true;
  });

  tearDown(() {
    if (Get.isRegistered<OnboardingController>()) {
      Get.find<OnboardingController>().stopAutoScroll();
      Get.delete<OnboardingController>();
    }
    Get.reset();
  });

  testWidgets('shows the first rule and advances to the next page', (
    tester,
  ) async {
    await tester.pumpWidget(const GetMaterialApp(home: OnboardingScreen()));
    expect(
      find.text('Match the rank. Suits do not decide the set.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(
      find.text('Identical-looking cards can exist together.'),
      findsOneWidget,
    );
  });

  testWidgets('skip navigates to authentication destination', (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: AppRoute.onboarding.path,
        getPages: [
          GetPage(
            name: AppRoute.onboarding.path,
            page: () => const OnboardingScreen(),
          ),
          GetPage(
            name: AppRoute.authentication.path,
            page: () =>
                const Scaffold(body: Text('Authentication destination')),
          ),
        ],
      ),
    );
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();
    expect(find.text('Authentication destination'), findsOneWidget);
  });

  testWidgets('fits a small phone without overflow', (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const GetMaterialApp(home: OnboardingScreen()));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
