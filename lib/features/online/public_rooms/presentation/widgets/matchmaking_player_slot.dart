import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class MatchmakingPlayerSlot extends StatelessWidget {
  const MatchmakingPlayerSlot({required this.index, required this.isFilled, super.key});

  final int index;
  final bool isFilled;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: isFilled ? 'Player ${index + 1} joined' : 'Player ${index + 1} slot waiting',
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isFilled ? AppColors.surfaceElevated : AppColors.surfacePrimary,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isFilled ? AppColors.actionPrimary : AppColors.borderSubtle,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: isFilled ? AppColors.actionPrimary : AppColors.backgroundSecondary,
              child: Icon(
                isFilled ? Icons.person_rounded : Icons.hourglass_empty_rounded,
                color: isFilled ? AppColors.actionPrimaryForeground : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(isFilled ? 'Player ${index + 1}' : 'Waiting…', textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
