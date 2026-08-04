import 'package:card_game/features/online/room/controllers/room_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WaitingForHostWidget extends GetView<RoomController> {
  const WaitingForHostWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.gameStarted) {
        return const Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text('Starting game...'),
          ],
        );
      }

      return const Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 12),
          Text('Waiting for host to start...', style: TextStyle(fontSize: 18)),
        ],
      );
    });
  }
}
