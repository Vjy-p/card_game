import 'dart:developer';

import 'package:card_game/features/offline/models/playing_card.dart';
import 'package:collection/collection.dart';

class RuleEngine {
  bool validate4thCard({required List<PlayingCard> cards}) {
    int count = 0;

    for (int i = 0; i < cards.length - 1; i++) {
      if (cards[i].rank.value == cards[i + 1].rank.value) {
        count++;
      }
    }
    return count == 3;
  }

  bool validateGame({
    required List<List<PlayingCard>> sets,
    required PlayingCard joker,
    required bool isJokerUnlocked,
  }) {
    log('validate sets $sets $joker ${joker.rank.value} $isJokerUnlocked');
    int count = 0;

    for (int i = 0; i < sets.length; i++) {
      int setCounter = 0;

      if (isJokerUnlocked) {
        for (int j = 0; j < sets[i].length - 1; j++) {
          if (sets[i][j].rank.value == sets[i][j + 1].rank.value ||
              (sets[i][j].rank.value == joker.rank.value ||
                  sets[i][j + 1].rank.value == joker.rank.value)) {
            setCounter++;
          }
        }
      } else {
        for (int j = 0; j < sets[i].length - 1; j++) {
          if (sets[i][j].rank.value == sets[i][j + 1].rank.value) {
            setCounter++;
          }
        }
      }
      log('validate set $count $setCounter');
      if ((sets[i].length == 4 && setCounter == 3) ||
          (sets[i].length == 3 && setCounter == 2)) {
        count++;
      }
    }
    log('validate game $count ');
    return count == 4;
  }

  int getScore({
    required List<PlayingCard> cards,
    required List<PlayingCard> fourthCards,
    required PlayingCard joker,
    required bool isJokerUnlocked,
    required bool isShowCalledPlayer,
  }) {
    int score = 0;
    final Map<int, int> counts = {};
    log('validate sets $cards $joker ${joker.rank.value} $isJokerUnlocked');
    Map<dynamic, List<PlayingCard>> sets = {};

    sets = groupBy(cards, (v) => v.rank.value.toString());
    log('sets before $sets');

    final List<PlayingCard> jokerCards =
        sets[joker.rank.value.toString()] ?? [];
    int jokerCounts = jokerCards.length;
    final bool fourthCard = fourthCards.length == 4;

    sets.remove(joker.rank.value.toString());
    log('sets after $sets');
    if (fourthCard) {
      score += 20;
    }

    for (String val in sets.keys) {
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
        } else {
          score += 0;
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

    log('counts $counts');

    log('score $score ');
    return score;
  }
}
