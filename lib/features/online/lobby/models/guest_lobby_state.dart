import 'package:card_game/features/online/room/models/room_lobby_snapshot.dart';

enum GuestLobbyStatus { waiting, updatingReady, gameStarting, failure }

class GuestLobbyState {
  const GuestLobbyState({
    this.roomCode = 'ROOM1234',
    this.maxPlayers = 4,
    this.currentPlayerId = 'guest-current',
    this.players = const [
      RoomLobbyPlayer(
        playerId: 'host',
        displayName: 'Host',
        isHost: true,
        isReady: true,
        isConnected: true,
        seatIndex: -1,
      ),
      RoomLobbyPlayer(
        playerId: 'guest-current',
        displayName: 'You',
        isHost: false,
        isReady: false,
        isConnected: true,
        seatIndex: -1,
      ),
    ],
    this.status = GuestLobbyStatus.waiting,
    this.errorMessage,
  });

  final String roomCode;
  final int maxPlayers;
  final String currentPlayerId;
  final List<RoomLobbyPlayer> players;
  final GuestLobbyStatus status;
  final String? errorMessage;

  int get joinedCount => players.length;
  bool get isUpdatingReady => status == GuestLobbyStatus.updatingReady;
  bool get isGameStarting => status == GuestLobbyStatus.gameStarting;

  RoomLobbyPlayer? get currentPlayer {
    for (final player in players) {
      if (player.playerId == currentPlayerId) return player;
    }
    return null;
  }

  bool get isReady => currentPlayer?.isReady ?? false;

  GuestLobbyState copyWith({
    String? roomCode,
    int? maxPlayers,
    String? currentPlayerId,
    List<RoomLobbyPlayer>? players,
    GuestLobbyStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return GuestLobbyState(
      roomCode: roomCode ?? this.roomCode,
      maxPlayers: maxPlayers ?? this.maxPlayers,
      currentPlayerId: currentPlayerId ?? this.currentPlayerId,
      players: players ?? this.players,
      status: status ?? this.status,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
