import 'package:card_game/features/online/room/controllers/room_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LobbyHeader extends GetView<RoomController> {
  const LobbyHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final room = controller.snapshot.value;

      return Column(
        children: [
          Text(
            room?.roomName ?? '',
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            '${controller.players.length} Players',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      );
    });
  }
}
