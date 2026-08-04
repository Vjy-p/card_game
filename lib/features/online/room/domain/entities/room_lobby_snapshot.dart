class RoomLobbyPlayer {
  const RoomLobbyPlayer({
    required this.playerId,
    required this.displayName,
    required this.seatIndex,
    required this.isHost,
    required this.isConnected,
    required this.isReady,
  });

  final String playerId;
  final String displayName;
  final int seatIndex;
  final bool isHost;
  final bool isReady;
  final bool isConnected;
}

class RoomLobbySnapshot {
  const RoomLobbySnapshot({
    required this.roomId,
    required this.roomName,
    required this.joinCode,
    required this.status,
    required this.revision,
    required this.players,
    required this.localPlayerId,
    required this.hostPlayer,
    required this.maxPlayers,
    this.isLoading = false,
    this.errorMessage,
    this.startedRoomId,
  });

  final String roomId;
  final String roomName;
  final String joinCode;
  final String status;
  final int revision;
  final List<RoomLobbyPlayer> players;
  final String localPlayerId;
  final RoomLobbyPlayer hostPlayer;
  final bool isLoading;
  final String? errorMessage;
  final String? startedRoomId;
  final int maxPlayers;

  bool get isLocalHost => localPlayerId == hostPlayer.playerId;
  bool get canStart =>
      isLocalHost && status == 'waiting' && players.length >= 2;
  bool get gameStarted => status == 'playing' && players.length >= 2;
  bool get gameEnded =>
      (status == 'end' || status == 'finished') && players.length >= 2;
}
