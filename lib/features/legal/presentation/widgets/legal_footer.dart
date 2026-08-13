import 'package:card_game/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LegalFooter extends StatelessWidget {
  const LegalFooter({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.gameTable,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.textSecondary.withValues(alpha: 0.05),
            ),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary.withValues(alpha: 0.55),
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
        );
  }
}
