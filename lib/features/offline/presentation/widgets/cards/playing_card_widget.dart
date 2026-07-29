import 'package:card_game/core/theme/card_dimensions.dart';
import 'package:card_game/features/offline/models/playing_card_view_data.dart';
import 'package:card_game/features/offline/presentation/widgets/cards/card_back.dart';
import 'package:card_game/features/offline/presentation/widgets/cards/card_face.dart';
import 'package:flutter/material.dart';

class PlayingCardWidget extends StatelessWidget {
  const PlayingCardWidget({super.key, required this.data, this.onTap});

  final PlayingCardViewData data;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final width = CardDimensions.width(context);

    final height = CardDimensions.height(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        width: width,
        height: height,
        transform: Matrix4.translationValues(0, data.selected ? -18 : 0, 0),
        child: data.faceUp ? CardFace(card: data.card) : const CardBack(),
      ),
    );
  }
}
