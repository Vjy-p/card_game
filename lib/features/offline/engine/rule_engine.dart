import 'package:card_game/features/offline/models/playing_card.dart';
import 'package:collection/collection.dart';

class RuleEngine {
  bool validate4thCard({required List<PlayingCard> cards}) {
    if (cards.length != 4) return false;
    final firstRank = cards.first.rank.value;
    for (int i = 1; i < cards.length; i++) {
      if (cards[i].rank.value != firstRank) {
        return false;
      }
    }
    return true;
  }

  bool validateGame({
    required List<List<PlayingCard>> sets,
    required PlayingCard joker,
    required bool isJokerUnlocked,
  }) {
    if (sets.length != 4) return false;

    for (int i = 0; i < sets.length; i++) {
      final set = sets[i];
      final len = set.length;
      if (len != 3 && len != 4) return false;

      if (!isJokerUnlocked) {
        final firstRank = set.first.rank.value;
        for (int j = 1; j < len; j++) {
          if (set[j].rank.value != firstRank) {
            return false;
          }
        }
      } else {
        int? targetRank;
        for (int j = 0; j < len; j++) {
          if (set[j].rank.value != joker.rank.value) {
            targetRank = set[j].rank.value;
            break;
          }
        }
        if (targetRank != null) {
          for (int j = 0; j < len; j++) {
            final rank = set[j].rank.value;
            if (rank != joker.rank.value && rank != targetRank) {
              return false;
            }
          }
        }
      }
    }
    return true;
  }

  int getScore({
    required List<PlayingCard> cards,
    required List<PlayingCard> fourthCards,
    required PlayingCard joker,
    required bool isJokerUnlocked,
    required bool isShowCalledPlayer,
  }) {
    int score = 0;
    final Map<int, List<PlayingCard>> sets = groupBy(cards, (v) => v.rank.value);

    final List<PlayingCard> jokerCards = sets[joker.rank.value] ?? [];
    int jokerCounts = jokerCards.length;
    final bool fourthCard = fourthCards.length == 4;

    sets.remove(joker.rank.value);
    if (fourthCard) {
      score += 20;
    }

    for (final val in sets.keys) {
      final int valCount = sets[val]?.length ?? 0;

      if (valCount == 9) {
        score += 60;
      } else if (valCount == 8) {
        if (jokerCounts > 0 && isJokerUnlocked) {
          score += 55;
          jokerCounts--;
        } else {
          score += 50;
        }
      } else if (valCount == 7) {
        if (jokerCounts > 1 && isJokerUnlocked) {
          score += 55;
          jokerCounts -= 2;
        } else {
          score += 40;
        }
      } else if (valCount == 6) {
        score += 40;
      } else if (valCount == 5) {
        if (jokerCounts > 0 && isJokerUnlocked) {
          score += 35;
          jokerCounts--;
        } else {
          score += 30;
        }
      } else if (valCount == 4) {
        if (jokerCounts > 1 && isJokerUnlocked) {
          score += 35;
          jokerCounts -= 2;
        } else {
          score += 20;
        }
      } else if (valCount == 3) {
        score += 20;
      } else if (valCount == 2) {
        if (jokerCounts > 0 && isJokerUnlocked) {
          score += 15;
          jokerCounts--;
        } else {
          score += 10;
        }
      } else if (valCount == 1) {
        if (jokerCounts > 1 && isJokerUnlocked) {
          score += 15;
          jokerCounts -= 2;
        }
      }
    }

    if (jokerCounts >= 6) {
      score += 40;
    } else if (3 < jokerCounts && jokerCounts < 6) {
      score += 30;
    } else if (jokerCounts == 3) {
      score += 20;
    }

    if (isShowCalledPlayer) {
      score += 40;
    }

    return score;
  }
}
