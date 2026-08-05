import 'dart:async';
import 'dart:developer';

import 'package:card_game/core/router/app_route.dart';
import 'package:card_game/features/online/room/controllers/base_controller.dart';
import 'package:card_game/features/online/room/models/online_table_entities.dart';
import 'package:card_game/features/online/room/models/room_lobby_snapshot.dart';
import 'package:card_game/features/online/room/repositories/supabase_room_repository.dart';
import 'package:get/get.dart';

class RoomController extends BaseController {
  RoomController(this._repository);

  final SupabaseRoomRepository _repository;

  // ----------------------------
  // Lobby
  // ----------------------------

  final snapshot = Rxn<RoomLobbySnapshot>();

  final startedRoomId = RxnString();

  // ----------------------------
  // Tables
  // ----------------------------

  final publicTables = <PublicTableSummary>[].obs;

  final rejoinableSessions = <RejoinableSession>[].obs;

  final privateInvite = Rxn<PrivateTableInvite>();

  StreamSubscription<int>? _revisionSubscription;

  RoomLobbySnapshot? get room => snapshot.value;

  bool get isHost => snapshot.value?.isLocalHost ?? false;

  bool get gameStarted => snapshot.value?.gameStarted ?? false;

  bool get canStart => snapshot.value?.canStart ?? false;

  String get hostName => snapshot.value?.hostPlayer.displayName ?? '';

  List<RoomLobbyPlayer> get players => snapshot.value?.players ?? [];
  String get roomName => room?.roomName ?? '';

  int get playerCount => players.length;

  int get maxPlayers => room?.maxPlayers ?? 4;

  @override
  void onInit() {
    super.onInit();
    log('RoomController init ${identityHashCode(this)}');
  }

  @override
  void onClose() {
    clearData();
    super.onClose();
  }

  //=========================================================
  // CREATE ROOM
  //=========================================================

  Future<void> createTable({
    required String displayName,
    required String tableName,
    required int maxPlayers,
    required String visibility,
  }) async {
    log('create table');

    await execute(() async {
      final result = await _repository.createTable(
        displayName: displayName,
        tableName: tableName,
        maxPlayers: maxPlayers,
        visibility: visibility,
      );

      snapshot.value = result;
      log('create table resp ${snapshot.value?.roomId}');

      _watch(result.roomId);
      AppRoute.hostLobby.go(
        queryParams: {'roomCode': '${snapshot.value?.joinCode}'},
      );
    });
  }

  //=========================================================
  // JOIN ROOM
  //=========================================================

  Future<void> joinRoom({
    required String joinCode,
    required String displayName,
  }) async {
    await execute(() async {
      final result = await _repository.joinRoom(
        joinCode: joinCode,
        displayName: displayName,
      );

      snapshot.value = result;

      _watch(result.roomId);
      AppRoute.guestLobby.go(pathParams: {'roomCode': joinCode});
    });
  }

  //=========================================================
  // MATCHMAKING
  //=========================================================

  Future<void> joinMatchmaking({
    required String displayName,
    int maxPlayers = 4,
  }) async {
    await execute(() async {
      final result = await _repository.joinMatchmaking(
        displayName: displayName,
        maxPlayers: maxPlayers,
      );

      snapshot.value = result;

      _watch(result.roomId);
    });
  }

  //=========================================================
  // PUBLIC TABLE
  //=========================================================

  Future<void> joinPublicTable({
    required String roomId,
    required String displayName,
  }) async {
    await execute(() async {
      final result = await _repository.joinPublicTable(
        roomId: roomId,
        displayName: displayName,
      );

      snapshot.value = result;

      _watch(result.roomId);
    });
  }

  Future<void> loadPublicTables() async {
    await execute(() async {
      publicTables.assignAll(await _repository.listPublicTables());
    });
  }

  //=========================================================
  // PRIVATE INVITE
  //=========================================================

  Future<void> loadPrivateInvite(String roomId) async {
    await execute(() async {
      privateInvite.value = await _repository.getPrivateInvite(roomId: roomId);
    });
  }

  Future<void> joinPrivateInvite({
    required String inviteToken,
    required String displayName,
  }) async {
    await execute(() async {
      final result = await _repository.joinPrivateInvite(
        inviteToken: inviteToken,
        displayName: displayName,
      );

      snapshot.value = result;

      _watch(result.roomId);
    });
  }

  //=========================================================
  // REJOIN
  //=========================================================

  Future<void> discoverSessions() async {
    await execute(() async {
      rejoinableSessions.assignAll(
        await _repository.discoverRejoinableSessions(),
      );
    });
  }

  Future<void> resumeRoom(String roomId) async {
    await execute(() async {
      final result = await _repository.fetchLobby(roomId: roomId);

      snapshot.value = result;

      if (result.status == 'playing') {
        startedRoomId.value = result.roomId;
      }

      _watch(roomId);
    });
  }

  //=========================================================
  // REFRESH
  //=========================================================

  @override
  Future<void> refresh() async {
    final room = snapshot.value;

    if (room == null) return;

    final latest = await _repository.fetchLobby(roomId: room.roomId);

    snapshot.value = latest;

    if (latest.status == 'playing') {
      startedRoomId.value = latest.roomId;
    }
  }

  //=========================================================
  // START GAME
  //=========================================================

  Future<void> startGame() async {
    final room = snapshot.value;

    if (room == null) return;

    if (!room.canStart) return;

    await execute(() async {
      final id = await _repository.startGame(
        roomId: room.roomId,
        expectedRevision: room.revision,
      );

      startedRoomId.value = id;
    });
  }

  //=========================================================
  // LEAVE
  //=========================================================

  Future<void> leaveLobby() async {
    final room = snapshot.value;

    if (room == null) return;

    await execute(() async {
      await _repository.leaveLobby(
        roomId: room.roomId,
        expectedRevision: room.revision,
      );
    });
  }

  //=========================================================
  // WATCH REVISION
  //=========================================================

  void _watch(String roomId) {
    _revisionSubscription?.cancel();

    _revisionSubscription = _repository
        .watchLobbyRevision(roomId: roomId)
        .listen((revision) async {
          final current = snapshot.value;
          if (current != null && revision > current.revision) {
            final snap = await _repository.fetchLobby(roomId: roomId);
            log('Revision changed: $revision $snap');
            snapshot.value = snap;
            if (snap.status == 'playing' && snapshot.value != null) {
              log('11111111');
              AppRoute.gameTable.offAll(
                queryParams: {
                  'roomId': roomId,
                  'localPlayerId': snap.localPlayerId,
                  'snapshotString': snap.toRawJson(),
                },
              );
            }
            refresh();
          }
        });
  }

  // Add this method to RoomController
  Future<void> toggleReady(bool ready) async {
    final currentRoom = snapshot.value;
    if (currentRoom == null) return;

    await execute(() async {
      final result = await _repository.toggleReady(
        roomId: currentRoom.roomId,
        isReady: ready,
      );
      snapshot.value = result;
    });
  }

  // Improve the canStart logic (Add this to your RoomLobbySnapshot entity if not there)
  // Or put it in the controller:
  bool get allPlayersReady {
    final others = players.where((p) => !p.isHost && p.isConnected);
    if (others.isEmpty) {
      return true; // Host alone can start if you allow solo testing
    }
    return others.every((p) => p.isReady);
  }

  void clearData() {
    snapshot.value = null;
    startedRoomId.value = null;
    publicTables.clear();
    rejoinableSessions.clear();
    privateInvite.value = null;
    _revisionSubscription?.cancel();
    log('RoomController close ${identityHashCode(this)}');
  }
}
