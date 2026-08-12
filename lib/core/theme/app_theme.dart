import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/core/theme/app_radius.dart';
import 'package:card_game/core/theme/app_spacing.dart';
import 'package:card_game/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.backgroundSecondary,
      brightness: Brightness.dark,
      // primary: AppColors.textMuted,
      // onPrimary: AppColors.textSecondary,
      // secondary: AppColors.actionPrimaryForeground,
      // surface: AppColors.surfacePrimary,
      // onSurface: AppColors.textSecondary,
      // error: AppColors.error,
      // surfaceContainerLow: AppColors.textMuted,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.backgroundPrimary,
      fontFamily: AppTypography.fontFamily,
      textTheme: AppTypography.textTheme(
        AppColors.textPrimary,
        AppColors.textSecondary,
      ),
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundPrimary,
        surfaceTintColor: AppColors.backgroundSecondary,
      ),
      bottomAppBarTheme: BottomAppBarThemeData(
        color: AppColors.backgroundPrimary,
        surfaceTintColor: AppColors.backgroundSecondary,
      ),
      cardTheme: CardThemeData(color: AppColors.surfacePrimary),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.actionPrimary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gameTable,
          // minimumSize: const Size(42, 52),
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),
    );
  }
}
