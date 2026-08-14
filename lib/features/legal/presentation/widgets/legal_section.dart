import 'package:card_game/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LegalSection extends StatelessWidget {
  final String title;
  final String content;
  final int index;

  const LegalSection({
    super.key,
    required this.title,
    required this.content,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final reduceMotion = MediaQuery.of(context).disableAnimations;

    final section = Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(title: title),
          const SizedBox(height: 10),
          Text(
            content,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary.withValues(alpha: 0.72),
              height: 1.65,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );

    if (reduceMotion) {
      return section;
    }

    return section
        .animate()
        .fadeIn(
          duration: 450.ms,
          delay: Duration(milliseconds: index * 200),
          curve: Curves.easeOut,
        )
        .slideY(
          begin: 0.08,
          end: 0,
          duration: 450.ms,
          delay: Duration(milliseconds: index * 200),
          curve: Curves.easeOutCubic,
        );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 3),
          width: 3,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(10),
          ),
        ).animate().scaleY(
          begin: 0,
          end: 1,
          duration: 350.ms,
          curve: Curves.easeOutCubic,
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
              height: 1.3,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
