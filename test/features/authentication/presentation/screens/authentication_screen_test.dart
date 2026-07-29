import 'package:card_game/features/authentication/presentation/screens/authentication_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows sign-in controls', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: AuthenticationScreen())));

    expect(find.text('Sign in to continue'), findsOneWidget);
    expect(find.text('Email address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('shows validation errors for invalid submission', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: AuthenticationScreen())));

    await tester.tap(find.text('Continue'));
    await tester.pump();

    expect(find.text('Enter a valid email address'), findsOneWidget);
    expect(find.text('Password must contain at least 8 characters'), findsOneWidget);
  });

  testWidgets('switches to create-account mode', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: AuthenticationScreen())));

    await tester.tap(find.text('Create account').first);
    await tester.pump();

    expect(find.text('Create your player account'), findsOneWidget);
  });
}
