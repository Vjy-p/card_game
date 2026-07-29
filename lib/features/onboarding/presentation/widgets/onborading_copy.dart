import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/core/theme/app_spacing.dart';
import 'package:card_game/features/onboarding/domain/entities/onboarding_page_content.dart';
import 'package:flutter/material.dart';

class OnboardingCopy extends StatelessWidget {
  const OnboardingCopy({super.key, required this.content});
  final OnboardingPageContent content;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          content.eyebrow,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.actionPrimary,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(content.title, style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: AppSpacing.md),
        Text(
          content.description,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    ),
  );
}
