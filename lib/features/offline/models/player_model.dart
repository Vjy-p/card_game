import 'package:card_game/features/offline/models/ai_difficulty.dart';
import 'package:card_game/features/offline/models/player_type.dart';
import 'package:card_game/features/offline/models/playing_card.dart';
import 'package:get/get.dart';

class PlayerModel {
  PlayerModel({
    required this.id,
    required this.name,
    required this.seat,
    required this.type,
    this.difficulty,
  });

  final String id;

  final String name;

  final int seat;

  final PlayerType type;

  final AIDifficulty? difficulty;

  List<PlayingCard> hand = [];
  List<PlayingCard> fourthCard = [];

  RxBool jokerUnlocked = false.obs;

  bool isThinking = false;

  PlayingCard? joker;

  int score = 0;

  bool skipped = false;

  bool get isAI => type == PlayerType.ai;

  bool get isHuman => type == PlayerType.human;
}
