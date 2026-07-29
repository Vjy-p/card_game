import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class HomeSidePanel extends StatelessWidget {
  const HomeSidePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'HOW TO WIN',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.textSecondary,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.style_rounded,
                  color: AppColors.actionPrimary,
                  size: 32,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Build 3 + 3 + 3 + 4',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Match cards by rank. Reveal a natural four-of-a-kind to unlock your hidden joker advantage.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                OutlinedButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.menu_book_outlined),
                  label: const Text('How to Play'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Card(
          child: ListTile(
            leading: const Icon(
              Icons.history_rounded,
              color: AppColors.actionPrimary,
            ),
            title: const Text('Recent games'),
            subtitle: const Text('Your game history will appear here.'),
          ),
        ),
      ],
    );
  }
}
