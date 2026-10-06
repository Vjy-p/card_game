import 'package:card_game/features/offline/controllers/deck/deck_manager.dart';
import 'package:card_game/features/offline/models/card_rank.dart';
import 'package:card_game/features/offline/models/card_suit.dart';
import 'package:card_game/features/offline/models/playing_card.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DeckManager - Initialization', () {
    test('throws ArgumentError if playerCount is less than 2 or greater than 10', () {
      final deckManager = DeckManager();

      expect(() => deckManager.initialize(playerCount: 1), throwsArgumentError);
      expect(() => deckManager.initialize(playerCount: 11), throwsArgumentError);
    });

    test('initializes with 2 decks for 2-4 players (104 cards)', () {
      final deckManager = DeckManager(seed: 42);
      deckManager.initialize(playerCount: 4);

      expect(deckManager.playerCount, 4);
      expect(deckManager.deckCount, 2);
      expect(deckManager.closedDeckCount, 104);
      expect(deckManager.hiddenJoker, isNotNull);
      expect(deckManager.openCard, isNotNull);
      expect(deckManager.forwardCard, isNull);
      expect(deckManager.passedHistoryCount, 0);
    });

    test('initializes with 3 decks for 5-7 players (156 cards)', () {
      final deckManager = DeckManager(seed: 42);
      deckManager.initialize(playerCount: 6);

      expect(deckManager.deckCount, 3);
      expect(deckManager.closedDeckCount, 156);
    });

    test('initializes with 4 decks for 8-10 players (208 cards)', () {
      final deckManager = DeckManager(seed: 42);
      deckManager.initialize(playerCount: 8);

      expect(deckManager.deckCount, 4);
      expect(deckManager.closedDeckCount, 208);
    });

    test('throws StateError when accessing methods before initialize', () {
      final deckManager = DeckManager();

      expect(() => deckManager.dealCards(), throwsStateError);
      expect(() => deckManager.revealInitialForwardCard(), throwsStateError);
      expect(() => deckManager.drawCard(), throwsStateError);
      expect(() => deckManager.takeForwardCard(), throwsStateError);
      expect(
        () => deckManager.passCard(
          card: const PlayingCard(
            id: '1',
            rank: CardRank.ace,
            suit: CardSuit.spades,
            deckNumber: 1,
          ),
          playerSeat: 0,
        ),
        throwsStateError,
      );
      expect(() => deckManager.hiddenJoker, throwsStateError);
      expect(() => deckManager.openCard, throwsStateError);
    });
  });

  group('DeckManager - Dealing Cards', () {
    test('deals 13 cards per player in round-robin fashion', () {
      final deckManager = DeckManager(seed: 123);
      deckManager.initialize(playerCount: 4);

      const initialCount = 104;
      final hands = deckManager.dealCards(cardsPerPlayer: 13);

      expect(hands.length, 4);
      for (int seat = 0; seat < 4; seat++) {
        expect(hands[seat]!.length, 13);
      }
      expect(deckManager.closedDeckCount, initialCount - (4 * 13));
    });

    test('deals custom number of cards per player', () {
      final deckManager = DeckManager(seed: 123);
      deckManager.initialize(playerCount: 2);

      final hands = deckManager.dealCards(cardsPerPlayer: 7);
      expect(hands[0]!.length, 7);
      expect(hands[1]!.length, 7);
      expect(deckManager.closedDeckCount, 104 - 14);
    });
  });

  group('DeckManager - Forward Card Lifecycle', () {
    test('reveals initial forward card and rejects second reveal', () {
      final deckManager = DeckManager(seed: 99);
      deckManager.initialize(playerCount: 2);

      final countBefore = deckManager.closedDeckCount;
      final card = deckManager.revealInitialForwardCard();

      expect(deckManager.hasForwardCard, isTrue);
      expect(deckManager.forwardCard, equals(card));
      expect(deckManager.closedDeckCount, countBefore - 1);

      // Revealing again while card exists must throw StateError
      expect(() => deckManager.revealInitialForwardCard(), throwsStateError);
    });

    test('takeForwardCard consumes the forward card', () {
      final deckManager = DeckManager(seed: 99);
      deckManager.initialize(playerCount: 2);
      final revealed = deckManager.revealInitialForwardCard();

      final taken = deckManager.takeForwardCard();
      expect(taken, equals(revealed));
      expect(deckManager.hasForwardCard, isFalse);
      expect(deckManager.forwardCard, isNull);

      // Taking again when null must throw StateError
      expect(() => deckManager.takeForwardCard(), throwsStateError);
    });

    test('passCard updates forwardCard and archives previous card into history', () {
      final deckManager = DeckManager(seed: 77);
      deckManager.initialize(playerCount: 2);
      final initial = deckManager.revealInitialForwardCard();

      const newPass = PlayingCard(
        id: 'new_pass',
        rank: CardRank.king,
        suit: CardSuit.hearts,
        deckNumber: 1,
      );

      deckManager.passCard(card: newPass, playerSeat: 0);

      expect(deckManager.forwardCard, equals(newPass));
      expect(deckManager.passedHistoryCount, 1);
      expect(deckManager.passedHistory.first.card, equals(initial));
      expect(deckManager.passedHistory.first.playerSeat, 0);
      expect(deckManager.lastPassedCard?.card, equals(initial));
    });
  });

  group('DeckManager - Draw & Reshuffle', () {
    test('drawCard removes cards from closed deck', () {
      final deckManager = DeckManager(seed: 55);
      deckManager.initialize(playerCount: 2);

      final before = deckManager.closedDeckCount;
      final drawn = deckManager.drawCard();

      expect(drawn, isNotNull);
      expect(deckManager.closedDeckCount, before - 1);
    });

    test('drawCard reshuffles passed history when closed deck is exhausted', () {
      final deckManager = DeckManager(seed: 55);
      deckManager.initialize(playerCount: 2);

      // Drain the deck by drawing almost all cards
      while (deckManager.closedDeckCount > 1) {
        deckManager.drawCard();
      }

      // Pass two cards to populate passed history
      deckManager.passCard(
        card: const PlayingCard(
          id: 'p1',
          rank: CardRank.two,
          suit: CardSuit.spades,
          deckNumber: 1,
        ),
        playerSeat: 0,
      );
      deckManager.passCard(
        card: const PlayingCard(
          id: 'p2',
          rank: CardRank.three,
          suit: CardSuit.diamonds,
          deckNumber: 1,
        ),
        playerSeat: 1,
      );

      expect(deckManager.passedHistoryCount, 1);

      // Draw the last card from closed deck
      deckManager.drawCard();
      expect(deckManager.closedDeckCount, 0);

      // Drawing next card should trigger reshuffle from passed history
      final cardFromReshuffle = deckManager.drawCard();
      expect(cardFromReshuffle, isNotNull);
      expect(deckManager.passedHistoryCount, 0);
    });

    test('clearData resets all manager state', () {
      final deckManager = DeckManager(seed: 42);
      deckManager.initialize(playerCount: 4);
      deckManager.revealInitialForwardCard();

      deckManager.clearData();

      expect(deckManager.playerCount, 0);
      expect(deckManager.deckCount, 0);
      expect(deckManager.closedDeckCount, 0);
      expect(deckManager.passedHistoryCount, 0);
      expect(deckManager.forwardCard, isNull);
      expect(() => deckManager.hiddenJoker, throwsStateError);
    });
  });
}
