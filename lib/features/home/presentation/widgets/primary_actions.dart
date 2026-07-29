import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/core/theme/app_spacing.dart';
import 'package:card_game/features/home/application/state/home_state.dart';
import 'package:card_game/features/home/presentation/widgets/home_action_card.dart';
import 'package:flutter/material.dart';

class PrimaryActions extends StatelessWidget {
  const PrimaryActions({
    super.key,
    required this.state,
    required this.onAction,
  });
  final HomeState state;
  final ValueChanged<HomePrimaryAction> onAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'PLAY',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.textSecondary,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        // HomeActionCard(
        //   title: 'Play Online',
        //   subtitle: 'Find three players and start automatically.',
        //   icon: Icons.public_rounded,
        //   isPrimary: true,
        //   isPending: state.pendingAction == HomePrimaryAction.playOnline,
        //   onPressed: state.isBusy
        //       ? null
        //       : () => onAction(HomePrimaryAction.playOnline),
        // ),
        // const SizedBox(height: AppSpacing.md),
        // HomeActionCard(
        //   title: 'Create Private Table',
        //   subtitle: 'Choose the table size and invite friends.',
        //   icon: Icons.add_circle_outline_rounded,
        //   isPending:
        //       state.pendingAction == HomePrimaryAction.createPrivateTable,
        //   onPressed: state.isBusy
        //       ? null
        //       : () => onAction(HomePrimaryAction.createPrivateTable),
        // ),
        // const SizedBox(height: AppSpacing.md),
        // HomeActionCard(
        //   title: 'Join Table',
        //   subtitle: 'Enter a room code or continue from an invitation.',
        //   icon: Icons.login_rounded,
        //   isPending: state.pendingAction == HomePrimaryAction.joinTable,
        //   onPressed: state.isBusy
        //       ? null
        //       : () => onAction(HomePrimaryAction.joinTable),
        // ),
        // const SizedBox(height: AppSpacing.md),
        HomeActionCard(
          title: 'Play Offline',
          subtitle: 'Practice against computer players without internet.',
          icon: Icons.smart_toy_outlined,
          isPending: state.pendingAction == HomePrimaryAction.playOffline,
          onPressed: state.isBusy
              ? null
              : () => onAction(HomePrimaryAction.playOffline),
        ),
      ],
    );
  }
}
