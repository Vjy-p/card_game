import 'package:card_game/features/offline/ai/ai_move.dart';
import 'package:card_game/features/offline/ai/ai_strategy.dart';
import 'package:card_game/features/offline/engine/game_engine.dart';
import 'package:card_game/features/offline/models/player_model.dart';

class AIEngine {
  AIEngine(this.strategy);

  final AIStrategy strategy;

  Future<AIMove> playTurn({
    required GameEngine engine,
    required PlayerModel player,
  }) {
    return strategy.decideMove(engine: engine, player: player);
  }
}
