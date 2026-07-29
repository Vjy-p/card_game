import 'package:card_game/features/offline/models/card_rank.dart';
import 'package:card_game/features/offline/models/card_suit.dart';

class PlayingCard {
  const PlayingCard({
    required this.id,
    required this.rank,
    required this.suit,
    required this.deckNumber,
  });

  final String id;

  final CardRank rank;

  final CardSuit suit;

  /// Physical deck number.
  /// 1..4
  final int deckNumber;

  String get display => '${rank.label}${suit.symbol}';

  @override
  String toString() => display;

  @override
  bool operator ==(Object other) {
    return other is PlayingCard && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
