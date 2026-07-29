import 'package:card_game/features/offline/models/playing_card.dart';
import 'package:card_game/features/offline/presentation/widgets/hand/hand_fan_layout.dart';
import 'package:flutter/material.dart';

class PlayerHand extends StatelessWidget {
  const PlayerHand({
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
    return SizedBox(
      height: 180,
      child: HandFanLayout(
        cards: cards,
        selectedCard: selectedCard,
        onCardTap: onCardTap,
      ),
    );
  }
}
