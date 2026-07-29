import 'package:card_game/features/offline/models/playing_card.dart';

enum MoveType { drawDeck, pickForward, pass, show, timeout }

class GameMove {
  GameMove({
    required this.playerId,
    required this.type,
    this.card,
    required this.time,
  });

  final String playerId;

  final MoveType type;

  final PlayingCard? card;

  final DateTime time;
}
