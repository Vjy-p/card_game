import 'package:card_game/core/router/app_route.dart';
import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/core/theme/app_radius.dart';
import 'package:card_game/core/theme/app_spacing.dart';
import 'package:card_game/features/offline/presentation/widgets/user/action_bar/action_button.dart';
import 'package:card_game/features/online/room/controllers/online_game_controller.dart';
import 'package:card_game/features/online/room/presentation/widgets/animations/card_animation_overlay.dart';
import 'package:card_game/features/online/room/presentation/widgets/online_center_area.dart';
import 'package:card_game/features/online/room/presentation/widgets/player_widget.dart';
import 'package:card_game/features/online/room/presentation/widgets/user/online_user_widget.dart';
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
              // final players = controller.players;
              final seats = controller.seatPlayers;
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
                                child: PlayerWidget(player: seats[2]?.player),
                              ),
                        ),
                        Expanded(
                          flex: 11,
                          child: Row(
                            children: [
                              /// Left
                              Align(
                                alignment: Alignment.centerLeft,
                                child: PlayerWidget(player: seats[1]?.player),
                              ),
                              Expanded(child: OnlineCenterArea()),

                              /// Right
                              Align(
                                alignment: Alignment.centerRight,
                                child: PlayerWidget(player: seats[3]?.player),
                              ),
                            ],
                          ),
                        ),
                        Expanded(flex: 3, child: OnlineUserWidget()),
                      ],
                    ),
                  ),
                  CardAnimationOverlay(),
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
                        controller.clearData();
                        // Get.back(result: true);
                        AppRoute.home.offAll();
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
