import 'package:card_game/core/theme/card_dimensions.dart';
import 'package:card_game/features/offline/presentation/widgets/cards/card_back.dart';
import 'package:card_game/features/online/room/models/online_player_view_data.dart';
import 'package:card_game/features/online/room/presentation/widgets/online_card_face.dart';
import 'package:flutter/material.dart';

class OnlinePlayerCardWidget extends StatelessWidget {
  const OnlinePlayerCardWidget({super.key, required this.data, this.onTap});

  final OnlinePlayerViewData data;

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
        child: data.card == null
            ? CardBack()
            : data.faceUp && data.card != null
            ? OnlineCardFace(card: data.card!)
            : const CardBack(),
      ),
    );
  }
}
