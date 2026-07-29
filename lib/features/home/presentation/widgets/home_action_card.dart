import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/core/theme/app_radius.dart';
import 'package:card_game/core/theme/app_spacing.dart';
import 'package:card_game/utils/custom_loading.dart';
import 'package:flutter/material.dart';

class HomeActionCard extends StatelessWidget {
  const HomeActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onPressed,
    this.isPrimary = false,
    this.isPending = false,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final bool isPending;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: title,
      hint: subtitle,
      child: Material(
        color: isPrimary ? AppColors.actionPrimary : AppColors.surfacePrimary,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Container(
            constraints: const BoxConstraints(minHeight: 132),
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: isPrimary
                  ? null
                  : Border.all(color: AppColors.borderSubtle),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isPrimary
                        ? AppColors.actionPrimaryForeground.withValues(
                            alpha: 0.12,
                          )
                        : AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: isPending
                      ? CustomLoading(
                          strokeWidth: 2.5,
                          color: isPrimary
                              ? AppColors.actionPrimaryForeground
                              : AppColors.actionPrimary,
                        )
                      : Icon(
                          icon,
                          color: isPrimary
                              ? AppColors.actionPrimaryForeground
                              : AppColors.actionPrimary,
                        ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: isPrimary
                              ? AppColors.actionPrimaryForeground
                              : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isPrimary
                              ? AppColors.actionPrimaryForeground.withValues(
                                  alpha: 0.78,
                                )
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: isPrimary
                      ? AppColors.actionPrimaryForeground
                      : AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
