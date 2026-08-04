import 'package:card_game/core/theme/app_spacing.dart';
import 'package:card_game/features/home/application/controllers/home_controller.dart';
import 'package:card_game/features/home/application/state/home_state.dart';
import 'package:card_game/features/home/presentation/widgets/home_action_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrimaryActions extends StatelessWidget {
  const PrimaryActions({
    super.key,
    required this.controller,
    required this.onAction,
  });

  final HomeController controller;
  final ValueChanged<HomePrimaryAction> onAction;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HomeActionCard(
            title: 'Play Online',
            subtitle: 'Find three players and start automatically.',
            icon: Icons.public_rounded,
            isPrimary: true,
            isPending:
                controller.pendingAction.value == HomePrimaryAction.playOnline,
            onPressed: controller.isBusy
                ? null
                : () => onAction(HomePrimaryAction.playOnline),
          ),

          const SizedBox(height: AppSpacing.md),

          HomeActionCard(
            title: 'Create Private Table',
            subtitle: 'Choose the table size and invite friends.',
            icon: Icons.add_circle_outline_rounded,
            isPending:
                controller.pendingAction.value == HomePrimaryAction.createTable,
            onPressed: controller.isBusy
                ? null
                : () => onAction(HomePrimaryAction.createTable),
          ),

          const SizedBox(height: AppSpacing.md),

          HomeActionCard(
            title: 'Join Table',
            subtitle: 'Enter room code.',
            icon: Icons.login_rounded,
            isPending:
                controller.pendingAction.value == HomePrimaryAction.joinTable,
            onPressed: controller.isBusy
                ? null
                : () => onAction(HomePrimaryAction.joinTable),
          ),

          const SizedBox(height: AppSpacing.md),

          HomeActionCard(
            title: 'Play Offline',
            subtitle: 'Practice against AI.',
            icon: Icons.smart_toy_outlined,
            isPending:
                controller.pendingAction.value == HomePrimaryAction.playOffline,
            onPressed: controller.isBusy
                ? null
                : () => onAction(HomePrimaryAction.playOffline),
          ),
        ],
      );
    });
  }
}
