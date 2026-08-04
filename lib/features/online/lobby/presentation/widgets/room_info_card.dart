import 'package:card_game/features/online/room/controllers/room_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class RoomInfoCard extends GetView<RoomController> {
  const RoomInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final room = controller.snapshot.value;

      return Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                'Room Code',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                room?.joinCode ?? '',
                style: const TextStyle(
                  fontSize: 24,
                  letterSpacing: 3,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () async {
                  await Clipboard.setData(
                    ClipboardData(text: room?.joinCode ?? ''),
                  );

                  Get.snackbar('Copied', 'Room code copied');
                },
                icon: const Icon(Icons.copy),
                label: const Text('Copy'),
              ),
            ],
          ),
        ),
      );
    });
  }
}
