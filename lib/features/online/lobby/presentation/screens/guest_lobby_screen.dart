import 'package:card_game/core/responsive/get_device.dart';
import 'package:card_game/core/theme/app_spacing.dart';
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
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: GetDevice.isMobile(context)
                ? Get.width
                : GetDevice.isTablet(context)
                ? Get.width * 0.9
                : Get.width / 2,
          ),
          alignment: Alignment.topCenter,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
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
