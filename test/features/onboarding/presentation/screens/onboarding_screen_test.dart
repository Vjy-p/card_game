import 'package:card_game/core/router/app_route.dart';
import 'package:card_game/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('shows the first rule and advances to the next page', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: OnboardingScreen())));
    expect(find.text('Match the rank. Suits do not decide the set.'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Identical-looking cards can exist together.'), findsOneWidget);
  });

  testWidgets('skip navigates to authentication destination', (tester) async {
    final router = GoRouter(
      initialLocation: AppRoute.onboarding.path,
      routes: [
        GoRoute(path: AppRoute.onboarding.path, builder: (_, _) => const OnboardingScreen()),
        GoRoute(name: AppRoute.authentication.name, path: AppRoute.authentication.path, builder: (_, _) => const Scaffold(body: Text('Authentication destination'))),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(ProviderScope(child: MaterialApp.router(routerConfig: router)));
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();
    expect(find.text('Authentication destination'), findsOneWidget);
  });

  testWidgets('fits a small phone without overflow', (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: OnboardingScreen())));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
