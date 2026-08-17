import 'package:card_game/core/router/app_route.dart';
import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/core/theme/app_radius.dart';
import 'package:card_game/core/theme/app_spacing.dart';
import 'package:card_game/features/ads/presentation/widgets/banner_ad_widget.dart';
import 'package:card_game/features/offline/controllers/animations/game_animation_controller.dart';
import 'package:card_game/features/offline/controllers/game_config.dart';
import 'package:card_game/features/offline/controllers/game_controller.dart';
import 'package:card_game/features/offline/engine/game_engine.dart';
import 'package:card_game/features/offline/presentation/widgets/table/table_widget.dart';
import 'package:card_game/features/offline/presentation/widgets/user/action_bar/action_button.dart';
import 'package:card_game/utils/custom_back_button.dart';
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
    final isMobile = MediaQuery.of(context).size.width < 600;
    // final isTablet =
    //     MediaQuery.of(context).size.width >= 600 &&
    //     MediaQuery.of(context).size.width < 1000;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final bool isExit = await openExitDialog(isMobile: isMobile);
        if (isExit) {
          AppRoute.home.offAll();
          // Get.back();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.tableDark,
          surfaceTintColor: AppColors.tableDark,
          elevation: 0,
          toolbarHeight: 40,
          title: BannerAdWidget(),
          leading: CustomBackButton(
            onTap: () async {
              final bool isExit = await openExitDialog(isMobile: isMobile);
              if (isExit) {
                AppRoute.home.offAll();
                // Get.back();
              }
            },
          ),
        ),
        body: TableWidget(),
      ),
    );
  }

  Future<bool> openExitDialog({required bool isMobile}) async {
    return await Get.dialog(
      Dialog(
        backgroundColor: AppColors.backgroundSecondary,
        insetPadding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(AppRadius.card),
        ),
        constraints: BoxConstraints(
          maxWidth: isMobile ? Get.width : Get.width / 2,
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
