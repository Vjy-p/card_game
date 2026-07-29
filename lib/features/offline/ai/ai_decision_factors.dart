import 'package:card_game/features/offline/models/playing_card.dart';

/// Represents decision factors for draw action evaluation
class DrawDecisionFactors {
  /// Whether to take the open card
  final bool shouldTakeOpen;

  /// Confidence score (0.0 to 1.0)
  final double confidence;

  /// Reason for the decision
  final String reason;

  /// Risk assessment (0.0 = safe, 1.0 = risky)
  final double riskLevel;

  const DrawDecisionFactors({
    required this.shouldTakeOpen,
    required this.confidence,
    required this.reason,
    this.riskLevel = 0.5,
  });
}

/// Represents decision factors for discard action evaluation
class DiscardDecisionFactors {
  /// Card to discard
  final PlayingCard card;

  /// Confidence score (0.0 to 1.0)
  final double confidence;

  /// Reason for the decision
  final String reason;

  /// Card importance score (0.0 = not important, 1.0 = critical)
  final double importance;

  /// Discard risk level (0.0 = safe to discard, 1.0 = risky)
  final double discardRisk;

  const DiscardDecisionFactors({
    required this.card,
    required this.confidence,
    required this.reason,
    this.importance = 0.5,
    this.discardRisk = 0.5,
  });
}

/// Represents board state analysis
class BoardStateAnalysis {
  /// Number of cards in deck
  final int deckSize;

  /// Number of cards in open pile
  final int openPileSize;

  /// Open card (if available)
  final PlayingCard? openCard;

  /// Number of players
  final int playerCount;

  /// Current turn number
  final int turnNumber;

  /// Cards each player likely has
  final Map<int, int> playerHandSizes;

  const BoardStateAnalysis({
    required this.deckSize,
    required this.openPileSize,
    required this.openCard,
    required this.playerCount,
    required this.turnNumber,
    required this.playerHandSizes,
  });
}

/// Represents hand analysis metrics
class HandAnalysis {
  /// Total cards in hand
  final int handSize;

  /// Cards grouped by rank
  final Map<String, int> rankFrequency;

  /// Paired cards (rank: count)
  final Map<String, int> pairedCards;

  /// Single cards (unpaired)
  final int singleCards;

  /// Sequence potential (consecutive ranks)
  final int sequencePotential;

  /// Set potential (same rank)
  final int setPotential;

  const HandAnalysis({
    required this.handSize,
    required this.rankFrequency,
    required this.pairedCards,
    required this.singleCards,
    required this.sequencePotential,
    required this.setPotential,
  });
}

/// Represents opponent analysis for decision making
class OpponentAnalysis {
  /// Seat position
  final int seat;

  /// Player name
  final String name;

  /// Estimated hand size
  final int estimatedHandSize;

  /// Discard patterns observed
  final List<PlayingCard> discardedCards;

  /// Cards likely in hand (based on memory)
  final List<PlayingCard> estimatedCards;

  /// Threat level (0.0 = low, 1.0 = high)
  final double threatLevel;

  const OpponentAnalysis({
    required this.seat,
    required this.name,
    required this.estimatedHandSize,
    required this.discardedCards,
    required this.estimatedCards,
    required this.threatLevel,
  });
}

/// Complete turn decision context
class TurnDecisionContext {
  /// Current player's hand analysis
  final HandAnalysis handAnalysis;

  /// Current board state
  final BoardStateAnalysis boardState;

  /// Opponent analyses
  final List<OpponentAnalysis> opponentAnalyses;

  /// Joker rank for this game
  final String jokerRank;

  /// Whether joker is unlocked
  final bool jokerUnlocked;

  /// Cards visible in open pile
  final List<PlayingCard> visibleCards;

  const TurnDecisionContext({
    required this.handAnalysis,
    required this.boardState,
    required this.opponentAnalyses,
    required this.jokerRank,
    required this.jokerUnlocked,
    required this.visibleCards,
  });
}
