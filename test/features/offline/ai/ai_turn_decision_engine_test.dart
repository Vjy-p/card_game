import 'package:card_game/features/offline/ai/ai_decision_factors.dart';
import 'package:card_game/features/offline/ai/ai_turn_decision_engine.dart';
import 'package:card_game/features/offline/controllers/game_config.dart';
import 'package:card_game/features/offline/engine/game_engine.dart';
import 'package:card_game/features/offline/models/card_rank.dart';
import 'package:card_game/features/offline/models/card_suit.dart';
import 'package:card_game/features/offline/models/player_model.dart';
import 'package:card_game/features/offline/models/player_type.dart';
import 'package:card_game/features/offline/models/playing_card.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const engine = AITurnDecisionEngine();

  PlayingCard makeCard(String id, CardRank rank, CardSuit suit) {
    return PlayingCard(id: id, rank: rank, suit: suit, deckNumber: 1);
  }

  GameEngine createRunningGame() {
    final gameEngine = GameEngine(config: const GameConfig());
    final players = [
      PlayerModel(id: '1', name: 'Player 1', seat: 0, type: PlayerType.human),
      PlayerModel(id: '2', name: 'AI 1', seat: 1, type: PlayerType.ai),
    ];
    gameEngine.startGame(players: players);
    return gameEngine;
  }

  group('AITurnDecisionEngine - canDeclareWin', () {
    test('returns false when hand is empty or joker is null', () {
      final joker = makeCard('joker', CardRank.king, CardSuit.hearts);

      expect(
        engine.canDeclareWin(hand: [], joker: joker, isJokerUnlocked: true),
        isFalse,
      );
      expect(
        engine.canDeclareWin(
          hand: [makeCard('1', CardRank.ace, CardSuit.spades)],
          joker: null,
          isJokerUnlocked: true,
        ),
        isFalse,
      );
    });

    test('returns false for incomplete sets', () {
      final joker = makeCard('joker', CardRank.king, CardSuit.hearts);
      final hand = [
        makeCard('1', CardRank.two, CardSuit.hearts),
        makeCard('2', CardRank.two, CardSuit.spades),
        makeCard('3', CardRank.three, CardSuit.hearts),
      ];

      expect(
        engine.canDeclareWin(hand: hand, joker: joker, isJokerUnlocked: true),
        isFalse,
      );
    });

    test('returns true for four valid natural sets', () {
      final joker = makeCard('j', CardRank.king, CardSuit.diamonds);
      final hand = [
        // Set 1: 3 Twos
        makeCard('1', CardRank.two, CardSuit.hearts),
        makeCard('2', CardRank.two, CardSuit.diamonds),
        makeCard('3', CardRank.two, CardSuit.spades),
        // Set 2: 3 Fours
        makeCard('4', CardRank.four, CardSuit.hearts),
        makeCard('5', CardRank.four, CardSuit.diamonds),
        makeCard('6', CardRank.four, CardSuit.clubs),
        // Set 3: 3 Sevens
        makeCard('7', CardRank.seven, CardSuit.hearts),
        makeCard('8', CardRank.seven, CardSuit.spades),
        makeCard('9', CardRank.seven, CardSuit.clubs),
        // Set 4: 4 Tens (one 4-card set, total 13 cards)
        makeCard('10', CardRank.ten, CardSuit.hearts),
        makeCard('11', CardRank.ten, CardSuit.diamonds),
        makeCard('12', CardRank.ten, CardSuit.spades),
        makeCard('13', CardRank.ten, CardSuit.clubs),
      ];

      expect(
        engine.canDeclareWin(hand: hand, joker: joker, isJokerUnlocked: false),
        isTrue,
      );
    });
  });

  group('AITurnDecisionEngine - hasFourOfAKind', () {
    test('returns empty list when no rank has 4 cards', () {
      final hand = [
        makeCard('1', CardRank.ace, CardSuit.hearts),
        makeCard('2', CardRank.ace, CardSuit.diamonds),
        makeCard('3', CardRank.ace, CardSuit.spades),
        makeCard('4', CardRank.two, CardSuit.clubs),
      ];

      expect(engine.hasFourOfAKind(hand), isEmpty);
    });

    test('returns the 4 cards when hand has four-of-a-kind', () {
      final hand = [
        makeCard('1', CardRank.five, CardSuit.hearts),
        makeCard('2', CardRank.five, CardSuit.diamonds),
        makeCard('3', CardRank.five, CardSuit.spades),
        makeCard('4', CardRank.five, CardSuit.clubs),
        makeCard('5', CardRank.nine, CardSuit.hearts),
      ];

      final fourOfAKind = engine.hasFourOfAKind(hand);
      expect(fourOfAKind.length, 4);
      expect(fourOfAKind.every((c) => c.rank == CardRank.five), isTrue);
    });
  });

  group('AITurnDecisionEngine - sequence potential & hand analysis', () {
    test('evaluates sequence potential through turn context', () {
      final gameEngine = createRunningGame();
      final player = gameEngine.state.players.first;

      final sequenceHand = [
        makeCard('1', CardRank.three, CardSuit.hearts),
        makeCard('2', CardRank.four, CardSuit.diamonds),
        makeCard('3', CardRank.five, CardSuit.spades),
        makeCard('4', CardRank.six, CardSuit.clubs),
        makeCard('5', CardRank.ten, CardSuit.hearts),
      ];

      final context = engine.buildTurnContext(
        engine: gameEngine,
        player: player,
        hand: sequenceHand,
      );

      // 3, 4, 5, 6 is a sequence of length 4
      expect(context.handAnalysis.sequencePotential, 4);
      expect(context.handAnalysis.handSize, 5);
      expect(context.handAnalysis.singleCards, 5);
      expect(context.handAnalysis.setPotential, 0);
    });

    test('detects paired cards and set potential', () {
      final gameEngine = createRunningGame();
      final player = gameEngine.state.players.first;

      final handWithPairs = [
        makeCard('1', CardRank.eight, CardSuit.hearts),
        makeCard('2', CardRank.eight, CardSuit.diamonds),
        makeCard('3', CardRank.eight, CardSuit.spades),
        makeCard('4', CardRank.jack, CardSuit.hearts),
        makeCard('5', CardRank.jack, CardSuit.spades),
      ];

      final context = engine.buildTurnContext(
        engine: gameEngine,
        player: player,
        hand: handWithPairs,
      );

      expect(context.handAnalysis.pairedCards.length, 2);
      expect(context.handAnalysis.setPotential, 5);
      expect(context.handAnalysis.singleCards, 0);
    });
  });

  group('AITurnDecisionEngine - evaluateDrawAction', () {
    test('rejects draw from open pile when open card is null', () {
      const context = TurnDecisionContext(
        handAnalysis: HandAnalysis(
          handSize: 1,
          rankFrequency: {'2': 1},
          pairedCards: {},
          singleCards: 1,
          sequencePotential: 1,
          setPotential: 0,
        ),
        boardState: BoardStateAnalysis(
          deckSize: 40,
          openPileSize: 0,
          openCard: null,
          playerCount: 2,
          turnNumber: 1,
          playerHandSizes: {0: 13, 1: 13},
        ),
        opponentAnalyses: [],
        jokerRank: 'CardRank.ace',
        jokerUnlocked: false,
        visibleCards: [],
      );

      final decision = engine.evaluateDrawAction(
        context: context,
        isDifficult: false,
      );
      expect(decision.shouldTakeOpen, isFalse);
    });

    test('always takes open card when it matches joker rank', () {
      final openCard = makeCard('open', CardRank.queen, CardSuit.hearts);

      final contextWithJoker = TurnDecisionContext(
        handAnalysis: const HandAnalysis(
          handSize: 1,
          rankFrequency: {'2': 1},
          pairedCards: {},
          singleCards: 1,
          sequencePotential: 1,
          setPotential: 0,
        ),
        boardState: BoardStateAnalysis(
          deckSize: 40,
          openPileSize: 1,
          openCard: openCard,
          playerCount: 2,
          turnNumber: 1,
          playerHandSizes: {0: 13, 1: 13},
        ),
        opponentAnalyses: [],
        jokerRank: CardRank.queen.toString(),
        jokerUnlocked: false,
        visibleCards: [openCard],
      );

      final decision = engine.evaluateDrawAction(
        context: contextWithJoker,
        isDifficult: true,
      );
      expect(decision.shouldTakeOpen, isTrue);
      expect(decision.confidence, 1.0);
      expect(decision.reason, contains('joker'));
    });

    test('takes open card when it forms or extends a set', () {
      final openCard = makeCard('open', CardRank.seven, CardSuit.diamonds);

      final context = TurnDecisionContext(
        handAnalysis: HandAnalysis(
          handSize: 3,
          rankFrequency: {
            CardRank.seven.toString(): 2,
            CardRank.two.toString(): 1,
          },
          pairedCards: {CardRank.seven.toString(): 2},
          singleCards: 1,
          sequencePotential: 1,
          setPotential: 2,
        ),
        boardState: BoardStateAnalysis(
          deckSize: 40,
          openPileSize: 1,
          openCard: openCard,
          playerCount: 2,
          turnNumber: 1,
          playerHandSizes: {0: 3, 1: 3},
        ),
        opponentAnalyses: [],
        jokerRank: CardRank.ace.toString(),
        jokerUnlocked: false,
        visibleCards: [openCard],
      );

      final decision = engine.evaluateDrawAction(
        context: context,
        isDifficult: false,
      );
      expect(decision.shouldTakeOpen, isTrue);
      expect(decision.reason, contains('2 matches'));
    });
  });

  group('AITurnDecisionEngine - scoreCardForDiscard & recommendDiscard', () {
    test('protects 4-of-a-kind and unlocked joker from discard', () {
      final fourAces = [
        makeCard('1', CardRank.ace, CardSuit.hearts),
        makeCard('2', CardRank.ace, CardSuit.diamonds),
        makeCard('3', CardRank.ace, CardSuit.spades),
        makeCard('4', CardRank.ace, CardSuit.clubs),
      ];
      final jokerCard = makeCard('j', CardRank.nine, CardSuit.hearts);
      final singleCard = makeCard('s', CardRank.three, CardSuit.clubs);

      final hand = [...fourAces, jokerCard, singleCard];

      final context = TurnDecisionContext(
        handAnalysis: HandAnalysis(
          handSize: 6,
          rankFrequency: {
            CardRank.ace.toString(): 4,
            CardRank.nine.toString(): 1,
            CardRank.three.toString(): 1,
          },
          pairedCards: {CardRank.ace.toString(): 4},
          singleCards: 2,
          sequencePotential: 1,
          setPotential: 4,
        ),
        boardState: const BoardStateAnalysis(
          deckSize: 40,
          openPileSize: 1,
          openCard: null,
          playerCount: 2,
          turnNumber: 1,
          playerHandSizes: {0: 6, 1: 6},
        ),
        opponentAnalyses: [],
        jokerRank: CardRank.nine.toString(),
        jokerUnlocked: true,
        visibleCards: [],
      );

      final locked = engine.getLockedCards(hand, context);
      expect(locked.length, 5); // 4 aces + 1 joker
      expect(locked.contains(singleCard), isFalse);

      final recommended = engine.recommendDiscard(hand: hand, context: context);
      expect(recommended, equals(singleCard));
    });

    test('prefers discarding single card over pairs or triples', () {
      final hand = [
        makeCard('1', CardRank.king, CardSuit.hearts),
        makeCard('2', CardRank.king, CardSuit.diamonds),
        makeCard('3', CardRank.king, CardSuit.spades),
        makeCard('4', CardRank.four, CardSuit.hearts),
      ];

      final context = TurnDecisionContext(
        handAnalysis: HandAnalysis(
          handSize: 4,
          rankFrequency: {
            CardRank.king.toString(): 3,
            CardRank.four.toString(): 1,
          },
          pairedCards: {CardRank.king.toString(): 3},
          singleCards: 1,
          sequencePotential: 1,
          setPotential: 3,
        ),
        boardState: const BoardStateAnalysis(
          deckSize: 40,
          openPileSize: 1,
          openCard: null,
          playerCount: 2,
          turnNumber: 1,
          playerHandSizes: {0: 4, 1: 4},
        ),
        opponentAnalyses: [],
        jokerRank: CardRank.ace.toString(),
        jokerUnlocked: false,
        visibleCards: [],
      );

      final recommended = engine.recommendDiscard(hand: hand, context: context);
      expect(recommended.rank, CardRank.four);
    });
  });
}
