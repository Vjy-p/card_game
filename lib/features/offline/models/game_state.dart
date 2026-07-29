import 'package:card_game/features/offline/models/game_move.dart';
import 'package:card_game/features/offline/models/game_status.dart';
import 'package:card_game/features/offline/models/player_model.dart';
import 'package:card_game/features/offline/models/playing_card.dart';

class GameState {
  GameState({
    required this.players,
    required this.currentTurn,
    required this.status,
    required this.history,
    this.forwardCard,
    this.hiddenJoker,
  });

  final List<PlayerModel> players;

  int currentTurn;

  GameStatus status;

  PlayingCard? forwardCard;

  PlayingCard? hiddenJoker;

  final List<GameMove> history;
}
