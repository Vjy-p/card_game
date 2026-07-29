import 'package:card_game/features/offline/models/card_rank.dart';
import 'package:card_game/features/offline/models/playing_card.dart';

class AIEvaluator {
  const AIEvaluator();

  /// Higher score = more valuable card.
  int scoreCard({
    required PlayingCard card,
    required List<PlayingCard> hand,
    required CardRank? jokerRank,
    required bool jokerUnlocked,
  }) {
    // Never discard a joker.
    if (jokerUnlocked && jokerRank != null && card.rank == jokerRank) {
      return 1000;
    }

    final sameRank = hand.where((c) => c.rank == card.rank).length;

    switch (sameRank) {
      case 4:
        return 100;
      case 3:
        return 90;
      case 2:
        return 70;
      default:
        return 10;
    }
  }

  PlayingCard chooseDiscard({
    required List<PlayingCard> hand,
    required CardRank? jokerRank,
    required bool jokerUnlocked,
  }) {
    PlayingCard? discard;
    var lowestScore = 999999;

    for (final card in hand) {
      final score = scoreCard(
        card: card,
        hand: hand,
        jokerRank: jokerRank,
        jokerUnlocked: jokerUnlocked,
      );

      if (score < lowestScore) {
        lowestScore = score;
        discard = card;
      }
    }

    return discard!;
  }
}
