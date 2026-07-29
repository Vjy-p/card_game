import 'dart:collection';

import 'package:card_game/features/offline/engine/game_action.dart';

class GameActionQueue {
  final Queue<GameAction> _queue = Queue();

  bool get isEmpty => _queue.isEmpty;

  void add(GameAction action) {
    _queue.add(action);
  }

  GameAction? next() {
    if (_queue.isEmpty) return null;
    return _queue.removeFirst();
  }

  void clear() {
    _queue.clear();
  }
}
