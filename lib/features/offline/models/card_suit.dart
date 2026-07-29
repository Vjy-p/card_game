import 'dart:ui';

import 'package:card_game/core/theme/app_colors.dart';

enum CardSuit {
  spades('♠'),
  hearts('♥'),
  diamonds('♦'),
  clubs('♣');

  const CardSuit(this.symbol);

  final String symbol;
}

extension CardSuitExtension on CardSuit {
  Color get color {
    switch (this) {
      case CardSuit.hearts:
      case CardSuit.diamonds:
        return AppColors.cardRed;

      case CardSuit.spades:
      case CardSuit.clubs:
        return AppColors.cardBlack;
    }
  }
}
