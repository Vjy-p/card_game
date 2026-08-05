import 'package:card_game/core/router/app_route.dart';
import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/core/theme/app_radius.dart';
import 'package:card_game/core/theme/app_spacing.dart';
import 'package:card_game/features/offline/presentation/widgets/user/action_bar/action_button.dart';
import 'package:card_game/features/online/room/controllers/online_game_controller.dart';
import 'package:card_game/features/online/room/presentation/widgets/user/online_declare_bottomsheet.dart';
import 'package:card_game/features/online/room/presentation/widgets/user/online_fourth_card_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glass/glass.dart';

class OnlineActionBar extends GetView<OnlineGameController> {
  const OnlineActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        width: Get.width,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(
            width: 1.5,
            color: AppColors.lightSurface.withValues(alpha: 0.1),
          ),
          // gradient: LinearGradient(
          //   colors: [
          //     AppColors.lightSurface.withValues(alpha: .40),
          //     AppColors.lightSurface.withValues(alpha: .10),
          //   ],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
        ),

        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          // vertical: AppRadius.sm,
        ),
        // margin: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
        child: controller.gameEnded
            ? Row(
                spacing: AppSpacing.lg,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: ActionButton(
                      onPressed: () {
                        controller.clearData();
                        AppRoute.home.offAll();
                      },
                      label: 'Home',
                      icon: Icon(
                        Icons.home,
                        size: 20,
                        color: AppColors.lightBackground.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ActionButton(
                      onPressed: () {
                        AppRoute.offlineRanking.go();
                      },
                      label: 'Winners',
                      icon: Icon(
                        Icons.grade,
                        size: 20,
                        color: AppColors.lightBackground.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                  // Expanded(
                  //   child: ActionButton(
                  //     onPressed: (){
                  //     },
                  //     label: 'Play again',
                  //     icon: Icon(
                  //       Icons.refresh,
                  //       size: 20,
                  //       color: AppColors.lightBackground.withValues(alpha: 0.7),
                  //     ),
                  //   ),
                  // ),
                ],
              )
            : Row(
                spacing: AppSpacing.lg,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ActionButton(
                    onPressed: controller.selectedCard.value == null
                        ? null
                        : () {
                            controller.discardCard(
                              cardId: controller.selectedCard.value!.id,
                            );
                          },
                    label: 'Discard',
                    icon: Icon(
                      Icons.transform,
                      size: 20,
                      color: AppColors.lightBackground.withValues(alpha: 0.7),
                    ),
                  ),
                  ActionButton(
                    onPressed: () {
                      controller.sort();
                    },
                    label: 'Sort',
                    icon: Icon(
                      Icons.sort_by_alpha,
                      size: 20,
                      color: AppColors.lightBackground.withValues(alpha: 0.7),
                    ),
                  ),
                  ActionButton(
                    onPressed: controller.isMyTurn
                        ? () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => OnlineDeclareBottomsheet(
                                cards: controller.myHand,
                                fourthCard: controller.fourthCard,
                              ),
                            );
                          }
                        : null,
                    label: 'Group',
                    icon: Icon(
                      Icons.category,
                      size: 20,
                      color: AppColors.lightBackground.withValues(alpha: 0.7),
                    ),
                  ),
                  ActionButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => OnlineFourthCardBottomsheet(
                          cards: controller.myHand,
                        ),
                      );
                    },
                    label: '4th card',
                    icon: Icon(
                      Icons.check_circle,
                      size: 20,
                      color: AppColors.lightBackground.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
      ).asGlass(
        blurX: 4,
        blurY: 4,
        tintColor: AppColors.backgroundSecondary,
        clipBorderRadius: BorderRadius.circular(AppRadius.sm),
      );
    });
  }
}
