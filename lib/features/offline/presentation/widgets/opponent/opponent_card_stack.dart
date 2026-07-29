import 'package:card_game/features/offline/presentation/widgets/cards/card_back.dart';
import 'package:flutter/material.dart';

class OpponentCardStack extends StatelessWidget {
  final int cardCount;
  const OpponentCardStack({super.key, required this.cardCount});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 38,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Stack(
          key: ValueKey(cardCount), // Rebuilds stack when count changes
          children: List.generate(cardCount, (index) {
            return Positioned(
              left: index * 3.5, // Tighter spacing for opponents
              child: Container(
                width: 24,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade900,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.white54, width: 0.5),
                ),
                child: const CardBack(),
              ),
            );
          }),
        ),
      ),
    );
  }
}
