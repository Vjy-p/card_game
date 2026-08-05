import 'dart:developer';

import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/core/theme/app_radius.dart';
import 'package:card_game/core/theme/app_spacing.dart';
import 'package:card_game/core/theme/card_dimensions.dart';
import 'package:card_game/features/offline/presentation/widgets/center_table/discard_stack_placeholder.dart';
import 'package:card_game/features/online/room/controllers/online_game_controller.dart';
import 'package:card_game/features/online/room/presentation/widgets/online_closed_deck.dart';
import 'package:card_game/features/online/room/presentation/widgets/online_joker_tile.dart';
import 'package:card_game/features/online/room/presentation/widgets/online_open_card.dart';
import 'package:card_game/utils/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnlineCenterArea extends GetView<OnlineGameController> {
  const OnlineCenterArea({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet =
        MediaQuery.of(context).size.width >= 600 &&
        MediaQuery.of(context).size.width < 1000;
    final double cardHeight = CardDimensions.height(context);

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
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
              _buildMobileLayout(cardHeight)
            else if (isTablet)
              _buildTabletLayout(cardHeight)
            else
              _buildDesktopLayout(cardHeight),
          ],
        ),
      ),
    );
  }

  /// Mobile layout - stacked vertically
  Widget _buildMobileLayout(double cardHeight) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: AppSpacing.md,
      children: [
        _buildDeckSection(),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: cardHeight),
          child: Row(
            spacing: AppSpacing.xs,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() {
                return OnlineJokerTile(
                  card: controller.joker.value,
                  enabled: controller.jokerUnlocked.value,
                  onTap: () {
                    log('on joker tap ${controller.jokerUnlocked.value}');
                    if (!controller.jokerUnlocked.value) {
                      customToast(message: 'Need a 4th card set');
                    }
                  },
                );
              }),
              _buildDiscardSection(),
            ],
          ),
        ),
      ],
    );
  }

  /// Tablet layout - 2 columns
  Widget _buildTabletLayout(double cardHeight) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.md,
      children: [
        _buildDeckSection(),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: cardHeight),
          child: Row(
            spacing: AppSpacing.lg,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() {
                return OnlineJokerTile(
                  card: null,
                  enabled: controller.jokerUnlocked.value,
                  onTap: () {
                    log('on joker tap ${controller.jokerUnlocked.value}');
                    if (!controller.jokerUnlocked.value) {
                      customToast(message: 'Need a 4th card set');
                    }
                  },
                );
              }),
              _buildDiscardSection(),
            ],
          ),
        ),
      ],
    );
  }

  /// Desktop layout - 3 columns
  Widget _buildDesktopLayout(double cardHeight) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: cardHeight),
      child: Row(
        spacing: AppSpacing.xxl,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: _buildDeckSection()),
          Obx(() {
            return OnlineJokerTile(
              card: null,
              enabled: controller.jokerUnlocked.value,
              onTap: () {
                log('on joker tap ${controller.jokerUnlocked.value}');
                if (!controller.jokerUnlocked.value) {
                  customToast(message: 'Need a 4th card set');
                }
              },
            );
          }),
          _buildDiscardSection(),
        ],
      ),
    );
  }

  /// Deck section with label and card count
  Widget _buildDeckSection() {
    return Obx(() {
      return Container(
        key: controller.deckKey,
        child: OnlineClosedDeck(
          remainingCards: controller.allCards.length,
          enabled: controller.isMyTurn,
          onTap: () {
            controller.drawFromDeck();
          },
        ),
      );
    });
  }

  Widget _buildDiscardSection() {
    return Container(
      key: controller.openCardKey,
      child: Obx(() {
        return controller.openCard.value != null
            ? OnlineOpenCard(
                card: controller.openCard.value,
                enabled: controller.isMyTurn,
                onTap: () {
                  controller.pickOpenCard(card: controller.openCard.value!);
                },
              )
            : DiscardStackPlaceholder(isVisible: true);
      }),
    );
  }
}
