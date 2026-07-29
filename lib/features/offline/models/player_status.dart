import 'package:card_game/features/offline/models/ai_difficulty.dart';
import 'package:card_game/features/offline/models/player_type.dart';

class PlayerStatus {
  const PlayerStatus({
    required this.id,
    required this.seat,
    required this.name,
    required this.type,
    required this.cardCount,
    required this.isCurrentTurn,
    required this.isThinking,
    required this.hasWon,
    required this.score,
    required this.isJokerUnlocked,
    this.difficulty,
    this.avatarUrl,
  });

  final String id;
  final int seat;
  final String name;

  final PlayerType type;
  final AIDifficulty? difficulty;

  final int cardCount;
  final int score;

  final bool isCurrentTurn;
  final bool isThinking;
  final bool hasWon;

  final bool isJokerUnlocked;

  final String? avatarUrl;

  bool get isHuman => type == PlayerType.human;

  bool get isAI => type == PlayerType.ai;
}
