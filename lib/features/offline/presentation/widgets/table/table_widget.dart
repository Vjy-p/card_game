import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/core/theme/app_spacing.dart';
import 'package:card_game/features/offline/controllers/animations/game_animation_controller.dart';
import 'package:card_game/features/offline/controllers/game_controller.dart';
import 'package:card_game/features/offline/models/action_state.dart';
import 'package:card_game/features/offline/presentation/widgets/center_table/center_area.dart';
import 'package:card_game/features/offline/presentation/widgets/game_turn_indicator.dart';
import 'package:card_game/features/offline/presentation/widgets/game_winner_indicator.dart';
import 'package:card_game/features/offline/presentation/widgets/opponent/opponent_widget.dart';
import 'package:card_game/features/offline/presentation/widgets/user/user_widget.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TableWidget extends StatelessWidget {
  const TableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GameController>();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.tableDark,
            AppColors.darkBlue,
            AppColors.tableDark,
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.xxs,
            AppSpacing.md,
            AppSpacing.md,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Positioned.fill(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Top section: Top opponent
                        Expanded(
                          flex: 3,
                          child: Align(
                            alignment: AlignmentGeometry.topCenter,
                            child: Obx(() {
                              final players = controller.table.opponents;
                              if (players.length < 2) {
                                return const SizedBox.shrink();
                              }
                              return OpponentWidget(
                                player: players[1],
                                isGameEnded:
                                    controller.table.actionState ==
                                    ActionState.gameFinished,
                              );
                            }),
                          ),
                        ),

                        SizedBox(height: AppSpacing.md),

                        // Middle section: Left opponent | Center area | Right opponent
                        Expanded(
                          flex: 11,
                          child: Row(
                            spacing: AppSpacing.sm,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Left opponent
                              Obx(() {
                                final players = controller.table.opponents;
                                if (players.length < 3) {
                                  return const SizedBox.shrink();
                                }
                                return Align(
                                  alignment: AlignmentGeometry.centerLeft,
                                  child: OpponentWidget(
                                    player: players[2],
                                    rotation: 1.6,
                                    isGameEnded:
                                        controller.table.actionState ==
                                        ActionState.gameFinished,
                                  ),
                                );
                              }),

                              // Center play area
                              Expanded(
                                child: Center(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      spacing: AppSpacing.md,
                                      children: [
                                        // Center area (deck and open pile)
                                        Obx(() {
                                          final table = controller.table;
                                          return CenterArea(
                                            remainingCards:
                                                table.remainingCards,
                                            forwardCard: table.forwardCard,
                                            canDraw: table.canDraw,
                                            canTakeOpen: table.canTakeForward,
                                            onDraw: controller.drawCard,
                                            onTakeOpen:
                                                controller.takeForwardCard,
                                            hiddenJoker: table.hiddenJoker,
                                            openCard: table.openCard,
                                          );
                                        }),

                                        // Turn indicator
                                        Obx(() {
                                          final table = controller.table;
                                          final currentPlayer = table.opponents
                                              .firstWhereOrNull(
                                                (p) => p.isCurrentTurn,
                                              );
                                          return table.actionState !=
                                                  ActionState.gameFinished
                                              ? GameTurnIndicator(
                                                  playerName:
                                                      currentPlayer?.name ??
                                                      'You',
                                                  isPlayerTurn:
                                                      !table.isOpponentTurn,
                                                )
                                              : GameWinnerIndicator(
                                                  playerName:
                                                      controller
                                                          .winners
                                                          .isNotEmpty
                                                      ? controller
                                                            .winners
                                                            .first
                                                            .name
                                                      : '',
                                                );
                                        }),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // Right opponent
                              Obx(() {
                                final players = controller.table.opponents;
                                if (players.isEmpty) {
                                  return const SizedBox.shrink();
                                }
                                return Align(
                                  alignment: AlignmentGeometry.centerRight,
                                  child: OpponentWidget(
                                    player: players[0],
                                    rotation: -1.6,
                                    isGameEnded:
                                        controller.table.actionState ==
                                        ActionState.gameFinished,
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                        SizedBox(height: AppSpacing.md),
                        // Bottom section: Action bar and hand
                        Expanded(
                          flex: 3,
                          child: Obx(() {
                            final table = controller.table;
                            final animating =
                                Get.find<GameAnimationController>().isAnimating;
                            return IgnorePointer(
                              ignoring: animating.value,
                              child: UserWidget(
                                state: table.actionState,
                                selectedCard: table.selectedCard,
                                onDraw: controller.drawCard,
                                onTakeOpen: controller.takeForwardCard,
                                onDiscard: controller.passSelectedCard,
                                onPlayAgain: controller.restart,
                                onExit: () {
                                  controller.clearData();
                                  Get.back();
                                },
                                onSort: controller.sortCards,
                                cards: controller.table.myCards,
                                canDeclare: !table.isOpponentTurn,
                                fourthCard: controller.players.first.fourthCard,
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  GetBuilder<GameController>(
                    builder: (controller) {
                      return Align(
                        alignment: Alignment.topCenter,
                        child: ConfettiWidget(
                          confettiController: controller.confettiController,
                          blastDirectionality: BlastDirectionality.explosive,
                          shouldLoop: true,
                          numberOfParticles: 30,
                          gravity: 0.1,
                          colors: AppColors.colorsList,
                        ),
                      );
                    },
                  ),
                  // const AnimationLayer(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
