import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/core/theme/app_radius.dart';
import 'package:card_game/core/theme/app_spacing.dart';
import 'package:card_game/features/onboarding/models/onboarding_page_content.dart';
import 'package:card_game/features/onboarding/presentation/widgets/mini_playing_card.dart';
import 'package:flutter/material.dart';

class OnboardingVisual extends StatelessWidget {
  const OnboardingVisual({required this.type, super.key});
  final OnboardingVisualType type;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.35,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surfacePrimary,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: switch (type) {
          OnboardingVisualType.rankMatch => const _RankMatchVisual(),
          OnboardingVisualType.duplicateCards => const _DuplicateCardsVisual(),
          OnboardingVisualType.jokerUnlock => const _JokerUnlockVisual(),
          OnboardingVisualType.winningHand => const _WinningHandVisual(),
        },
      ),
    );
  }
}

class _RankMatchVisual extends StatelessWidget {
  const _RankMatchVisual();
  @override
  Widget build(BuildContext context) => const Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      MiniPlayingCard(rank: '8', suit: '♠'),
      SizedBox(width: 8),
      MiniPlayingCard(rank: '8', suit: '♥'),
      SizedBox(width: 8),
      MiniPlayingCard(rank: '8', suit: '♦'),
    ],
  );
}

class _DuplicateCardsVisual extends StatelessWidget {
  const _DuplicateCardsVisual();
  @override
  Widget build(BuildContext context) => const Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      MiniPlayingCard(rank: '8', suit: '♠'),
      SizedBox(width: 8),
      MiniPlayingCard(rank: '8', suit: '♠'),
      SizedBox(width: 8),
      MiniPlayingCard(rank: '8', suit: '♥'),
    ],
  );
}

class _JokerUnlockVisual extends StatelessWidget {
  const _JokerUnlockVisual();
  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Wrap(
        spacing: 6,
        children: [
          MiniPlayingCard(rank: 'K', suit: '♠', width: 54, highlighted: true),
          MiniPlayingCard(rank: 'K', suit: '♥', width: 54, highlighted: true),
          MiniPlayingCard(rank: 'K', suit: '♦', width: 54, highlighted: true),
          MiniPlayingCard(rank: 'K', suit: '♣', width: 54, highlighted: true),
        ],
      ),
      const SizedBox(height: AppSpacing.md),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock_open_rounded, color: AppColors.actionPrimary),
          const SizedBox(width: AppSpacing.xs),
          Text(
            'Joker unlocked for you',
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ],
      ),
    ],
  );
}

class _WinningHandVisual extends StatelessWidget {
  const _WinningHandVisual();
  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        'BUILD FOUR GROUPS',
        style: Theme.of(
          context,
        ).textTheme.labelLarge?.copyWith(color: AppColors.actionPrimary),
      ),
      const SizedBox(height: AppSpacing.lg),
      const Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        runSpacing: 8,
        children: [
          _GroupChip(label: '3'),
          _GroupChip(label: '3'),
          _GroupChip(label: '3'),
          _GroupChip(label: '4'),
        ],
      ),
      const SizedBox(height: AppSpacing.md),
      Text('13 cards total', style: Theme.of(context).textTheme.bodyMedium),
    ],
  );
}

class _GroupChip extends StatelessWidget {
  const _GroupChip({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) => Container(
    width: 54,
    height: 70,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: AppColors.gameTable,
      borderRadius: BorderRadius.circular(AppRadius.md),
      border: Border.all(color: AppColors.actionPrimary),
    ),
    child: Text(label, style: Theme.of(context).textTheme.headlineMedium),
  );
}
