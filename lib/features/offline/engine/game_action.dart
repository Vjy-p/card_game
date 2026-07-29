import 'package:card_game/features/offline/models/playing_card.dart';

enum GameActionType {
  draw,
  takeForward,
  discard,
  turnChanged,
  thinking,
  gameFinished,
}

class GameAction {
  const GameAction({required this.type, this.playerSeat, this.card});

  final GameActionType type;
  final int? playerSeat;
  final PlayingCard? card;
}
