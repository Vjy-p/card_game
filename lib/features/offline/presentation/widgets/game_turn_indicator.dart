import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class GameTurnIndicator extends StatelessWidget {
  const GameTurnIndicator({
    super.key,
    required this.playerName,
    required this.isPlayerTurn,
  });

  final String playerName;
  final bool isPlayerTurn;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: isPlayerTurn
            ? AppColors.actionPrimary.withValues(alpha: 0.15)
            : Colors.black38,
        border: Border.all(
          color: isPlayerTurn ? AppColors.actionPrimary : AppColors.textMuted,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: AppSpacing.sm,
        children: [
          if (isPlayerTurn)
            Icon(Icons.circle, color: AppColors.actionPrimary, size: 8),
          Flexible(
            child: Text(
              '$playerName\'s Turn',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: isPlayerTurn
                    ? AppColors.actionPrimary
                    : AppColors.textMuted,
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
