import 'package:card_game/features/offline/models/passed_card_record.dart';
import 'package:card_game/features/offline/models/playing_card.dart';

/// Tracks game history and patterns for AI learning
class AIMemory {
  /// Cards passed by each opponent (player seat -> list of cards)
  final Map<int, List<PlayingCard>> opponentDiscards = {};

  /// Cards taken from open pile (player seat -> list of cards)
  final Map<int, List<PlayingCard>> opponentTakes = {};

  /// Legacy passed card records
  final List<PassedCardRecord> passedCards = [];

  /// Number of turns for pattern analysis window
  static const int patternWindowSize = 10;

  /// Records a card discard
  void recordDiscard({
    required int playerSeat,
    required PlayingCard card,
  }) {
    opponentDiscards.putIfAbsent(playerSeat, () => []).add(card);
  }

  /// Records a card taken from open pile
  void recordOpenCardTaken({
    required int playerSeat,
    required PlayingCard card,
  }) {
    opponentTakes.putIfAbsent(playerSeat, () => []).add(card);
  }

  /// Gets discard pattern for opponent
  List<PlayingCard> getDiscardPattern({required int playerSeat}) {
    final allDiscards = opponentDiscards[playerSeat] ?? [];
    // Return recent discards for pattern analysis
    return allDiscards.length > patternWindowSize
        ? allDiscards.sublist(allDiscards.length - patternWindowSize)
        : allDiscards;
  }

  /// Checks if opponent likely has a card based on history
  bool opponentLikelyHasCard({
    required int playerSeat,
    required PlayingCard card,
  }) {
    final discards = opponentDiscards[playerSeat] ?? [];
    // If we've seen them discard this rank, they don't have it now
    return !discards.any((c) => c.rank == card.rank);
  }

  /// Clears memory (for new game)
  void clear() {
    opponentDiscards.clear();
    opponentTakes.clear();
    passedCards.clear();
  }

  /// Gets most frequently discarded cards
  Map<String, int> getMostFrequentDiscards({required int playerSeat}) {
    final frequency = <String, int>{};
    final discards = opponentDiscards[playerSeat] ?? [];

    for (final card in discards) {
      final rankStr = card.rank.toString();
      frequency[rankStr] = (frequency[rankStr] ?? 0) + 1;
    }

    return frequency;
  }
}
