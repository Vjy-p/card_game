import 'package:card_game/features/online/room/models/room_lobby_snapshot.dart';

enum HostLobbyStatus { waiting, starting, started, failure }

class HostLobbyState {
  const HostLobbyState({
    this.roomCode = 'ROOM1234',
    this.shareLink = 'https://example.invalid/table/ROOM1234',
    this.maxPlayers = 4,
    this.players = const [
      RoomLobbyPlayer(
        playerId: 'host',
        displayName: 'You',
        isHost: true,
        isReady: true,
        isConnected: true,
        seatIndex: 0,
      ),
    ],
    this.status = HostLobbyStatus.waiting,
    this.errorMessage,
  });

  final String roomCode;
  final String shareLink;
  final int maxPlayers;
  final List<RoomLobbyPlayer> players;
  final HostLobbyStatus status;
  final String? errorMessage;

  bool get isStarting => status == HostLobbyStatus.starting;
  int get joinedCount => players.length;
  int get guestCount => players.where((player) => !player.isHost).length;

  bool get canStart {
    if (isStarting || joinedCount < 2 || joinedCount > maxPlayers) return false;
    return players.every(
      (player) => player.isConnected && (player.isHost || player.isReady),
    );
  }

  HostLobbyState copyWith({
    String? roomCode,
    String? shareLink,
    int? maxPlayers,
    List<RoomLobbyPlayer>? players,
    HostLobbyStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return HostLobbyState(
      roomCode: roomCode ?? this.roomCode,
      shareLink: shareLink ?? this.shareLink,
      maxPlayers: maxPlayers ?? this.maxPlayers,
      players: players ?? this.players,
      status: status ?? this.status,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
