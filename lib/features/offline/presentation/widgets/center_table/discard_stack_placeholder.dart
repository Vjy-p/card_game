import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/core/theme/app_radius.dart';
import 'package:card_game/core/theme/app_spacing.dart';
import 'package:card_game/core/theme/card_dimensions.dart';
import 'package:flutter/material.dart';

/// Discard stack placeholder - ready for animation
/// Shows the discard pile with visual feedback for future animation support
class DiscardStackPlaceholder extends StatelessWidget {
  const DiscardStackPlaceholder({super.key, required this.isVisible});

  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    final cardWidth = CardDimensions.width(context);
    final cardHeight = CardDimensions.height(context);

    if (!isVisible) {
      return const SizedBox.shrink();
    }

    return Tooltip(
      message: 'Discard animations coming soon',
      child: Container(
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(
            color: AppColors.accent.withValues(alpha: 0.4),
            width: 2,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Placeholder indicator
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  color: AppColors.accent.withValues(alpha: 0.08),
                ),
              ),
            ),
            // Animation icon
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon(
                //   Icons.animation,
                //   color: AppColors.accent.withValues(alpha: 0.6),
                //   size: 24,
                // ),
                Center(
                  child: Icon(
                    Icons.style_outlined,
                    color: AppColors.lightBackground,
                    size: 32,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  'Discard',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.accent.withValues(alpha: 0.6),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
