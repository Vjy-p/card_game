import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/features/online/room/controllers/room_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class InviteCard extends GetView<RoomController> {
  const InviteCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text('Room Code'),
        subtitle: Text(
          controller.room?.joinCode ?? '',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        trailing: IconButton(icon: const Icon(Icons.copy), onPressed: () {}),
      ),
    );
  }
}
