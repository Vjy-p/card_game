import 'package:card_game/features/online/room/domain/entities/room_lobby_snapshot.dart';

class RoomLobbySnapshotDto {
  const RoomLobbySnapshotDto(this.json);

  final Map<String, dynamic> json;

  RoomLobbySnapshot toDomain() {
    final playersJson = json['players'] is List
        ? json['players'] as List
        : const [];

    final players = playersJson
        .whereType<Map>()
        .map(
          (item) => RoomLobbyPlayer(
            playerId: item['player_id']?.toString() ?? '',
            displayName: item['display_name']?.toString() ?? '',
            seatIndex: _int(item['seat_index']),
            isHost: item['is_host'] == true,
            isConnected: item['is_connected'] != false,
            isReady: item['is_ready'] == true,
          ),
        )
        .toList(growable: false);

    final hostPlayerId = json['host_player_id']?.toString() ?? '';

    final hostPlayer = players.cast<RoomLobbyPlayer?>().firstWhere(
      (player) => player!.playerId == hostPlayerId,
      orElse: () => players.isNotEmpty ? players.first : null,
    );

    return RoomLobbySnapshot(
      roomId: json['room_id']?.toString() ?? '',
      roomName: json['room_name']?.toString() ?? '',
      joinCode: json['join_code']?.toString() ?? '',
      status: json['status']?.toString() ?? 'waiting',
      revision: _int(json['revision']),
      maxPlayers: _int(json['max_players'] ?? players.length),
      localPlayerId: json['local_player_id']?.toString() ?? '',
      hostPlayer:
          hostPlayer ??
          const RoomLobbyPlayer(
            playerId: '',
            displayName: '',
            seatIndex: 0,
            isHost: false,
            isConnected: false,
            isReady: false,
          ),
      players: players,
    );
  }

  static int _int(dynamic value) =>
      value is int ? value : int.tryParse('$value') ?? 0;
}
