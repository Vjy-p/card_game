import 'package:card_game/features/authentication/controllers/authentication_controller.dart';
import 'package:card_game/features/authentication/presentation/screens/authentication_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  setUp(() {
    Get.testMode = true;
    Get.put(AuthenticationController());
  });

  tearDown(() {
    Get.delete<AuthenticationController>();
    Get.reset();
  });

  testWidgets('shows welcome and sign-in info', (tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: AuthenticationScreen()));

    expect(find.text('WELCOME TO THE TABLE'), findsOneWidget);
    expect(find.text('Play with friends'), findsOneWidget);
    expect(
      find.text('Join multiplayer rooms and continue your games anytime.'),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) => widget is RichText && widget.text.toPlainText().contains('Terms'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('shows brand panel on wide screen', (tester) async {
    tester.view.physicalSize = const Size(1000, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const GetMaterialApp(home: AuthenticationScreen()));

    expect(find.text('Your table is waiting.'), findsOneWidget);
    expect(find.text('WELCOME TO THE TABLE'), findsOneWidget);
  });

  testWidgets('fits small screen without overflow', (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const GetMaterialApp(home: AuthenticationScreen()));
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}
