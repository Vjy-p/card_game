import 'package:card_game/features/offline/engine/rule_engine.dart';
import 'package:card_game/features/offline/models/card_rank.dart';
import 'package:card_game/features/offline/models/card_suit.dart';
import 'package:card_game/features/offline/models/playing_card.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late RuleEngine ruleEngine;

  setUp(() {
    ruleEngine = RuleEngine();
  });

  PlayingCard makeCard(String id, CardRank rank, CardSuit suit) {
    return PlayingCard(id: id, rank: rank, suit: suit, deckNumber: 1);
  }

  group('RuleEngine - validate4thCard', () {
    test('returns true for 4 cards of the same rank', () {
      final cards = [
        makeCard('1', CardRank.five, CardSuit.hearts),
        makeCard('2', CardRank.five, CardSuit.diamonds),
        makeCard('3', CardRank.five, CardSuit.spades),
        makeCard('4', CardRank.five, CardSuit.clubs),
      ];
      expect(ruleEngine.validate4thCard(cards: cards), isTrue);
    });

    test('returns false if less than 4 cards', () {
      final cards = [
        makeCard('1', CardRank.five, CardSuit.hearts),
        makeCard('2', CardRank.five, CardSuit.diamonds),
        makeCard('3', CardRank.five, CardSuit.spades),
      ];
      expect(ruleEngine.validate4thCard(cards: cards), isFalse);
    });

    test('returns false if more than 4 cards', () {
      final cards = [
        makeCard('1', CardRank.five, CardSuit.hearts),
        makeCard('2', CardRank.five, CardSuit.diamonds),
        makeCard('3', CardRank.five, CardSuit.spades),
        makeCard('4', CardRank.five, CardSuit.clubs),
        makeCard('5', CardRank.five, CardSuit.hearts),
      ];
      expect(ruleEngine.validate4thCard(cards: cards), isFalse);
    });

    test('returns false if ranks are not identical', () {
      final cards = [
        makeCard('1', CardRank.five, CardSuit.hearts),
        makeCard('2', CardRank.five, CardSuit.diamonds),
        makeCard('3', CardRank.five, CardSuit.spades),
        makeCard('4', CardRank.six, CardSuit.clubs),
      ];
      expect(ruleEngine.validate4thCard(cards: cards), isFalse);
    });
  });

  group('RuleEngine - validateGame', () {
    final joker = makeCard('joker', CardRank.ace, CardSuit.spades);

    test('validates 4 sets of 3 or 4 cards with same ranks when joker not unlocked', () {
      final sets = [
        [
          makeCard('1', CardRank.two, CardSuit.hearts),
          makeCard('2', CardRank.two, CardSuit.diamonds),
          makeCard('3', CardRank.two, CardSuit.spades),
        ],
        [
          makeCard('4', CardRank.three, CardSuit.hearts),
          makeCard('5', CardRank.three, CardSuit.diamonds),
          makeCard('6', CardRank.three, CardSuit.spades),
        ],
        [
          makeCard('7', CardRank.four, CardSuit.hearts),
          makeCard('8', CardRank.four, CardSuit.diamonds),
          makeCard('9', CardRank.four, CardSuit.spades),
        ],
        [
          makeCard('10', CardRank.five, CardSuit.hearts),
          makeCard('11', CardRank.five, CardSuit.diamonds),
          makeCard('12', CardRank.five, CardSuit.spades),
          makeCard('13', CardRank.five, CardSuit.clubs),
        ],
      ];

      expect(
        ruleEngine.validateGame(
          sets: sets,
          joker: joker,
          isJokerUnlocked: false,
        ),
        isTrue,
      );
    });

    test('validates sets containing jokers when joker is unlocked', () {
      final sets = [
        [
          makeCard('1', CardRank.two, CardSuit.hearts),
          makeCard('2', CardRank.ace, CardSuit.diamonds), // Joker
          makeCard('3', CardRank.two, CardSuit.spades),
        ],
        [
          makeCard('4', CardRank.three, CardSuit.hearts),
          makeCard('5', CardRank.three, CardSuit.diamonds),
          makeCard('6', CardRank.three, CardSuit.spades),
        ],
        [
          makeCard('7', CardRank.four, CardSuit.hearts),
          makeCard('8', CardRank.four, CardSuit.diamonds),
          makeCard('9', CardRank.four, CardSuit.spades),
        ],
        [
          makeCard('10', CardRank.five, CardSuit.hearts),
          makeCard('11', CardRank.five, CardSuit.diamonds),
          makeCard('12', CardRank.ace, CardSuit.clubs), // Joker
          makeCard('13', CardRank.five, CardSuit.clubs),
        ],
      ];

      expect(
        ruleEngine.validateGame(
          sets: sets,
          joker: joker,
          isJokerUnlocked: true,
        ),
        isTrue,
      );
    });

    test('rejects sets where non-jokers have mismatched ranks', () {
      final sets = [
        [
          makeCard('1', CardRank.two, CardSuit.hearts),
          makeCard('2', CardRank.ace, CardSuit.diamonds), // Joker
          makeCard('3', CardRank.seven, CardSuit.spades), // Different rank!
        ],
        [
          makeCard('4', CardRank.three, CardSuit.hearts),
          makeCard('5', CardRank.three, CardSuit.diamonds),
          makeCard('6', CardRank.three, CardSuit.spades),
        ],
        [
          makeCard('7', CardRank.four, CardSuit.hearts),
          makeCard('8', CardRank.four, CardSuit.diamonds),
          makeCard('9', CardRank.four, CardSuit.spades),
        ],
        [
          makeCard('10', CardRank.five, CardSuit.hearts),
          makeCard('11', CardRank.five, CardSuit.diamonds),
          makeCard('12', CardRank.five, CardSuit.spades),
        ],
      ];

      expect(
        ruleEngine.validateGame(
          sets: sets,
          joker: joker,
          isJokerUnlocked: true,
        ),
        isFalse,
      );
    });

    test('rejects sets if joker is used when joker is NOT unlocked', () {
      final sets = [
        [
          makeCard('1', CardRank.two, CardSuit.hearts),
          makeCard('2', CardRank.ace, CardSuit.diamonds), // Ace is joker, but not unlocked
          makeCard('3', CardRank.two, CardSuit.spades),
        ],
        [
          makeCard('4', CardRank.three, CardSuit.hearts),
          makeCard('5', CardRank.three, CardSuit.diamonds),
          makeCard('6', CardRank.three, CardSuit.spades),
        ],
        [
          makeCard('7', CardRank.four, CardSuit.hearts),
          makeCard('8', CardRank.four, CardSuit.diamonds),
          makeCard('9', CardRank.four, CardSuit.spades),
        ],
        [
          makeCard('10', CardRank.five, CardSuit.hearts),
          makeCard('11', CardRank.five, CardSuit.diamonds),
          makeCard('12', CardRank.five, CardSuit.spades),
        ],
      ];

      expect(
        ruleEngine.validateGame(
          sets: sets,
          joker: joker,
          isJokerUnlocked: false,
        ),
        isFalse,
      );
    });
  });

  group('RuleEngine - getScore', () {
    final joker = makeCard('joker', CardRank.ace, CardSuit.spades);

    test('calculates score with 4th card bonus and show called bonus', () {
      final fourthCards = [
        makeCard('1', CardRank.nine, CardSuit.hearts),
        makeCard('2', CardRank.nine, CardSuit.diamonds),
        makeCard('3', CardRank.nine, CardSuit.spades),
        makeCard('4', CardRank.nine, CardSuit.clubs),
      ];

      final cards = [
        makeCard('5', CardRank.king, CardSuit.hearts),
        makeCard('6', CardRank.king, CardSuit.diamonds),
        makeCard('7', CardRank.king, CardSuit.spades),
      ];

      final score = ruleEngine.getScore(
        cards: cards,
        fourthCards: fourthCards,
        joker: joker,
        isJokerUnlocked: true,
        isShowCalledPlayer: true,
      );

      // fourthCard: +20
      // 3 kings: +20
      // isShowCalledPlayer: +40
      expect(score, equals(80));
    });
  });
}
