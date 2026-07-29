import 'package:card_game/features/offline/ai/ai_decision_factors.dart';
import 'package:card_game/features/offline/ai/ai_move.dart';
import 'package:card_game/features/offline/ai/ai_strategy.dart';
import 'package:card_game/features/offline/ai/ai_turn_decision_engine.dart';
import 'package:card_game/features/offline/engine/game_engine.dart';
import 'package:card_game/features/offline/models/player_model.dart';
import 'package:card_game/features/offline/models/playing_card.dart';

/// Hard difficulty AI strategy: Advanced evaluation with opponent modeling
class HardAIStrategy extends AIStrategy {
  final _decisionEngine = const AITurnDecisionEngine();
  @override
  Future<AIMove> decideMove({
    required GameEngine engine,
    required PlayerModel player,
  }) async {
    final forwardCard = engine.deckManager.forwardCard;
    final workingHand = List<PlayingCard>.from(player.hand);
    final joker = engine.deckManager.hiddenJoker;

    bool takeOpen = false;
    bool shouldUnlockJoker = false;
    bool leadsToWin = false;
    List<PlayingCard> fourthCard = [];

    // 1. Determine Draw Action
    if (forwardCard != null) {
      final potentialHand = [...workingHand, forwardCard];

      leadsToWin = _decisionEngine.canDeclareWin(
        hand: potentialHand,
        joker: joker,
        isJokerUnlocked: player.jokerUnlocked.value,
      );

      fourthCard = _decisionEngine.hasFourOfAKind(potentialHand);

      final bool completesFour = fourthCard.isNotEmpty;

      if (leadsToWin || completesFour) {
        takeOpen = true;
        workingHand.add(forwardCard);
        if (completesFour) shouldUnlockJoker = true;
      } else {
        // Evaluate based on standard draw factors
        // Note: We build a temporary context for the 13-card hand to decide the draw
        final drawContext = _decisionEngine.buildTurnContext(
          engine: engine,
          player: player,
          hand: workingHand,
        );
        final drawFactors = _decisionEngine.evaluateDrawAction(
          context: drawContext,
          isDifficult: true,
        );

        if (drawFactors.shouldTakeOpen && drawFactors.riskLevel < 0.5) {
          takeOpen = true;
          workingHand.add(forwardCard);
        }
      }
    }

    // 2. Build FINAL context based on the hand AFTER drawing
    // (If takeOpen was false, workingHand is still 13 cards. If true, it's 14)
    final context = _decisionEngine.buildTurnContext(
      engine: engine,
      player: player,
      hand: workingHand,
    );

    // 3. Select discard based on the FRESH context
    final discard = _selectAdvancedDiscard(
      hand: workingHand,
      context: context,
      engine: engine,
      player: player,
    );

    // if (!leadsToWin && workingHand.length == 14 && !takeOpen) {
    //   leadsToWin = _decisionEngine.canDeclareWin(
    //     hand: workingHand,
    //     joker: joker,
    //     isJokerUnlocked: player.jokerUnlocked.value,
    //   );
    // }

    return AIMove(
      takeOpenCard: takeOpen,
      discardCard: discard,
      unlockJoker: shouldUnlockJoker,
      declareWin: leadsToWin,
      fourthCard: fourthCard,
    );
  }

  /// Advanced discard selection with multiple factors
  PlayingCard _selectAdvancedDiscard({
    required List<PlayingCard> hand,
    required TurnDecisionContext context,
    required GameEngine engine,
    required PlayerModel player,
  }) {
    final lockedCards = _decisionEngine.getLockedCards(hand, context);
    final eligibleCandidates = hand
        .where((card) => !lockedCards.contains(card))
        .toList();
    final activeList = eligibleCandidates.isEmpty ? hand : eligibleCandidates;

    PlayingCard? bestDiscard;
    double lowestScore = 999999.0;

    // Analyze each card with advanced metrics
    for (final card in activeList) {
      final score = _advancedCardScore(
        card: card,
        hand: hand,
        context: context,
      );

      if (score < lowestScore) {
        lowestScore = score;
        bestDiscard = card;
      }
    }

    return bestDiscard ?? hand.first;
  }

  /// Advanced card scoring with multiple factors
  double _advancedCardScore({
    required PlayingCard card,
    required List<PlayingCard> hand,
    required TurnDecisionContext context,
  }) {
    double score = 0.0;

    // Base importance score
    score += _decisionEngine.scoreCardForDiscard(card: card, context: context);

    // Position factor: cards we have many of are safer to discard
    final rankStr = card.rank.toString();
    final frequency = context.handAnalysis.rankFrequency[rankStr] ?? 0;

    // Penalty for having few of this rank
    if (frequency == 1) {
      score -= 30.0; // Prioritize discarding singles
    }

    // Set completion factor
    if (frequency == 3) {
      score += 50.0; // Keep 3-of-a-kind (building towards 4)
    }

    return score;
  }
}
