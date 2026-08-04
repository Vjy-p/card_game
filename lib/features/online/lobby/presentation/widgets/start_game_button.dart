import 'package:card_game/features/online/room/controllers/room_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StartGameButton extends GetView<RoomController> {
  const StartGameButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        width: 250,
        child: ElevatedButton(
          onPressed: controller.canStart ? controller.startGame : null,
          child: const Text('START GAME'),
        ),
      ),
    );
  }
}
