import 'package:card_game/features/online/room/controllers/room_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReadyWidget extends GetView<RoomController> {
  const ReadyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final me = controller.players.firstWhere((p) => !p.isHost);
      return ElevatedButton(
        onPressed: () => controller.toggleReady(!me.isReady),
        child: Text(me.isReady ? 'Unready' : 'Ready Up!'),
      );
    });
  }
}
