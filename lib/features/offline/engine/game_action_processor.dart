import 'package:card_game/features/offline/engine/game_action.dart';
import 'package:card_game/features/offline/engine/game_action_queue.dart';

class GameActionProcessor {
  final queue = GameActionQueue();

  Future<void> process() async {
    while (!queue.isEmpty) {
      final action = queue.next()!;

      switch (action.type) {
        case GameActionType.draw:
          break;

        case GameActionType.discard:
          break;

        case GameActionType.turnChanged:
          break;

        case GameActionType.thinking:
          break;

        case GameActionType.gameFinished:
          break;
        case GameActionType.takeForward:
          break;
      }
    }
  }
}
