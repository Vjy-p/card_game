import 'package:card_game/features/offline/models/playing_card.dart';
import 'package:flutter/material.dart';

class HandFanLayout extends StatelessWidget {
  const HandFanLayout({
    super.key,
    required this.cards,
    required this.selectedCard,
    required this.onCardTap,
  });
  final List<PlayingCard> cards;
  final PlayingCard? selectedCard;
  final ValueChanged<PlayingCard> onCardTap;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
