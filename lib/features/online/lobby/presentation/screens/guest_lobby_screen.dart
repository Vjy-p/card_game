import 'package:card_game/features/online/lobby/presentation/widgets/leave_room_button.dart';
import 'package:card_game/features/online/lobby/presentation/widgets/lobby_header.dart';
import 'package:card_game/features/online/lobby/presentation/widgets/player_list.dart';
import 'package:card_game/features/online/lobby/presentation/widgets/room_info_card.dart';
import 'package:card_game/features/online/lobby/presentation/widgets/waiting_for_host_widget.dart';
import 'package:card_game/features/online/room/controllers/room_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GuestLobbyScreen extends GetView<RoomController> {
  const GuestLobbyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lobby')),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            spacing: 20,
            children: [
              LobbyHeader(),
              RoomInfoCard(),
              Expanded(child: PlayerList()),
              WaitingForHostWidget(),
              // ReadyWidget(),
              LeaveRoomButton(),
            ],
          ),
        ),
      ),
    );
  }
}
