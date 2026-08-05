import 'package:card_game/features/online/room/controllers/online_game_controller.dart';
import 'package:card_game/features/online/room/models/room_lobby_snapshot.dart';
import 'package:card_game/features/online/room/presentation/widgets/turn_glow_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlayerWidget extends GetView<OnlineGameController> {
  const PlayerWidget({super.key, this.player, this.isHost = false});

  final RoomLobbyPlayer? player;
  final bool isHost;

  @override
  Widget build(BuildContext context) {
    final occupied = player != null;

    return occupied == false
        ? SizedBox.shrink()
        : Obx(() {
            final bool isCurrentTurn =
                player?.playerId == controller.currentPlayerInternalId;

            return SizedBox(
              width: 90,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TurnGlow(
                    active: isCurrentTurn,
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: occupied ? Colors.orange : Colors.grey,
                      child: occupied
                          ? Text(
                              player!.displayName[0],
                              style: const TextStyle(fontSize: 22),
                            )
                          : const Icon(Icons.person_outline),
                    ),
                  ),

                  const SizedBox(height: 6),
                  Text(
                    occupied ? player!.displayName : 'Waiting...',
                    style: const TextStyle(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (isHost)
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Chip(label: Text('HOST')),
                    ),
                ],
              ),
            );
          });
  }
}
