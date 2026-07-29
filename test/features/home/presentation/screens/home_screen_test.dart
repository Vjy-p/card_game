import 'package:card_game/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('shows the four primary game entry actions', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: HomeScreen())));
    expect(find.text('Play Online'), findsOneWidget);
    expect(find.text('Create Private Table'), findsOneWidget);
    expect(find.text('Join Table'), findsOneWidget);
    expect(find.text('Play Offline'), findsOneWidget);
  });

  testWidgets('navigates to matchmaking when Play Online is tapped', (tester) async {
    final router = GoRouter(routes: [
      GoRoute(path: '/', builder: (_, _) => const HomeScreen()),
      GoRoute(name: 'public-matchmaking', path: '/matchmaking', builder: (_, _) => const Scaffold(body: Text('Matchmaking destination'))),
    ]);
    await tester.pumpWidget(ProviderScope(child: MaterialApp.router(routerConfig: router)));
    await tester.tap(find.text('Play Online'));
    await tester.pumpAndSettle();
    expect(find.text('Matchmaking destination'), findsOneWidget);
  });

  testWidgets('fits a small phone without horizontal overflow', (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: HomeScreen())));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
