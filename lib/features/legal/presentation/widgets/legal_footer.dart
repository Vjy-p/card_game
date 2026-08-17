import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LegalFooter extends StatelessWidget {
  const LegalFooter({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      // spacing: AppSpacing.lg,
      children: [
        Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.gameTable,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.textSecondary.withValues(alpha: 0.1),
                ),
              ),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary.withValues(alpha: 0.65),
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            )
            .animate()
            .fadeIn(delay: 1200.ms, duration: 900.ms)
            .slideY(
              begin: 0.08,
              end: 0,
              duration: 900.ms,
              curve: Curves.easeOutCubic,
            ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.xl,
          ),
          child: Text(
            '© 2026 Card Game. All rights reserved.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textMuted, fontSize: 13),
          ),
        ),
      ],
    );
  }
}
