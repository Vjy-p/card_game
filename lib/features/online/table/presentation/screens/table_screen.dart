import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/core/theme/app_radius.dart';
import 'package:card_game/core/theme/app_spacing.dart';
import 'package:card_game/features/offline/presentation/widgets/user/action_bar/action_button.dart';
import 'package:card_game/features/online/table/controller/online_game_controller.dart';
import 'package:card_game/features/online/table/presentation/widgets/online_center_area.dart';
import 'package:card_game/features/online/table/presentation/widgets/player_widget.dart';
import 'package:card_game/features/online/table/presentation/widgets/user/online_user_widget.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TableScreen extends GetView<OnlineGameController> {
  const TableScreen({super.key});

  // final gameAnimationsController = Get.put(GameAnimationController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final bool isExit = await openExitDialog();
        if (isExit) {
          Get.back();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 40,
          title: const Text(''),
          leading: BackButton(
            onPressed: () async {
              final bool isExit = await openExitDialog();
              if (isExit) {
                Get.back();
              }
            },
          ),
        ),
        body: Container(
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
          padding: EdgeInsets.all(10),
          child: SafeArea(
            top: false,
            child: Obx(() {
              final players = controller.players;
              return Stack(
                children: [
                  Positioned.fill(
                    child: Column(
                      spacing: AppSpacing.md,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 3,
                          child:
                              /// Top
                              Align(
                                alignment: Alignment.topCenter,
                                child: PlayerWidget(
                                  player: players.length > 1
                                      ? players[1]
                                      : null,
                                ),
                              ),
                        ),
                        Expanded(
                          flex: 11,
                          child: Row(
                            children: [
                              /// Left
                              Align(
                                alignment: Alignment.centerLeft,
                                child: PlayerWidget(
                                  player: players.length > 2
                                      ? players[2]
                                      : null,
                                ),
                              ),
                              Expanded(child: OnlineCenterArea()),

                              /// Right
                              Align(
                                alignment: Alignment.centerRight,
                                child: PlayerWidget(
                                  player: players.length > 3
                                      ? players[3]
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(flex: 3, child: OnlineUserWidget()),
                      ],
                    ),
                  ),

                  GetBuilder<OnlineGameController>(
                    builder: (gameController) {
                      return Align(
                        alignment: Alignment.topCenter,
                        child: ConfettiWidget(
                          confettiController: gameController.confettiController,
                          blastDirectionality: BlastDirectionality.explosive,
                          shouldLoop: true,
                          numberOfParticles: 30,
                          gravity: 0.1,
                          colors: AppColors.colorsList,
                        ),
                      );
                    },
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Future<bool> openExitDialog() async {
    return await Get.dialog(
      Dialog(
        backgroundColor: AppColors.backgroundSecondary,
        insetPadding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(AppRadius.card),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: AppSpacing.xxxl,
            children: [
              Text(
                'Are you sure to exit?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                spacing: AppSpacing.sm,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: ActionButton(
                      onPressed: () {
                        Get.back(result: false);
                      },
                      label: 'Cancel',
                      icon: Icon(Icons.arrow_back_ios_new, size: 18),
                    ),
                  ),
                  Expanded(
                    child: ActionButton(
                      onPressed: () async {
                        Get.back(result: true);
                        // controller.restart();
                      },
                      label: 'Exit',
                      icon: Icon(Icons.restart_alt, size: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
