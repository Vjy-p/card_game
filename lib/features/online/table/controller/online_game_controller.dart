import 'dart:developer';

import 'package:card_game/features/online/room/controllers/base_controller.dart';
import 'package:card_game/features/online/room/domain/entities/room_lobby_snapshot.dart';
import 'package:card_game/features/online/table/model/card_model.dart';
import 'package:card_game/features/online/table/model/online_player_model.dart';
import 'package:card_game/features/online/table/presentation/screens/online_ranking_screen.dart';
import 'package:card_game/features/online/table/repositories/online_game_services.dart';
import 'package:card_game/utils/custom_toast.dart';
import 'package:confetti/confetti.dart';
import 'package:get/get.dart';

class OnlineGameController extends BaseController {
  OnlineGameController(this.roomId, this.myPlayerId, this.snapshot);
  final String roomId;
  final String myPlayerId;

  ConfettiController confettiController = ConfettiController(
    duration: const Duration(seconds: 5),
  );

  final OnlineGameService _service = Get.put(OnlineGameService());

  final myHand = <CardModel>[].obs;

  final allCards = <CardModel>[].obs;

  RxList<OnlinePlayerModel> rankings = <OnlinePlayerModel>[].obs;

  RxList<CardModel> fourthCard = <CardModel>[].obs;
  Rx<CardModel?> joker = Rx<CardModel?>(null);

  Rx<CardModel?> selectedCard = Rx<CardModel?>(null);
  Rx<CardModel?> openCard = Rx<CardModel?>(null);

  final discardPile = <CardModel>[].obs;

  final Rx<RoomLobbySnapshot> snapshot;
  RoomLobbySnapshot? get room => snapshot.value;
  bool get gameEnded => snapshot.value.gameEnded;
  RxMap roomState = {}.obs;

  List<RoomLobbyPlayer> get players => snapshot.value.players;

  String? get currentPlayerInternalId =>
      roomState['current_player_id'].toString();

  bool get isMyTurn => currentPlayerInternalId == snapshot.value.localPlayerId;

  // 3. Get the phase (must_draw or must_discard)
  String get turnPhase => roomState['turn_phase'] ?? 'waiting';

  // 4. Find the name of the player who is currently active
  String get activePlayerName {
    if (isMyTurn) return 'Your Turn';

    final activePlayer = snapshot.value.players.firstWhereOrNull(
      (p) => p.playerId == currentPlayerInternalId,
    );
    return activePlayer?.displayName ?? 'Waiting...';
  }

  // 5. Action Helper
  String get phaseInstructions {
    if (!isMyTurn) return 'Waiting for $activePlayerName...';
    return turnPhase == 'must_draw' ? 'Draw a card' : 'Discard a card';
  }

  RxBool jokerUnlocked = false.obs;

  @override
  void onInit() {
    super.onInit();
    _service.loadLobby();
    // Listen to Hand
    _service.watchMyHand(roomId, myPlayerId).listen((cards) {
      myHand.assignAll(cards);
      sort();
    });

    _service.watchAllRoomCards(roomId).listen((cards) {
      allCards.assignAll(cards);
    });

    // Listen to Room State (Wild Joker Rank)
    _service.watchTableState(roomId).listen((room) async {
      roomState.value = room;
      log('room state $room');
      if (joker.value == null) {
        joker.value = CardModel(
          id: room['joker_card_id'].toString(),
          suit: Suit.values.firstWhere(
            (e) =>
                e.name ==
                (room['joker_suit']?.toString().toLowerCase() ?? 'joker'),
            orElse: () => Suit.joker,
          ),
          rank: room['joker_rank'],
          zone: room['joker_zone'] ?? 'joker_indicator',
        );
      }

      if (room['open_card_id'] != null) {
        openCard.value = CardModel(
          id: room['open_card_id'].toString(),
          suit: Suit.values.firstWhere(
            (e) =>
                e.name ==
                (room['open_card_suit']?.toString().toLowerCase() ?? ''),
            orElse: () => Suit.joker,
          ),
          rank: int.parse(room['open_card_rank']),
          zone: 'discard_pile',
        );
      } else {
        openCard.value = null;
      }

      if (room['game_status'] == 'finished') {
        rankings.value = await _service.watchRankings(roomId);

        if (rankings.isNotEmpty) {
          Get.to(() => OnlineRankingScreen());
        }
        log('rankings $rankings');
      }
    });

    _service.watchOpenCard(roomId).listen((card) {
      log('watch open card $card');
      openCard.value = card;
    });
  }

  void selectCard({required CardModel card}) {
    selectedCard.value = card;
  }

  Future<void> pickOpenCard({required CardModel card}) async {
    if (!isMyTurn || turnPhase != 'must_draw') {
      Get.snackbar('Notice', 'It is not your turn to draw.');
      return;
    }

    await execute(() async {
      final result = await _service.drawFromOpenCard(roomId: roomId);
      if (result['success'] == true) {
        // The master stream (watchRoomCards) will automatically
        // update 'myHand' because the card zone changed in DB.
        log("Successfully drew card: ${result['card_id']}");
      }
    });
  }

  Future<void> discardCard({required String cardId}) async {
    if (myHand.length < 14 || fourthCard.any((e) => e.id == cardId)) {
      selectedCard.value = null;
      customToast(message: "You can't discard!");
      return;
    }
    await execute(() => _service.discardCard(roomId: roomId, cardId: cardId));
  }

  Future<void> sort() async {
    try {
      myHand.sort((a, b) => a.rank.compareTo(b.rank));
    } catch (e) {
      log('Error Sort Cards $e');
    }
  }

  Future<void> drawFromDeck() async {
    // Basic local check to prevent unnecessary network calls
    if (!isMyTurn || turnPhase != 'must_draw') {
      Get.snackbar('Notice', 'It is not your turn to draw.');
      return;
    }

    await execute(() async {
      final result = await _service.drawFromDeck(roomId: roomId);
      if (result['success'] == true) {
        // The master stream (watchRoomCards) will automatically
        // update 'myHand' because the card zone changed in DB.
        log("Successfully drew card: ${result['card_id']}");
      }
    });
  }

  Future<bool> unlockJoker(List<CardModel> cards) async {
    final List<String> ids = [];

    for (CardModel v in cards) {
      ids.add(v.id);
    }
    log('ids $ids');

    final response = await execute(
      () => _service.unlockJoker(roomId: roomId, cardIds: ids),
    );
    log('4th card resp $response');
    if (response == true) {
      selectedCard.value = null;
      fourthCard.clear();
      fourthCard.value = List.from(cards);
      jokerUnlocked.value = true;
    }
    return response ?? false;
  }

  Future<bool> endGame({required List<List<CardModel>> sets}) async {
    final List<List<int>> setsIds = [];
    for (int i = 0; i < sets.length; i++) {
      final List<int> ids = [];
      for (CardModel v in sets[i]) {
        ids.add(int.parse(v.id));
      }
      setsIds.add(ids);
    }
    log('declare ids $setsIds');
    final response = await execute(
      () => _service.declareEndGame(roomId: roomId, sets: setsIds),
    );
    if (response == true) {
      confettiController.play();
    }
    log('resp $response');
    return false;
  }

  @override
  void dispose() {
    confettiController.stop();
    super.dispose();
  }
}
