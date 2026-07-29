import 'package:card_game/features/offline/ai/ai_decision_factors.dart';
import 'package:card_game/features/offline/engine/game_engine.dart';
import 'package:card_game/features/offline/engine/rule_engine.dart';
import 'package:card_game/features/offline/models/card_rank.dart';
import 'package:card_game/features/offline/models/player_model.dart';
import 'package:card_game/features/offline/models/playing_card.dart';

/// Central AI Turn Decision Engine that analyzes game state and provides strategic decisions
class AITurnDecisionEngine {
  const AITurnDecisionEngine();

  // Groups a flat list of cards into groups by Rank for validation
  List<List<PlayingCard>> _groupHandIntoSets(List<PlayingCard> hand) {
    final Map<CardRank, List<PlayingCard>> groups = {};
    for (var card in hand) {
      groups.putIfAbsent(card.rank, () => []).add(card);
    }
    // Only return groups that are potentially valid sets (3 or 4 cards)
    // RuleEngine.validateGame expects exactly 4 sets to return true
    return groups.values.where((list) => list.length >= 3).toList();
  }

  bool canDeclareWin({
    required List<PlayingCard> hand,
    required PlayingCard? joker,
    required bool isJokerUnlocked,
  }) {
    if (hand.isEmpty || joker == null) return false;

    // Simulate the hand after a discard (usually winning hand is checked on 13 cards)
    // We group them and see if they satisfy the 4-set requirement
    final sets = _groupHandIntoSets(hand);

    return RuleEngine().validateGame(
      sets: sets,
      joker: joker,
      isJokerUnlocked: isJokerUnlocked,
    );
  }

  List<PlayingCard> hasFourOfAKind(List<PlayingCard> hand) {
    final Map<CardRank, List<PlayingCard>> groups = {};
    List<PlayingCard> fourthCard = [];

    for (var card in hand) {
      groups.putIfAbsent(card.rank, () => []).add(card);
    }

    for (var set in groups.values) {
      if (set.length == 4 && RuleEngine().validate4thCard(cards: set)) {
        fourthCard = List.from(set);
        return fourthCard;
      }
    }
    return fourthCard;
  }

  /// Builds complete turn decision context from game state
  TurnDecisionContext buildTurnContext({
    required GameEngine engine,
    required PlayerModel player,
    required List<PlayingCard> hand,
  }) {
    // Build hand analysis
    final handAnalysis = _analyzeHand(hand, engine);

    // Build board state analysis
    final boardState = _analyzeBoardState(engine, player);

    // Build opponent analyses
    final opponents = engine.state.players
        .where((p) => p.seat != player.seat)
        .map((p) => _analyzeOpponent(p, engine))
        .toList();

    return TurnDecisionContext(
      handAnalysis: handAnalysis,
      boardState: boardState,
      opponentAnalyses: opponents,
      jokerRank: engine.state.hiddenJoker?.rank.toString() ?? 'unknown',
      jokerUnlocked: player.jokerUnlocked.value,
      visibleCards: [
        if (engine.deckManager.forwardCard != null)
          engine.deckManager.forwardCard!,
      ],
    );
  }

  /// Analyzes player's hand for patterns and potential
  HandAnalysis _analyzeHand(List<PlayingCard> hand, GameEngine engine) {
    final rankFrequency = <String, int>{};
    final pairedCards = <String, int>{};

    for (final card in hand) {
      final rankStr = card.rank.toString();
      rankFrequency[rankStr] = (rankFrequency[rankStr] ?? 0) + 1;
    }

    for (final entry in rankFrequency.entries) {
      if (entry.value >= 2) {
        pairedCards[entry.key] = entry.value;
      }
    }

    return HandAnalysis(
      handSize: hand.length,
      rankFrequency: rankFrequency,
      pairedCards: pairedCards,
      singleCards: rankFrequency.values.where((count) => count == 1).length,
      sequencePotential: _calculateSequencePotential(hand),
      setPotential: pairedCards.values.fold(0, (sum, count) => sum + count),
    );
  }

  /// Analyzes current board state
  BoardStateAnalysis _analyzeBoardState(GameEngine engine, PlayerModel player) {
    final players = engine.state.players;
    final playerHandSizes = <int, int>{};

    for (final p in players) {
      playerHandSizes[p.seat] = p.hand.length;
    }

    return BoardStateAnalysis(
      deckSize: engine.deckManager.closedDeckCount,
      openPileSize: engine.deckManager.passedHistoryCount,
      openCard: engine.deckManager.forwardCard,
      playerCount: players.length,
      turnNumber: engine.turnManager.turnNumber,
      playerHandSizes: playerHandSizes,
    );
  }

  /// Analyzes opponent characteristics and threat level
  OpponentAnalysis _analyzeOpponent(PlayerModel opponent, GameEngine engine) {
    final threatLevel = _calculateThreatLevel(opponent, engine);

    return OpponentAnalysis(
      seat: opponent.seat,
      name: opponent.name,
      estimatedHandSize: opponent.hand.length,
      discardedCards: [], // Would be populated from AIMemory
      estimatedCards: [], // Cards likely in opponent's hand
      threatLevel: threatLevel,
    );
  }

  /// Calculates threat level for an opponent (0.0 to 1.0)
  /// Considers hand size relative to average and opponent seat position
  double _calculateThreatLevel(PlayerModel opponent, GameEngine engine) {
    final handSize = opponent.hand.length;
    final totalHands = engine.state.players.length;
    final avgHandSize =
        engine.state.players.fold<int>(0, (sum, p) => sum + p.hand.length) ~/
        totalHands;

    double threatScore = 0.5; // Base threat level

    // Hand size factor: being ahead increases threat
    if (handSize < avgHandSize) {
      threatScore += 0.3; // Opponent is ahead - significantly higher threat
    } else if (handSize > avgHandSize) {
      threatScore -= 0.3; // Opponent is behind - lower threat
    }

    // Seat position factor: closer to current turn = more immediate threat
    final currentPlayerSeat = engine.state.currentTurn;
    final seatDistance = (opponent.seat - currentPlayerSeat).abs();
    final minDistance = seatDistance.clamp(1, totalHands ~/ 2);
    final normalizedDistance = minDistance / (totalHands ~/ 2);

    // Closer opponents are more threatening (less time to prepare)
    threatScore += (1.0 - normalizedDistance) * 0.2;

    return threatScore.clamp(0.0, 1.0);
  }

  /// Calculates potential for sequences in hand
  int _calculateSequencePotential(List<PlayingCard> hand) {
    if (hand.isEmpty) return 0;

    final ranks = <int>[];
    final rankMap = {
      'A': 1,
      '2': 2,
      '3': 3,
      '4': 4,
      '5': 5,
      '6': 6,
      '7': 7,
      '8': 8,
      '9': 9,
      '10': 10,
      'J': 11,
      'Q': 12,
      'K': 13,
    };

    for (final card in hand) {
      final rankStr = card.rank.toString().split('.').last;
      if (rankMap.containsKey(rankStr)) {
        ranks.add(rankMap[rankStr]!);
      }
    }

    if (ranks.isEmpty) return 0;

    ranks.sort();
    int maxSequence = 1;
    int currentSequence = 1;

    for (int i = 1; i < ranks.length; i++) {
      if (ranks[i] == ranks[i - 1] + 1) {
        currentSequence++;
        maxSequence = maxSequence > currentSequence
            ? maxSequence
            : currentSequence;
      } else {
        currentSequence = 1;
      }
    }

    return maxSequence;
  }

  /// Evaluates draw action based on context
  DrawDecisionFactors evaluateDrawAction({
    required TurnDecisionContext context,
    required bool isDifficult,
  }) {
    if (context.boardState.openCard == null) {
      return DrawDecisionFactors(
        shouldTakeOpen: false,
        confidence: 0.9,
        reason: 'No open card available',
      );
    }

    final openCard = context.boardState.openCard!;
    final jokerRank = context.jokerRank;

    // Check if it's a joker
    final isJoker = openCard.rank.toString() == jokerRank;
    if (isJoker) {
      return DrawDecisionFactors(
        shouldTakeOpen: true,
        confidence: 1.0,
        reason: 'Open card is joker',
        riskLevel: 0.0,
      );
    }

    // Check if it forms a pair
    final matchingCards =
        context.handAnalysis.rankFrequency[openCard.rank.toString()] ?? 0;
    final formsSet = matchingCards > 0;

    if (formsSet) {
      final confidence =
          (matchingCards / 4) * 0.9 + 0.1; // Scale by how many matches
      return DrawDecisionFactors(
        shouldTakeOpen: true,
        confidence: confidence,
        reason: 'Card forms pair ($matchingCards matches)',
        riskLevel: 0.1,
      );
    }

    // Default to draw from deck
    return DrawDecisionFactors(
      shouldTakeOpen: false,
      confidence: 0.8,
      reason: 'No strategic benefit to open card',
      riskLevel: 0.2,
    );
  }

  /// Scores a card for discard action
  double scoreCardForDiscard({
    required PlayingCard card,
    required TurnDecisionContext context,
  }) {
    // Never discard jokers
    if (context.jokerUnlocked && card.rank.toString() == context.jokerRank) {
      return 1000.0; // Highest score = keep
    }

    final rankStr = card.rank.toString();
    final frequency = context.handAnalysis.rankFrequency[rankStr] ?? 0;

    // Score based on how many of this rank we have
    switch (frequency) {
      case 4:
        return 100.0; // Keep - full set
      case 3:
        return 90.0; // Keep - close to full set
      case 2:
        return 70.0; // Keep - pair
      default:
        return 10.0; // Low priority - single card
    }
  }

  List<PlayingCard> getLockedCards(
    List<PlayingCard> hand,
    TurnDecisionContext context,
  ) {
    final List<PlayingCard> locked = [];

    // 1. Identify 4-of-a-kind sets
    final Map<String, List<PlayingCard>> groups = {};
    for (var card in hand) {
      final rankStr = card.rank.toString();
      groups.putIfAbsent(rankStr, () => []).add(card);
    }

    for (var group in groups.values) {
      if (group.length >= 4) {
        // Use the rule engine to confirm this is a valid 4th-card set
        if (RuleEngine().validate4thCard(cards: group)) {
          locked.addAll(group);
        }
      }
    }

    // 2. Identify the Joker
    for (var card in hand) {
      if (context.jokerUnlocked && card.rank.toString() == context.jokerRank) {
        locked.add(card);
      }
    }

    return locked;
  }

  /// Recommends best discard from hand
  PlayingCard recommendDiscard({
    required List<PlayingCard> hand,
    required TurnDecisionContext context,
  }) {
    final lockedCards = getLockedCards(hand, context);
    final eligibleCandidates = hand
        .where((card) => !lockedCards.contains(card))
        .toList();

    final activeList = eligibleCandidates.isEmpty ? hand : eligibleCandidates;

    PlayingCard? bestDiscard;
    var lowestScore = 999999.0;

    for (final card in activeList) {
      final score = scoreCardForDiscard(card: card, context: context);

      if (score < lowestScore) {
        lowestScore = score;
        bestDiscard = card;
      }
    }

    return bestDiscard ?? hand.first;
  }
}
