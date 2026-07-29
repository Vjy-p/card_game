import 'package:flutter/material.dart';

abstract final class AppTypography {
  static const String? fontFamily = null;

  static TextTheme textTheme(Color primary, Color secondary) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 48,
        height: 1.05,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.5,
        color: primary,
      ),
      displayMedium: TextStyle(
        fontSize: 40,
        height: 1.1,
        fontWeight: FontWeight.w800,
        letterSpacing: -1,
        color: primary,
      ),
      headlineLarge: TextStyle(
        fontSize: 32,
        height: 1.15,
        fontWeight: FontWeight.w700,
        color: primary,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        height: 1.2,
        fontWeight: FontWeight.w700,
        color: primary,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        height: 1.25,
        fontWeight: FontWeight.w700,
        color: primary,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        height: 1.3,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        height: 1.5,
        fontWeight: FontWeight.w400,
        color: primary,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        height: 1.5,
        fontWeight: FontWeight.w400,
        color: secondary,
      ),
      labelLarge: TextStyle(
        fontSize: 16,
        height: 1.25,
        fontWeight: FontWeight.w700,
        color: primary,
      ),
      labelMedium: TextStyle(
        fontSize: 14,
        height: 1.25,
        fontWeight: FontWeight.w600,
        color: secondary,
      ),
    );
  }
}
