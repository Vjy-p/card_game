// features/offline/controllers/ai_controller.dart
import 'dart:math';

import 'package:card_game/features/offline/ai/ai_engine.dart';
import 'package:card_game/features/offline/ai/ai_move.dart';
import 'package:card_game/features/offline/ai/ai_turn_decision_engine.dart';
import 'package:card_game/features/offline/ai/easy_ai_strategy.dart';
import 'package:card_game/features/offline/ai/hard_ai_strategy.dart';
import 'package:card_game/features/offline/ai/medium_ai_strategy.dart';
import 'package:card_game/features/offline/controllers/game_controller.dart';
import 'package:card_game/features/offline/engine/game_engine.dart';
import 'package:card_game/features/offline/models/ai_difficulty.dart';
import 'package:card_game/features/offline/models/player_model.dart';
import 'package:card_game/features/offline/models/playing_card.dart';
import 'package:get/get.dart';

class AIController extends GetxController {
  AIController({required GameEngine engine}) : _engine = engine;

  final GameEngine _engine;

  // Map strategies to engines
  final Map<AIDifficulty, AIEngine> _aiEngines = {
    AIDifficulty.easy: AIEngine(EasyAIStrategy()),
    AIDifficulty.medium: AIEngine(MediumAIStrategy()),
    AIDifficulty.hard: AIEngine(HardAIStrategy()),
  };

  final decisionEngine = const AITurnDecisionEngine();

  // Helper to refresh the UI via the GameController
  void _triggerRefresh() {
    if (Get.isRegistered<GameController>()) {
      Get.find<GameController>().refreshTable();
    }
  }

  Future<AIMove> playTurn(PlayerModel player) async {
    final difficulty = player.difficulty ?? AIDifficulty.medium;
    final aiEngine = _aiEngines[difficulty]!;

    // await _animation.enqueue(() async {
    // 1. Thinking Phase
    player.isThinking = true;
    _triggerRefresh();
    await Future.delayed(_thinkingDelay(difficulty));

    // await _animation.thinking();

    // 2. Decision Phase
    AIMove move = await aiEngine.playTurn(engine: _engine, player: player);

    // 3. Execution Phase: Draw
    if (move.takeOpenCard) {
      _engine.takeForwardCard(playerSeat: player.seat);
    } else {
      _engine.drawFromDeck(playerSeat: player.seat);

      final bool winAfterDeckDraw = decisionEngine.canDeclareWin(
        hand: player.hand,
        joker: _engine.deckManager.hiddenJoker,
        isJokerUnlocked: player.jokerUnlocked.value,
      );

      final List<PlayingCard> fourthCard = decisionEngine.hasFourOfAKind(
        player.hand,
      );

      final bool completesFour = fourthCard.isNotEmpty;

      if (winAfterDeckDraw) {
        // Update the move object to signal a win
        move = AIMove(
          takeOpenCard: move.takeOpenCard,
          discardCard: move.discardCard,
          unlockJoker: move.unlockJoker,
          declareWin: true,
        );
      } else if (completesFour) {
        // Update the move object to signal a win
        move = AIMove(
          takeOpenCard: move.takeOpenCard,
          discardCard: move.discardCard,
          unlockJoker: completesFour,
          declareWin: false,
          fourthCard: fourthCard,
        );
      }
    }

    _triggerRefresh();
    // Brief pause so human can see what card was drawn/taken
    await Future.delayed(const Duration(milliseconds: 800));

    // 4. Execution Phase: Pass
    _engine.passCard(playerSeat: player.seat, card: move.discardCard);

    player.isThinking = false;
    _triggerRefresh();
    // });
    return move;
  }

  Duration _thinkingDelay(AIDifficulty difficulty) {
    final random = Random().nextInt(500);
    switch (difficulty) {
      case AIDifficulty.easy:
        return Duration(milliseconds: 1500 + random);
      case AIDifficulty.medium:
        return Duration(milliseconds: 1000 + random);
      case AIDifficulty.hard:
        return Duration(milliseconds: 500 + random);
    }
  }
}
