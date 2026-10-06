import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/core/theme/app_radius.dart';
import 'package:card_game/core/theme/app_spacing.dart';
import 'package:card_game/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static final ThemeData dark = _buildDark();

  static ThemeData _buildDark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.backgroundSecondary,
      brightness: Brightness.dark,
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
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: AppColors.backgroundPrimary,
        surfaceTintColor: AppColors.backgroundSecondary,
      ),
      bottomAppBarTheme: const BottomAppBarThemeData(
        color: AppColors.backgroundPrimary,
        surfaceTintColor: AppColors.backgroundSecondary,
      ),
      cardTheme: const CardThemeData(color: AppColors.surfacePrimary),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.actionPrimary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gameTable,
          padding: const EdgeInsets.symmetric(
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
