import 'package:card_game/core/router/app_route.dart';
import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/core/theme/app_radius.dart';
import 'package:card_game/core/theme/app_spacing.dart';
import 'package:card_game/features/offline/models/action_state.dart';
import 'package:card_game/features/offline/models/playing_card.dart';
import 'package:card_game/features/offline/presentation/widgets/user/action_bar/action_button.dart';
import 'package:card_game/features/offline/presentation/widgets/user/action_bar/declare_card_sheet.dart';
import 'package:card_game/features/offline/presentation/widgets/user/action_bar/fourth_card_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glass/glass.dart';

class ActionBar extends StatelessWidget {
  const ActionBar({
    super.key,
    required this.state,
    required this.selectedCard,
    required this.onDraw,
    required this.onTakeOpen,
    required this.onDiscard,
    required this.onPlayAgain,
    required this.onExit,
    required this.onSort,
    required this.cards,
    required this.canDeclare,
    required this.fourthCard,
  });

  final ActionState state;
  final PlayingCard? selectedCard;

  final VoidCallback onDraw;
  final VoidCallback onTakeOpen;
  final VoidCallback onDiscard;
  final VoidCallback onPlayAgain;
  final VoidCallback onExit;
  final VoidCallback onSort;
  final List<PlayingCard> cards;
  final List<PlayingCard> fourthCard;
  final bool canDeclare;

  @override
  Widget build(BuildContext context) {
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
      child: (state != ActionState.gameFinished)
          ? Row(
              spacing: AppSpacing.lg,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ActionButton(
                  onPressed: selectedCard == null ? null : onDiscard,
                  label: 'Discard',
                  icon: Icon(
                    Icons.transform,
                    size: 20,
                    color: AppColors.lightBackground.withValues(alpha: 0.7),
                  ),
                ),
                ActionButton(
                  onPressed: onSort,
                  label: 'Sort',
                  icon: Icon(
                    Icons.sort_by_alpha,
                    size: 20,
                    color: AppColors.lightBackground.withValues(alpha: 0.7),
                  ),
                ),
                ActionButton(
                  onPressed: canDeclare
                      ? () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => DeclareCardSheet(
                              cards: cards,
                              fourthCard: fourthCard,
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
                      builder: (context) => FourthCardBottomSheet(cards: cards),
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
            )
          : Row(
              spacing: AppSpacing.lg,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: ActionButton(
                    onPressed: onExit,
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
                Expanded(
                  child: ActionButton(
                    onPressed: onPlayAgain,
                    label: 'Play again',
                    icon: Icon(
                      Icons.refresh,
                      size: 20,
                      color: AppColors.lightBackground.withValues(alpha: 0.7),
                    ),
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
  }
}
