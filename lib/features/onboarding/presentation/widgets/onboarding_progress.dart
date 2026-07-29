import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/core/theme/app_motion.dart';
import 'package:card_game/core/theme/app_radius.dart';
import 'package:flutter/material.dart';

class OnboardingProgress extends StatelessWidget {
  const OnboardingProgress({required this.currentIndex, required this.count, super.key});
  final int currentIndex;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Onboarding progress',
      value: 'Step ${currentIndex + 1} of $count',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(count, (index) {
          final selected = index == currentIndex;
          return AnimatedContainer(
            duration: MediaQuery.disableAnimationsOf(context) ? Duration.zero : AppMotion.fast,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: selected ? 28 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: selected ? AppColors.actionPrimary : AppColors.borderSubtle,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
          );
        }),
      ),
    );
  }
}
