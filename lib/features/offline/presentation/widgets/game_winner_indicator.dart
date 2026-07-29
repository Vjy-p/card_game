import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class GameWinnerIndicator extends StatelessWidget {
  const GameWinnerIndicator({super.key, required this.playerName});

  final String playerName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.actionPrimary.withValues(alpha: 0.15),
        border: Border.all(color: AppColors.actionPrimary, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: AppSpacing.xxs,
        children: [
          Icon(Icons.circle, color: AppColors.actionPrimary, size: 8),
          Flexible(
            child: Text(
              'Winner is $playerName\'s',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.actionPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
