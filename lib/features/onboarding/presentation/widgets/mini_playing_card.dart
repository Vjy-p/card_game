import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/core/theme/app_radius.dart';
import 'package:flutter/material.dart';

class MiniPlayingCard extends StatelessWidget {
  const MiniPlayingCard({
    required this.rank,
    required this.suit,
    this.width = 68,
    this.highlighted = false,
    super.key,
  });

  final String rank;
  final String suit;
  final double width;
  final bool highlighted;

  bool get _isRed => suit == '♥' || suit == '♦';

  @override
  Widget build(BuildContext context) {
    final suitColor = _isRed ? AppColors.cardRed : AppColors.cardBlack;
    return Semantics(
      label: '$rank of ${_suitName(suit)}',
      child: Container(
        width: width,
        height: width * 1.42,
        padding: EdgeInsets.all(width * 0.1),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(
            color: highlighted ? AppColors.actionPrimary : Colors.white24,
            width: highlighted ? 3 : 1,
          ),
          boxShadow: const [
            BoxShadow(color: Color(0x33000000), blurRadius: 16, offset: Offset(0, 8)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(rank, style: TextStyle(color: suitColor, fontSize: width * 0.27, fontWeight: FontWeight.w800, height: 1)),
            Text(suit, style: TextStyle(color: suitColor, fontSize: width * 0.25, height: 1)),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(suit, style: TextStyle(color: suitColor, fontSize: width * 0.35, height: 1)),
            ),
          ],
        ),
      ),
    );
  }

  String _suitName(String value) => switch (value) {
    '♠' => 'Spades',
    '♥' => 'Hearts',
    '♦' => 'Diamonds',
    '♣' => 'Clubs',
    _ => 'Unknown suit',
  };
}
