import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/core/theme/app_radius.dart';
import 'package:card_game/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:glass/glass.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.onPressed,
    required this.label,
    required this.icon,
  });
  final Function()? onPressed;
  final String label;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: 40,
      onPressed: onPressed,
      // elevation: 4,
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppRadius.sm,
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.comfortable,
      color: AppColors.textSecondary.withValues(alpha: 0.5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: AppSpacing.xxs,
        children: [
          icon,
          Text(
            label,
            style: TextStyle(
              color: AppColors.lightBackground.withValues(alpha: 0.7),
              fontSize: 12,
            ),
          ),
        ],
      ),
    ).asGlass(
      blurX: 4,
      blurY: 4,
      tintColor: AppColors.textPrimary,
      clipBorderRadius: BorderRadius.circular(AppRadius.sm),
    );
  }
}
