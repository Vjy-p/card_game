import 'package:card_game/features/offline/models/ai_difficulty.dart';
import 'package:card_game/features/offline/models/player_model.dart';

class AIPlayer {
  const AIPlayer({required this.player, required this.difficulty});

  final PlayerModel player;
  final AIDifficulty difficulty;
}
