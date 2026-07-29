import 'package:card_game/features/offline/models/card_suit.dart';
import 'package:card_game/features/offline/models/playing_card.dart';
import 'package:flutter/material.dart';

class CardCorner extends StatelessWidget {
  const CardCorner({super.key, required this.card, this.rotate = false});

  final PlayingCard card;
  final bool rotate;

  @override
  Widget build(BuildContext context) {
    Widget child = Row(
      // mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          card.rank.label,
          style: TextStyle(color: card.suit.color, fontWeight: FontWeight.bold),
        ),
        Text(card.suit.symbol, style: TextStyle(color: card.suit.color)),
      ],
    );

    if (rotate) {
      child = RotatedBox(quarterTurns: 2, child: child);
    }

    return child;
  }
}
