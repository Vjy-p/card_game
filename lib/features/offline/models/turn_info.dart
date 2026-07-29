import 'package:card_game/features/offline/models/turn_state.dart';

class TurnInfo {
  const TurnInfo({
    required this.turnNumber,
    required this.currentPlayer,
    required this.state,
    required this.turnStartedAt,
  });

  final int turnNumber;

  final int currentPlayer;

  final TurnState state;

  final DateTime turnStartedAt;

  Duration get elapsed => DateTime.now().difference(turnStartedAt);
}
