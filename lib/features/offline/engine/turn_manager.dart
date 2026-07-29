import 'package:card_game/features/offline/models/turn_info.dart';
import 'package:card_game/features/offline/models/turn_state.dart';

class TurnManager {
  TurnManager({required int playerCount}) : _playerCount = playerCount;

  final int _playerCount;

  int _currentPlayer = 0;

  int _turnNumber = 1;

  TurnState _state = TurnState.waitingToDraw;

  DateTime _turnStartedAt = DateTime.now();

  //---------------------------------------------------------------------------
  // Getters
  //---------------------------------------------------------------------------

  int get currentPlayer => _currentPlayer;

  int get turnNumber => _turnNumber;

  TurnState get state => _state;

  bool get waitingForDraw => _state == TurnState.waitingToDraw;

  bool get waitingForPass => _state == TurnState.waitingToPass;

  bool get isFinished => _state == TurnState.finished;

  TurnInfo get info {
    return TurnInfo(
      turnNumber: _turnNumber,
      currentPlayer: _currentPlayer,
      state: _state,
      turnStartedAt: _turnStartedAt,
    );
  }

  //---------------------------------------------------------------------------
  // Game Start
  //---------------------------------------------------------------------------

  void start({int firstPlayer = 0}) {
    if (firstPlayer < 0 || firstPlayer >= _playerCount) {
      throw ArgumentError('Invalid first player.');
    }

    _currentPlayer = firstPlayer;

    _turnNumber = 1;

    _state = TurnState.waitingToDraw;

    _turnStartedAt = DateTime.now();
  }

  //---------------------------------------------------------------------------
  // Validation
  //---------------------------------------------------------------------------

  bool isPlayersTurn(int seat) {
    return seat == _currentPlayer;
  }

  bool canDraw(int seat) {
    return isPlayersTurn(seat) && _state == TurnState.waitingToDraw;
  }

  bool canPass(int seat) {
    return isPlayersTurn(seat) && _state == TurnState.waitingToPass;
  }

  //---------------------------------------------------------------------------
  // State Changes
  //---------------------------------------------------------------------------

  void playerDrewCard(int seat) {
    if (!canDraw(seat)) {
      throw StateError('Player cannot draw now.');
    }

    _state = TurnState.waitingToPass;
  }

  void playerPassedCard(int seat) {
    if (!canPass(seat)) {
      throw StateError('Player cannot pass now.');
    }

    _nextPlayer();
  }

  void timeout() {
    _nextPlayer();
  }

  void finishGame() {
    _state = TurnState.finished;
  }

  //---------------------------------------------------------------------------
  // Next Player
  //---------------------------------------------------------------------------

  void _nextPlayer() {
    _state = TurnState.switching;

    _currentPlayer++;

    if (_currentPlayer >= _playerCount) {
      _currentPlayer = 0;
    }

    _turnNumber++;

    _state = TurnState.waitingToDraw;

    _turnStartedAt = DateTime.now();
  }

  bool canTakeForward(int playerSeat) {
    return canDraw(playerSeat);
  }

  void clearData() {
    _state = TurnState.finished;
  }
}
