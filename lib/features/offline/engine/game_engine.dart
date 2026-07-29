import 'package:card_game/features/offline/controllers/deck/deck_manager.dart';
import 'package:card_game/features/offline/controllers/game_config.dart';
import 'package:card_game/features/offline/engine/turn_manager.dart';
import 'package:card_game/features/offline/models/game_state.dart';
import 'package:card_game/features/offline/models/game_status.dart';
import 'package:card_game/features/offline/models/player_model.dart';
import 'package:card_game/features/offline/models/playing_card.dart';
import 'package:card_game/utils/custom_toast.dart';

class GameEngine {
  GameEngine({required GameConfig config}) : _config = config;

  final GameConfig _config;

  final DeckManager _deckManager = DeckManager();

  late TurnManager _turnManager;

  late GameState _state;

  bool _started = false;

  GameState get state => _state;

  DeckManager get deckManager => _deckManager;

  TurnManager get turnManager => _turnManager;

  bool get isStarted => _started;

  //---------------------------------------------------------------------------
  // Start Game
  //---------------------------------------------------------------------------

  void startGame({required List<PlayerModel> players, int? randomSeed}) {
    if (players.length < _config.minPlayers) {
      throw StateError('Minimum ${_config.minPlayers} players required.');
    }

    if (players.length > _config.maxPlayers) {
      throw StateError('Maximum ${_config.maxPlayers} players allowed.');
    }

    _deckManager.initialize(playerCount: players.length);

    final hands = _deckManager.dealCards(
      cardsPerPlayer: _config.cardsPerPlayer,
    );

    for (final player in players) {
      player.hand.clear();
      player.hand.addAll(hands[player.seat]!);
      player.jokerUnlocked.value = false;
    }

    final forwardCard = _deckManager.revealInitialForwardCard();

    _turnManager = TurnManager(playerCount: players.length);

    _turnManager.start(firstPlayer: 0);

    _state = GameState(
      players: players,
      currentTurn: _turnManager.currentPlayer,
      status: GameStatus.playing,
      history: [],
      forwardCard: forwardCard,
      hiddenJoker: _deckManager.hiddenJoker,
    );

    _started = true;
  }

  //---------------------------------------------------------------------------
  // Validation
  //---------------------------------------------------------------------------

  void _ensureStarted() {
    if (!_started) {
      throw StateError('Game has not started.');
    }
  }

  PlayingCard drawFromDeck({required int playerSeat}) {
    _ensureStarted();

    if (!_turnManager.canDraw(playerSeat)) {
      throw StateError('Player cannot draw now.');
    }

    final player = _state.players[playerSeat];

    final card = _deckManager.drawCard();

    player.hand.add(card);

    _turnManager.playerDrewCard(playerSeat);

    return card;
  }

  PlayingCard takeForwardCard({required int playerSeat}) {
    _ensureStarted();

    if (!_turnManager.canDraw(playerSeat)) {
      throw StateError('Player cannot draw now.');
    }

    final player = _state.players[playerSeat];

    final card = _deckManager.takeForwardCard();

    player.hand.add(card);

    _state.forwardCard = null;

    _turnManager.playerDrewCard(playerSeat);

    return card;
  }

  void passCard({required int playerSeat, required PlayingCard card}) {
    _ensureStarted();

    if (!_turnManager.canPass(playerSeat)) {
      customToast(message: 'Player cannot pass now.');
      throw StateError('Player cannot pass now.');
    }

    final player = _state.players[playerSeat];

    if (!player.hand.remove(card)) {
      throw StateError('Player does not own this card.');
    }

    _deckManager.passCard(card: card, playerSeat: playerSeat);

    _state.forwardCard = card;

    _turnManager.playerPassedCard(playerSeat);

    _state.currentTurn = _turnManager.currentPlayer;
  }

  void timeout() {
    _ensureStarted();

    _turnManager.timeout();

    _state.currentTurn = _turnManager.currentPlayer;
  }

  void endGame({required List<PlayerModel> players}) {
    _ensureStarted();
    _turnManager.finishGame();
    _state = GameState(
      players: players,
      currentTurn: _turnManager.currentPlayer,
      status: GameStatus.finished,
      history: [],
      forwardCard: null,
      hiddenJoker: _deckManager.hiddenJoker,
    );
  }

  void reset() {
    _started = false;
    _deckManager.clearData();
    _turnManager.clearData();
  }
}
