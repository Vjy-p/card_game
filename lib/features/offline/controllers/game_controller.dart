import 'dart:developer';

import 'package:card_game/core/services/common_services.dart';
import 'package:card_game/features/offline/controllers/ai_controller.dart';
import 'package:card_game/features/offline/controllers/animations/game_animation_controller.dart';
import 'package:card_game/features/offline/engine/game_engine.dart';
import 'package:card_game/features/offline/engine/rule_engine.dart';
import 'package:card_game/features/offline/models/action_state.dart';
import 'package:card_game/features/offline/models/ai_difficulty.dart';
import 'package:card_game/features/offline/models/game_status.dart';
import 'package:card_game/features/offline/models/player_model.dart';
import 'package:card_game/features/offline/models/player_status.dart';
import 'package:card_game/features/offline/models/player_type.dart';
import 'package:card_game/features/offline/models/playing_card.dart';
import 'package:card_game/features/offline/models/table_view_state.dart';
import 'package:confetti/confetti.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GameController extends GetxController {
  GameController({required GameEngine engine}) : _engine = engine;

  final GameEngine _engine;
  late final AIController _aiController;
  String gameSessionId = DateTime.fromMicrosecondsSinceEpoch.toString();

  final Rx<TableViewState> _table = TableViewState.initial().obs;

  TableViewState get table => _table.value;

  final SupabaseClient supabase = Supabase.instance.client;

  final Rx<PlayingCard?> _selectedCard = Rx<PlayingCard?>(null);

  PlayingCard? get selectedCard => _selectedCard.value;
  PlayingCard? get openCard => _engine.deckManager.openCard;

  ConfettiController confettiController = ConfettiController(
    duration: const Duration(seconds: 5),
  );

  List<PlayerModel> players = [
    PlayerModel(
      id: CommonServices.getUserId(),
      name: CommonServices.getUserName(),
      seat: 0,
      type: PlayerType.human,
    ),
    PlayerModel(
      id: 'AI_1',
      name: 'Player 1',
      seat: 1,
      type: PlayerType.ai,
      difficulty: AIDifficulty.easy,
    ),
    PlayerModel(
      id: 'AI_2',
      name: 'Player 2',
      seat: 2,
      type: PlayerType.ai,
      difficulty: AIDifficulty.hard,
    ),
    PlayerModel(
      id: 'AI_3',
      name: 'Player 3',
      seat: 3,
      type: PlayerType.ai,
      difficulty: AIDifficulty.hard,
    ),
  ];
  List<PlayerModel> winners = [];
  //---------------------------------------------------------------------------
  // Lifecycle
  //---------------------------------------------------------------------------

  @override
  void onInit() {
    super.onInit();
    _aiController = AIController(engine: _engine);
    initializeGame();
  }

  // void initializeGame() {

  //   _engine.startGame(players: players);
  //   refreshTable();
  // }

  Future<void> initializeGame() async {
    gameSessionId = DateTime.fromMicrosecondsSinceEpoch.toString();
    final animController = Get.put(GameAnimationController());

    // 1. This initializes the deck and fills player hands internally
    _engine.startGame(players: players);

    // 2. Capture the hands that were just dealt into a temporary Map
    final Map<int, List<PlayingCard>> capturedHands = {};
    for (var player in players) {
      capturedHands[player.seat] = List<PlayingCard>.from(player.hand);
      // 3. Clear the hands so they are empty for the animation
      player.hand.clear();
      player.fourthCard.clear();
      player.score = 0;
    }

    animController.startDealing();
    refreshTable();

    // 4. Staggered animation: Add cards back to hands one by one
    const int cardsPerPlayer = 13;
    for (int round = 0; round < cardsPerPlayer; round++) {
      for (int seat = 0; seat < players.length; seat++) {
        final card = capturedHands[seat]![round];
        players[seat].hand.add(card);

        refreshTable();
        // Adjust speed here: 50ms is fast, 100ms is standard
        await Future.delayed(const Duration(milliseconds: 60));
      }
    }

    animController.stopDealing();
    refreshTable();
    log('game initialised');
  }

  //---------------------------------------------------------------------------
  // Actions
  //---------------------------------------------------------------------------

  void drawCard() {
    if (!table.canDraw) return;

    try {
      _engine.drawFromDeck(playerSeat: 0);
      _selectedCard.value = null;
      refreshTable();
    } catch (e) {
      refreshTable();
      log('Error Draw Card $e');
    }
  }

  void takeForwardCard() {
    if (!table.canTakeForward) return;
    try {
      _engine.takeForwardCard(playerSeat: 0);
      refreshTable();
    } catch (e) {
      refreshTable();
      log('Error Forward Card $e');
    }
  }

  void passCard(PlayingCard card) {
    try {
      _engine.passCard(playerSeat: 0, card: card);

      refreshTable();
    } catch (e) {
      refreshTable();
      log('Error Pass Card $e');
    }
  }

  void sortCards() {
    try {
      final List<PlayingCard> cards = List.of(players[0].hand);

      cards.sort(
        (a, b) => a.rank.value == b.rank.value
            ? a.deckNumber.compareTo(b.deckNumber)
            : a.rank.value.compareTo(b.rank.value),
      );

      players[0].hand = List.from(cards);
      refreshTable();
    } catch (e) {
      refreshTable();
      log('Error Sort Cards $e');
    }
  }

  bool validate4thCards({required List<PlayingCard> cards}) {
    try {
      players.first.jokerUnlocked.value = RuleEngine().validate4thCard(
        cards: cards,
      );
      if (players.first.jokerUnlocked.value) {
        players.first.fourthCard = List.from(cards);
      }
      sortCards();
      refreshTable();
      return players.first.jokerUnlocked.value;
    } catch (e) {
      refreshTable();
      log('Error Validate 4th Card $e');
      return false;
    }
  }

  bool validateEndGame({required List<List<PlayingCard>> sets}) {
    try {
      final bool value = RuleEngine().validateGame(
        sets: sets,
        joker: table.hiddenJoker!,
        isJokerUnlocked: players.first.jokerUnlocked.value,
      );

      if (value) {
        // players.first;
        sortCards();
        _engine.endGame(players: players);
        for (int i = 0; i < players.length; i++) {
          final int score = RuleEngine().getScore(
            cards: players[i].hand,
            joker: table.hiddenJoker!,
            isJokerUnlocked: players[i].jokerUnlocked.value,
            fourthCards: players[i].fourthCard,
            isShowCalledPlayer: i == 0,
          );
          players[i].score = score;
          final List<PlayingCard> cards = List.of(players[i].hand);
          cards.sort(
            (a, b) => a.rank.value == b.rank.value
                ? a.deckNumber.compareTo(b.deckNumber)
                : a.rank.value.compareTo(b.rank.value),
          );
          players[i].hand = List.from(cards);
        }
        winners = List.from(players);
        winners.sort((a, b) => b.score.compareTo(a.score));
        log('winner ${winners.first.id} ${winners.first.name}');
        confettiController.play();
        update();
        updateUserScore();
      }
      refreshTable();
      return value;
    } catch (e) {
      refreshTable();
      log('Error Validate Game Cards $e');
      return false;
    }
  }

  //---------------------------------------------------------------------------
  // UI Refresh
  //---------------------------------------------------------------------------

  void refreshTable() {
    final opponents = players
        .where((e) => e.seat != 0)
        .map(
          (e) => PlayerStatus(
            id: e.id,
            seat: e.seat,
            name: e.name,
            type: e.type,
            difficulty: e.difficulty,
            cardCount: e.hand.length,
            isCurrentTurn: _engine.turnManager.currentPlayer == e.seat,
            isThinking: false,
            hasWon: false,
            score: e.score,
            isJokerUnlocked: e.jokerUnlocked.value,
          ),
        )
        .toList();
    ActionState actionState;

    if (_engine.turnManager.isFinished) {
      actionState = ActionState.gameFinished;
    } else if (_engine.turnManager.currentPlayer != 0) {
      actionState = ActionState.opponentTurn;
    } else if (_engine.turnManager.waitingForDraw) {
      actionState = ActionState.waitingToDraw;
    } else {
      actionState = ActionState.waitingToDiscard;
    }
    _table.value = TableViewState(
      forwardCard: _engine.deckManager.forwardCard,
      remainingCards: _engine.deckManager.closedDeckCount,
      myCards: List.of(players[0].hand),
      opponents: opponents,
      actionState: actionState,
      selectedCard: _selectedCard.value,
      hiddenJoker: _engine.state.hiddenJoker,
      openCard: _engine.deckManager.openCard,
    );

    _table.refresh();
    update();
  }

  void selectCard(PlayingCard card) {
    try {
      // if (table.actionState != ActionState.waitingToDiscard) {
      //   return;
      // }

      if (_selectedCard.value == card) {
        _selectedCard.value = null;
      } else {
        _selectedCard.value = card;
      }

      refreshTable();
      log('selected card $_selectedCard');
    } catch (e) {
      refreshTable();
      log('Error Select Card $e');
    }
  }

  void clearSelection() {
    if (_selectedCard.value == null) return;
    _selectedCard.value = null;
    refreshTable();
  }

  Future<void> passSelectedCard() async {
    if (_selectedCard.value == null) return;
    try {
      _engine.passCard(playerSeat: 0, card: _selectedCard.value!);

      _selectedCard.value = null;

      refreshTable();

      await _playOpponentTurns();
    } catch (e) {
      refreshTable();
      log('Error Pass Selected Card $e');
    }
  }

  Future<void> _playOpponentTurns() async {
    final session = gameSessionId;

    try {
      while (_engine.turnManager.currentPlayer != 0 &&
          !_engine.turnManager.isFinished) {
        if (session != gameSessionId) {
          return;
        }

        final int currentAiSeat = _engine.turnManager.currentPlayer;
        final PlayerModel aiPlayer = players[currentAiSeat];

        // 1. Tell AI to play its turn and GET the move it made
        // Note: Assuming you update your AIController.playTurn to return the AIMove
        final move = await _aiController.playTurn(aiPlayer);

        if (_engine.state.status != GameStatus.playing) return;

        // 2. CHECK FOR WIN
        // Use the 'move' returned by the AI Controller
        if (move.declareWin) {
          _processGameOver(aiPlayer);
          return; // Stop the loop, game is over
        }

        if (move.unlockJoker) {
          final int index = players.indexWhere((e) => e.id == aiPlayer.id);
          if (index != -1) {
            players[index].jokerUnlocked.value = true;
            players[index].fourthCard = List.from(move.fourthCard);
          }
        }

        // Small delay for realism
        await Future.delayed(const Duration(milliseconds: 300));

        refreshTable();
      }
    } catch (e, stackTree) {
      refreshTable();
      log('Error Opponent Turn $e $stackTree');
    }
  }

  void _processGameOver(PlayerModel winner) {
    try {
      // 2. Set engine to finished
      _engine.endGame(players: players);

      // 3. Calculate scores for EVERYONE
      for (var p in players) {
        final int score = RuleEngine().getScore(
          cards: p.hand,
          joker: table.hiddenJoker!,
          isJokerUnlocked: p.jokerUnlocked.value,
          fourthCards: p.fourthCard,
          isShowCalledPlayer: p.id == winner.id,
        );
        p.score = score;

        // Sort hand for display
        p.hand.sort(
          (a, b) => a.rank.value == b.rank.value
              ? a.deckNumber.compareTo(b.deckNumber)
              : a.rank.value.compareTo(b.rank.value),
        );
      }

      // 4. Sort player list by score to show ranking
      winners = List.from(players);
      winners.sort((a, b) => b.score.compareTo(a.score));

      log('Game Over! Winner: ${winner.name}');

      updateUserScore();
      // confettiController.play();
      refreshTable();
      update(); // Trigger UI refresh
    } catch (e) {
      refreshTable();
      log('Error Game over $e');
    }
  }

  Future<void> restart() async {
    clearData();
    await initializeGame();
    refreshTable();
  }

  Future updateUserScore() async {
    final userID = CommonServices.getUserId();

    final int index = winners.indexWhere((e) => e.id == userID);

    if (index != -1) {
      final resp = await supabase.rpc(
        'update_ai_game_statistics',
        params: {
          'p_player_score': winners[index].score,
          'p_player_rank': index + 1,
        },
      );
      log('user update $resp');
    }
  }

  @override
  void dispose() {
    clearData();
    super.dispose();
  }

  void clearData() {
    try {
      gameSessionId = '';
      confettiController.stop();

      players = [
        PlayerModel(
          id: CommonServices.getUserId(),
          name: CommonServices.getUserName(),
          seat: 0,
          type: PlayerType.human,
        ),
        PlayerModel(
          id: 'AI_1',
          name: 'Player 1',
          seat: 1,
          type: PlayerType.ai,
          difficulty: AIDifficulty.easy,
        ),
        PlayerModel(
          id: 'AI_2',
          name: 'Player 2',
          seat: 2,
          type: PlayerType.ai,
          difficulty: AIDifficulty.hard,
        ),
        PlayerModel(
          id: 'AI_3',
          name: 'Player 3',
          seat: 3,
          type: PlayerType.ai,
          difficulty: AIDifficulty.hard,
        ),
      ];
      winners.clear();
      _engine.reset();
      _table.refresh();

      _selectedCard.value = null;
      // refreshTable();
      // final opponents = players
      //     .where((e) => e.seat != 0)
      //     .map(
      //       (e) => PlayerStatus(
      //         id: e.id,
      //         seat: e.seat,
      //         name: e.name,
      //         type: e.type,
      //         difficulty: e.difficulty,
      //         cardCount: e.hand.length,
      //         isCurrentTurn: _engine.turnManager.currentPlayer == e.seat,
      //         isThinking: false,
      //         hasWon: false,
      //         score: e.score,
      //         isJokerUnlocked: e.jokerUnlocked.value,
      //       ),
      //     )
      //     .toList();
      // _table.value = TableViewState(
      //   forwardCard: null,
      //   hiddenJoker: null,
      //   openCard: null,
      //   remainingCards: 0,
      //   opponents: [],
      //   myCards: [],
      //   actionState: ActionState.waitingToDraw,
      //   selectedCard: null,
      // );

      _table.refresh();
    } catch (e) {
      // refreshTable();
      log('Clear Data $e');
    }
  }
}
