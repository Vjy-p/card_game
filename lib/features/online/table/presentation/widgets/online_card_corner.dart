import 'package:card_game/features/online/table/model/card_model.dart';
import 'package:flutter/material.dart';

class OnlineCardCorner extends StatelessWidget {
  const OnlineCardCorner({super.key, required this.card, this.rotate = false});

  final CardModel card;
  final bool rotate;

  @override
  Widget build(BuildContext context) {
    Widget child = Row(
      // mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          card.cardNumber,
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
