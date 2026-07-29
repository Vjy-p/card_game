import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/core/theme/app_radius.dart';
import 'package:card_game/core/theme/app_spacing.dart';
import 'package:card_game/features/offline/controllers/game_config.dart';
import 'package:card_game/features/offline/controllers/game_controller.dart';
import 'package:card_game/features/offline/engine/game_engine.dart';
import 'package:card_game/features/offline/presentation/animations/game_animation_controller.dart';
import 'package:card_game/features/offline/presentation/widgets/table/table_widget.dart';
import 'package:card_game/features/offline/presentation/widgets/user/action_bar/action_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OfflineScreen extends StatelessWidget {
  OfflineScreen({super.key});

  final controller = Get.put(
    GameController(engine: GameEngine(config: GameConfig())),
  );

  final gameAnimationsController = Get.put(GameAnimationController());

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
        body: TableWidget(),
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
                        controller.restart();
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
