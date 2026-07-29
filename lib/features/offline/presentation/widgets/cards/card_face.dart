import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/features/offline/models/playing_card.dart';
import 'package:card_game/features/offline/presentation/widgets/cards/card_center.dart';
import 'package:card_game/features/offline/presentation/widgets/cards/card_corners.dart';
import 'package:flutter/material.dart';

class CardFace extends StatelessWidget {
  const CardFace({super.key, required this.card, this.isLocked = false});

  final PlayingCard card;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.zero,
      color: AppColors.lightSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: CardCorner(card: card),
            ),

            Align(
              alignment: Alignment.center,
              child: CardCenter(card: card),
            ),

            Align(
              alignment: Alignment.bottomRight,
              child: CardCorner(card: card, rotate: true),
            ),
            if (isLocked)
              Positioned(
                top: 20,
                left: 0,
                child: Icon(
                  Icons.lock,
                  color: AppColors.backgroundSecondary.withValues(alpha: 0.5),
                  size: 14,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
