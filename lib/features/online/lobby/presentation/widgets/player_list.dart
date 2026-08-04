import 'package:card_game/features/online/lobby/presentation/widgets/player_tile.dart';
import 'package:card_game/features/online/room/controllers/room_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlayerList extends GetView<RoomController> {
  const PlayerList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final players = controller.players;

      return Column(
        children: [
          for (final player in players)
            PlayerTile(
              name: player.displayName,
              isHost: player.isHost,
              connected: player.isConnected,
            ),
        ],
      );
    });
  }
}
