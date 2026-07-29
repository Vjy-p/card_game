import 'package:card_game/features/offline/models/playing_card.dart';

enum MeldType { threeOfKind, fourOfKind }

class Meld {
  const Meld({
    required this.cards,
    required this.type,
    required this.jokerCount,
    required this.isNatural,
    required this.score,
  });

  final List<PlayingCard> cards;

  final MeldType type;

  /// Number of joker cards used.
  final int jokerCount;

  /// True if the meld contains no jokers.
  final bool isNatural;

  /// Score awarded for this meld.
  final int score;
}
