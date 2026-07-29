import 'package:card_game/core/theme/card_dimensions.dart';
import 'package:card_game/features/offline/controllers/hand_controller.dart';
import 'package:card_game/features/offline/models/playing_card.dart';
import 'package:card_game/features/offline/models/playing_card_view_data.dart';
import 'package:card_game/features/offline/presentation/widgets/cards/playing_card_widget.dart';
import 'package:card_game/features/offline/presentation/widgets/hand/hand_widget.dart';
import 'package:flutter/material.dart';

class PlayerHandWidget extends StatelessWidget {
  const PlayerHandWidget({
    super.key,
    required this.cards,
    required this.controller,
    this.onCardTap,
  });

  final List<PlayingCard> cards;
  final HandController controller;
  final ValueChanged<PlayingCard>? onCardTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, _) {
        return SizedBox(
          height: CardDimensions.height(context) + 24,
          child: HandLayout(
            children: cards.map((card) {
              return PlayingCardWidget(
                data: PlayingCardViewData(
                  card: card,
                  selected: controller.isSelected(card.id),
                ),
                onTap: () {
                  controller.toggle(card.id);
                  onCardTap?.call(card);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
