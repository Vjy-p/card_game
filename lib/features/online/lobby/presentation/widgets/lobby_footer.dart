import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/features/online/room/controllers/room_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LobbyFooter extends GetView<RoomController> {
  const LobbyFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Players: ${controller.playerCount}/${controller.maxPlayers}',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 6),
            Text(
              controller.canStart
                  ? 'Ready to start!'
                  : 'Waiting for more players...',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
