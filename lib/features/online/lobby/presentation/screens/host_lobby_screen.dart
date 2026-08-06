import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/core/theme/app_spacing.dart';
import 'package:card_game/features/online/lobby/presentation/widgets/invite_card.dart';
import 'package:card_game/features/online/lobby/presentation/widgets/lobby_footer.dart';
import 'package:card_game/features/online/lobby/presentation/widgets/lobby_seat.dart';
import 'package:card_game/features/online/lobby/presentation/widgets/start_game_button.dart';
import 'package:card_game/features/online/room/controllers/room_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HostLobbyScreen extends GetView<RoomController> {
  const HostLobbyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: Obx(() {
          final players = controller.players;

          return Column(
            children: [
              _buildTopBar(),

              Expanded(
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        width: 320,
                        height: 420,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundSecondary,
                          borderRadius: BorderRadius.circular(160),
                          border: Border.all(
                            color: AppColors.textMuted,
                            width: 4,
                          ),
                        ),
                      ),
                    ),

                    /// Top
                    Align(
                      alignment: Alignment.topCenter,
                      child: LobbySeat(
                        player: players.length > 1 ? players[1] : null,
                      ),
                    ),

                    /// Left
                    Align(
                      alignment: Alignment.centerLeft,
                      child: LobbySeat(
                        player: players.length > 2 ? players[2] : null,
                      ),
                    ),

                    /// Right
                    Align(
                      alignment: Alignment.centerRight,
                      child: LobbySeat(
                        player: players.length > 3 ? players[3] : null,
                      ),
                    ),

                    /// Host
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: LobbySeat(
                        player: players.isNotEmpty ? players[0] : null,
                        isHost: true,
                      ),
                    ),
                  ],
                ),
              ),
              InviteCard(),
              LobbyFooter(),
              SizedBox(height: AppSpacing.sm),
              StartGameButton(),
              const SizedBox(height: 24),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: controller.leaveLobby,
            icon: const Icon(Icons.arrow_back, color: AppColors.lightSurface),
          ),
          const Spacer(),
          const Text(
            'Host Lobby',
            style: TextStyle(
              color: AppColors.lightSurface,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings, color: AppColors.lightSurface),
          ),
        ],
      ),
    );
  }
}
