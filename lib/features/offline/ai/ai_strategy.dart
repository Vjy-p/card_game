import 'package:card_game/features/offline/ai/ai_move.dart';
import 'package:card_game/features/offline/engine/game_engine.dart';
import 'package:card_game/features/offline/models/player_model.dart';

abstract class AIStrategy {
  Future<AIMove> decideMove({
    required GameEngine engine,
    required PlayerModel player,
  });
}
