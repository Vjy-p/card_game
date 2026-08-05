import 'package:card_game/core/theme/app_spacing.dart';
import 'package:card_game/features/onboarding/models/onboarding_page_content.dart';
import 'package:card_game/features/onboarding/presentation/widgets/onboarding_visual.dart';
import 'package:card_game/features/onboarding/presentation/widgets/onborading_copy.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    required this.content,
    required this.horizontalPadding,
  });
  final OnboardingPageContent content;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 760;
        final visual = OnboardingVisual(type: content.visualType);
        final copy = OnboardingCopy(content: content);
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: AppSpacing.md,
          ),
          child: wide
              ? Row(
                  children: [
                    Expanded(child: visual),
                    const SizedBox(width: AppSpacing.xxl),
                    Expanded(child: copy),
                  ],
                )
              : Column(
                  children: [
                    visual,
                    const SizedBox(height: AppSpacing.xl),
                    copy,
                  ],
                ),
        );
      },
    );
  }
}
