import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/core/theme/app_radius.dart';
import 'package:card_game/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class AuthenticationBrandPanel extends StatelessWidget {
  const AuthenticationBrandPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: 'Card Game. Match ranks, unlock your joker, and win the table.',
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surfacePrimary,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _CardMark(),
              const SizedBox(height: AppSpacing.xl),
              Text('Your table is waiting.', style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Sign in to join friends, continue games after reconnecting, and keep your multiplayer identity across devices.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardMark extends StatelessWidget {
  const _CardMark();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 104,
      height: 82,
      child: Stack(
        children: [
          Positioned(left: 4, top: 8, child: Transform.rotate(angle: -0.12, child: const _MiniCard(symbol: '♠', color: AppColors.cardBlack))),
          Positioned(left: 42, top: 0, child: Transform.rotate(angle: 0.12, child: const _MiniCard(symbol: '♥', color: AppColors.cardRed))),
        ],
      ),
    );
  }
}

class _MiniCard extends StatelessWidget {
  const _MiniCard({required this.symbol, required this.color});
  final String symbol;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 76,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card)),
      child: Text(symbol, style: TextStyle(fontSize: 28, color: color, fontWeight: FontWeight.w700)),
    );
  }
}
