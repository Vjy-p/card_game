import 'package:card_game/core/router/app_route.dart';
import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/core/theme/app_radius.dart';
import 'package:card_game/core/theme/app_spacing.dart';
import 'package:card_game/features/offline/controllers/game_controller.dart';
import 'package:card_game/features/offline/presentation/widgets/cards/card_face.dart';
import 'package:card_game/features/offline/presentation/widgets/user/action_bar/action_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GameController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(title: Text('Winners')),
          body: ListView.separated(
            itemCount: controller.winners.length,
            padding: EdgeInsets.symmetric(
              vertical: AppSpacing.xs,
              horizontal: AppSpacing.xs,
            ),
            itemBuilder: (context, index) {
              return ExpansionTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(AppRadius.md),
                ),
                collapsedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(AppRadius.md),
                ),
                dense: true,
                backgroundColor: AppColors.surfaceElevated,
                collapsedBackgroundColor: AppColors.surfacePrimary,
                leading: Text(
                  controller.winners[index].score.toString(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                title: Text(
                  controller.winners[index].name,
                  style: TextStyle(fontSize: 16),
                ),
                tilePadding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                childrenPadding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                ),
                children: [
                  SizedBox(
                    width: Get.width,
                    height: 120,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: List.generate(
                        controller.winners[index].hand.length,
                        (i) {
                          return Positioned(
                            top: 0,
                            left: i * 24.0,
                            child: SizedBox(
                              width: 65,
                              child: AspectRatio(
                                aspectRatio: 0.656,
                                child: CardFace(
                                  card: controller.winners[index].hand[i],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: AppSpacing.xs);
            },
          ),

          bottomNavigationBar: BottomAppBar(
            child: Row(
              spacing: AppSpacing.sm,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: ActionButton(
                    onPressed: () {
                      controller.restart();
                      AppRoute.home.offAll();
                    },
                    label: 'EXit',
                    icon: Icon(Icons.arrow_back_ios_new, size: 18),
                  ),
                ),
                Expanded(
                  child: ActionButton(
                    onPressed: () async {
                      controller.restart();
                      await Future.delayed(Duration(microseconds: 100));
                      Get.back();
                    },
                    label: 'Play again',
                    icon: Icon(Icons.restart_alt, size: 18),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
