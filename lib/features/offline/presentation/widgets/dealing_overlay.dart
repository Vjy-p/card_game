import 'package:card_game/features/offline/presentation/widgets/cards/card_back.dart';
import 'package:flutter/material.dart';

class DealingCardAnimate extends StatelessWidget {
  final Offset startOffset;
  final Offset endOffset;
  final VoidCallback onComplete;

  const DealingCardAnimate({
    super.key,
    required this.startOffset,
    required this.endOffset,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween<Offset>(begin: startOffset, end: endOffset),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      onEnd: onComplete,
      builder: (context, offset, child) {
        return Positioned(
          left: offset.dx,
          top: offset.dy,
          child: Container(
            width: 40,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black26)],
            ),
            child: const CardBack(),
          ),
        );
      },
    );
  }
}
