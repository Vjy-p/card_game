import 'package:card_game/features/offline/models/card_suit.dart';
import 'package:card_game/features/offline/models/playing_card.dart';
import 'package:flutter/material.dart';

class CardCenter extends StatelessWidget {
  const CardCenter({super.key, required this.card});

  final PlayingCard card;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        card.suit.symbol,
        style: TextStyle(fontSize: 28, color: card.suit.color),
      ),
    );
  }
}
