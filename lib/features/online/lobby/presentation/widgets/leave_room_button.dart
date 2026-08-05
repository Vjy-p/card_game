import 'package:card_game/core/router/app_route.dart';
import 'package:card_game/features/online/room/controllers/room_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeaveRoomButton extends GetView<RoomController> {
  const LeaveRoomButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () async {
        final leave = await Get.dialog<bool>(
          AlertDialog(
            title: const Text('Leave Room'),
            content: const Text('Are you sure you want to leave this room?'),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Get.back(result: true),
                child: const Text('Leave'),
              ),
            ],
          ),
        );

        if (leave != true) return;

        await controller.leaveLobby();
        AppRoute.home.offAll();
      },
      icon: const Icon(Icons.logout),
      label: const Text('Leave Room'),
    );
  }
}
