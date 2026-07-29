import 'dart:math';

import 'package:card_game/features/offline/ai/ai_move.dart';
import 'package:card_game/features/offline/ai/ai_strategy.dart';
import 'package:card_game/features/offline/ai/ai_turn_decision_engine.dart';
import 'package:card_game/features/offline/engine/game_engine.dart';
import 'package:card_game/features/offline/models/player_model.dart';
import 'package:card_game/features/offline/models/playing_card.dart';

/// Easy difficulty AI strategy: Makes somewhat random, less optimal decisions
class EasyAIStrategy extends AIStrategy {
  final _decisionEngine = const AITurnDecisionEngine();
  final _random = Random();

  @override
  Future<AIMove> decideMove({
    required GameEngine engine,
    required PlayerModel player,
  }) async {
    final forwardCard = engine.deckManager.forwardCard;
    // 1. Create a local working copy of the hand
    final workingHand = List<PlayingCard>.from(player.hand);

    bool takeOpen = false;
    bool shouldUnlockJoker = false;
    bool leadsToWin = false;
    List<PlayingCard> fourthCard = [];

    // 2. Draw Decision Logic
    if (forwardCard != null) {
      final potentialHand = [...workingHand, forwardCard];

      // Easy AI quirk: 50% chance to "notice" a winning hand or a 4-of-a-kind
      if (_random.nextDouble() < 0.5) {
        leadsToWin = _decisionEngine.canDeclareWin(
          hand: potentialHand,
          joker: engine.deckManager.hiddenJoker,
          isJokerUnlocked: player.jokerUnlocked.value,
        );

        fourthCard = _decisionEngine.hasFourOfAKind(potentialHand);

        final bool completesFour = fourthCard.isNotEmpty;

        if (leadsToWin || completesFour) {
          takeOpen = true;
          workingHand.add(forwardCard); // Update working hand immediately
          if (completesFour) {
            shouldUnlockJoker = true; // Signal intent, don't modify state
          }
        }
      }
    }

    // 3. Build FRESH context using the updated working hand (Fixes stale context bug)
    final context = _decisionEngine.buildTurnContext(
      engine: engine,
      player: player,
      hand: workingHand,
    );

    // 4. Discard Decision Logic
    final PlayingCard discard;
    final lockedCards = _decisionEngine.getLockedCards(workingHand, context);
    final eligibleCandidates = workingHand
        .where((card) => !lockedCards.contains(card))
        .toList();

    final activeList = eligibleCandidates.isEmpty
        ? workingHand
        : eligibleCandidates;

    if (_random.nextDouble() < 0.3) {
      // 30% chance: completely random discard from current hand
      discard = activeList[_random.nextInt(activeList.length)];
    } else {
      // 70% chance: use evaluator with the fresh context
      discard = _decisionEngine.recommendDiscard(
        hand: workingHand,
        context: context,
      );
    }

    //   if (!leadsToWin && workingHand.length == 14 && !takeOpen) {
    //   leadsToWin = _decisionEngine.canDeclareWin(
    //     hand: workingHand,
    //     joker: engine.deckManager.hiddenJoker,
    //     isJokerUnlocked: player.jokerUnlocked.value,
    //   );
    // }

    // 5. Return result with unlock instruction
    return AIMove(
      takeOpenCard: takeOpen,
      discardCard: discard,
      unlockJoker: shouldUnlockJoker,
      declareWin: leadsToWin,
      fourthCard: fourthCard,
    );
  }
}
