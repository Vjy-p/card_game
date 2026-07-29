import 'dart:developer';

import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/core/theme/app_radius.dart';
import 'package:card_game/core/theme/app_spacing.dart';
import 'package:card_game/features/offline/controllers/game_controller.dart';
import 'package:card_game/features/offline/models/playing_card.dart';
import 'package:card_game/features/offline/presentation/widgets/center_table/closed_deck.dart';
import 'package:card_game/features/offline/presentation/widgets/center_table/discard_stack_placeholder.dart';
import 'package:card_game/features/offline/presentation/widgets/center_table/joker_pile.dart';
import 'package:card_game/features/offline/presentation/widgets/center_table/open_pile.dart';
import 'package:card_game/utils/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CenterArea extends StatelessWidget {
  const CenterArea({
    super.key,
    required this.remainingCards,
    required this.forwardCard,
    required this.canDraw,
    required this.onDraw,
    required this.onTakeOpen,
    required this.canTakeOpen,
    this.hiddenJoker,
    this.openCard,
  });

  final int remainingCards;
  final PlayingCard? forwardCard;
  final bool canDraw;
  final VoidCallback onDraw;
  final VoidCallback onTakeOpen;
  final bool canTakeOpen;
  final PlayingCard? hiddenJoker;
  final PlayingCard? openCard;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet =
        MediaQuery.of(context).size.width >= 600 &&
        MediaQuery.of(context).size.width < 1000;

    final controller = Get.find<GameController>();

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.surfacePrimary.withValues(alpha: 0.8),
              AppColors.surfaceElevated.withValues(alpha: 0.6),
            ],
          ),
          border: Border.all(
            color: AppColors.lightGreen.withValues(alpha: 0.4),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: AppSpacing.lg,
          children: [
            if (isMobile)
              _buildMobileLayout(controller: controller)
            else if (isTablet)
              _buildTabletLayout(controller: controller)
            else
              _buildDesktopLayout(controller: controller),
          ],
        ),
      ),
    );
  }

  /// Mobile layout - stacked vertically
  Widget _buildMobileLayout({required GameController controller}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: AppSpacing.md,
      children: [
        _buildDeckSection(),
        IntrinsicHeight(
          child: Row(
            spacing: AppSpacing.xs,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Obx(() {
                  return JokerPile(
                    card: hiddenJoker,
                    enabled: controller.players.first.jokerUnlocked.value,
                    onTap: () {
                      log(
                        'on joker tap ${controller.players.first.jokerUnlocked.value}',
                      );
                      if (!controller.players.first.jokerUnlocked.value) {
                        customToast(message: 'Need a 4th card set');
                      }
                    },
                  );
                }),
              ),
              Expanded(child: _buildDiscardSection(controller: controller)),
            ],
          ),
        ),
      ],
    );
  }

  /// Tablet layout - 2 columns
  Widget _buildTabletLayout({required GameController controller}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.md,
      children: [
        _buildDeckSection(),
        IntrinsicHeight(
          child: Row(
            spacing: AppSpacing.lg,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Obx(() {
                  return JokerPile(
                    card: hiddenJoker,
                    enabled: controller.players.first.jokerUnlocked.value,
                    onTap: () {
                      log(
                        'on joker tap ${controller.players.first.jokerUnlocked.value}',
                      );
                      if (!controller.players.first.jokerUnlocked.value) {
                        customToast(message: 'Need a 4th card set');
                      }
                    },
                  );
                }),
              ),
              Expanded(child: _buildDiscardSection(controller: controller)),
            ],
          ),
        ),
      ],
    );
  }

  /// Desktop layout - 3 columns
  Widget _buildDesktopLayout({required GameController controller}) {
    return Row(
      spacing: AppSpacing.xxl,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: _buildDeckSection()),
        Expanded(
          child: Obx(() {
            return JokerPile(
              card: hiddenJoker,
              enabled: controller.players.first.jokerUnlocked.value,
              onTap: () {
                log(
                  'on joker tap ${controller.players.first.jokerUnlocked.value}',
                );
                if (!controller.players.first.jokerUnlocked.value) {
                  customToast(message: 'Need a 4th card set');
                }
              },
            );
          }),
        ),
        Expanded(child: _buildDiscardSection(controller: controller)),
      ],
    );
  }

  /// Deck section with label and card count
  Widget _buildDeckSection() {
    return ClosedDeck(
      remainingCards: remainingCards,
      enabled: canDraw,
      onTap: onDraw,
    );
  }

  Widget _buildDiscardSection({required GameController controller}) {
    return Obx(() {
      return controller.table.forwardCard != null
          ? OpenPile(
              card: controller.table.forwardCard,
              enabled: canTakeOpen,
              onTap: onTakeOpen,
            )
          : controller.table.openCard != null
          ? OpenPile(
              card: controller.table.openCard!,
              enabled: canTakeOpen,
              onTap: onTakeOpen,
            )
          : DiscardStackPlaceholder(isVisible: true);
    });
  }
}
