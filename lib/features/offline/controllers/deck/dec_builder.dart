import 'package:card_game/features/offline/models/card_rank.dart';
import 'package:card_game/features/offline/models/card_suit.dart';
import 'package:card_game/features/offline/models/playing_card.dart';

class DeckBuilder {
  List<PlayingCard> build(int deckCount) {
    final cards = <PlayingCard>[];

    for (var deck = 1; deck <= deckCount; deck++) {
      for (final suit in CardSuit.values) {
        for (final rank in CardRank.values) {
          cards.add(
            PlayingCard(
              id: '${deck}_${rank.name}_${suit.name}',
              rank: rank,
              suit: suit,
              deckNumber: deck,
            ),
          );
        }
      }
    }

    return cards;
  }
}
