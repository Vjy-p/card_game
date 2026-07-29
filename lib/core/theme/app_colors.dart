import 'package:flutter/material.dart';

abstract final class AppColors {
  // Backgrounds
  static const backgroundPrimary = Color(0xFF0F0C1D); // Deep Midnight Blue
  static const backgroundSecondary = Color(0xFF1B1731);

  // The Table
  static const surfacePrimary = Color(0xFF252142);
  static const surfaceElevated = Color(0xFF322C59);
  static const gameTable = Color(0xFF1E1B33); // Darker, neutral felt

  // Actions & Accents
  static const actionPrimary = Color(0xFF00F5FF); // Electric Cyan
  static const actionPrimaryForeground = Color(0xFF0F0C1D);
  static const accent = Color(0xFFBD00FF); // Neon Purple

  // Text
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFF9E99C2);
  static const textMuted = Color(0xFF635E85);

  // Card Colors
  static const cardRed = Color(0xFFFF2E63); // Neon Pink-Red
  static const cardBlack = Color(0xFF080808);

  static const success = Color(0xFF00FFAB);
  static const error = Color(0xFFFF005C);

  static const borderSubtle = Color(0xFF27483D);

  static const lightBackground = Color(0xFFF4F7F5);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightTextPrimary = Color(0xFF10201A);
  static const lightTextSecondary = Color(0xFF4C6259);

  // static const cardRed = Color(0xFFC92A2A);
  // static const cardBlack = Color(0xFF111111);

  // Proper blue felt table colors
  static const Color tableDark = Color.fromARGB(255, 27, 30, 77); // Rich Blue
  static const Color darkBlue = Color.fromARGB(
    255,
    13,
    16,
    40,
  ); // Deep blue for shadow
  static const Color lightGreen = Color.fromARGB(
    255,
    42,
    44,
    106,
  ); // Lighter green for accents

  static const Color gold = Color(0xFFD4AF37);

  static const Color border = Color(0xFF3E2723);

  static const Color cardShadow = Colors.black26;
  static const List<Color> colorsList = [
    Color(0xFFFFFF00),
    textMuted,
    Color(0xFF00FF00),
    Color(0xFF0033FF),
    Color(0xFFFF0000),
    actionPrimary,
    accent,
  ];
}
