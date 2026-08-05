import 'dart:convert';

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

  factory RoomLobbyPlayer.fromJson(Map<String, dynamic> json) {
    return RoomLobbyPlayer(
      playerId: json['playerId'],
      displayName: json['displayName'],
      seatIndex: json['seatIndex'],
      isHost: json['isHost'],
      isConnected: json['isConnected'],
      isReady: json['isReady'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'playerId': playerId,
      'displayName': displayName,
      'seatIndex': seatIndex,
      'isHost': isHost,
      'isConnected': isConnected,
      'isReady': isReady,
    };
  }
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

  factory RoomLobbySnapshot.fromJson(Map<String, dynamic> json) {
    return RoomLobbySnapshot(
      roomId: json['roomId'],
      roomName: json['roomName'],
      joinCode: json['joinCode'],
      status: json['status'],
      revision: json['revision'],
      players: (json['players'] as List)
          .map((e) => RoomLobbyPlayer.fromJson(e))
          .toList(),
      localPlayerId: json['localPlayerId'],
      hostPlayer: RoomLobbyPlayer.fromJson(json['hostPlayer']),
      maxPlayers: json['maxPlayers'],
      isLoading: json['isLoading'] ?? false,
      errorMessage: json['errorMessage'],
      startedRoomId: json['startedRoomId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'roomName': roomName,
      'joinCode': joinCode,
      'status': status,
      'revision': revision,
      'players': players.map((e) => e.toJson()).toList(),
      'localPlayerId': localPlayerId,
      'hostPlayer': hostPlayer.toJson(),
      'maxPlayers': maxPlayers,
      'isLoading': isLoading,
      'errorMessage': errorMessage,
      'startedRoomId': startedRoomId,
    };
  }

  String toRawJson() => jsonEncode(toJson());

  factory RoomLobbySnapshot.fromRawJson(String source) =>
      RoomLobbySnapshot.fromJson(jsonDecode(source));
}
