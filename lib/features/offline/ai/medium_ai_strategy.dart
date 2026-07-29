import 'package:card_game/features/offline/ai/ai_decision_factors.dart';
import 'package:card_game/features/offline/ai/ai_move.dart';
import 'package:card_game/features/offline/ai/ai_strategy.dart';
import 'package:card_game/features/offline/ai/ai_turn_decision_engine.dart';
import 'package:card_game/features/offline/engine/game_engine.dart';
import 'package:card_game/features/offline/models/player_model.dart';
import 'package:card_game/features/offline/models/playing_card.dart';

/// Medium difficulty AI strategy: Uses pattern matching and strategic evaluation
class MediumAIStrategy extends AIStrategy {
  final _decisionEngine = const AITurnDecisionEngine();

  @override
  Future<AIMove> decideMove({
    required GameEngine engine,
    required PlayerModel player,
  }) async {
    final forwardCard = engine.deckManager.forwardCard;
    final workingHand = List<PlayingCard>.from(player.hand);
    bool takeOpen = false;
    bool shouldUnlockJoker = false;
    bool leadsToWin = false;
    List<PlayingCard> fourthCard = [];

    if (forwardCard != null) {
      final potentialHand = [...workingHand, forwardCard];
      leadsToWin = _decisionEngine.canDeclareWin(
        hand: potentialHand,
        joker: engine.deckManager.hiddenJoker,
        isJokerUnlocked: player.jokerUnlocked.value,
      );
      fourthCard = _decisionEngine.hasFourOfAKind(potentialHand);

      final bool completesFour = fourthCard.isNotEmpty;

      if (leadsToWin || completesFour) {
        takeOpen = true;
        workingHand.add(forwardCard);
        if (completesFour) shouldUnlockJoker = true;
      }
    }

    // Build context with the hand that now includes the new card (if taken)
    final context = _decisionEngine.buildTurnContext(
      engine: engine,
      player: player,
      hand: workingHand,
    );

    final discard = context.handAnalysis.pairedCards.isNotEmpty
        ? _findLonelyCard(workingHand, context)
        : _decisionEngine.recommendDiscard(hand: workingHand, context: context);

    // if (!leadsToWin && workingHand.length == 14 && !takeOpen) {
    //   leadsToWin = _decisionEngine.canDeclareWin(
    //     hand: workingHand,
    //     joker: engine.deckManager.hiddenJoker,
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

  /// Finds a card with no pairs to discard first
  PlayingCard _findLonelyCard(
    List<PlayingCard> hand,
    TurnDecisionContext context,
  ) {
    final lockedCards = _decisionEngine.getLockedCards(hand, context);

    // Filter out locked cards first
    final candidates = hand.where((c) => !lockedCards.contains(c)).toList();
    if (candidates.isEmpty) return hand.first;

    // Try to find a card that appears alone
    for (final card in candidates) {
      final rankStr = card.rank.toString();
      final frequency = context.handAnalysis.rankFrequency[rankStr] ?? 0;
      if (frequency == 1) {
        return card;
      }
    }
    // If all cards are paired, return first
    return candidates.first;
  }
}
