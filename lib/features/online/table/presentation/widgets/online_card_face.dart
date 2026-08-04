import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/features/online/table/model/card_model.dart';
import 'package:card_game/features/online/table/presentation/widgets/online_card_corner.dart';
import 'package:flutter/material.dart';

class OnlineCardFace extends StatelessWidget {
  const OnlineCardFace({super.key, required this.card, this.isLocked = false});

  final CardModel card;
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
              child: OnlineCardCorner(card: card),
            ),
            Align(
              alignment: Alignment.center,
              child: Center(
                child: Text(
                  card.suit.symbol,
                  style: TextStyle(fontSize: 28, color: card.suit.color),
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomRight,
              child: OnlineCardCorner(card: card, rotate: true),
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
