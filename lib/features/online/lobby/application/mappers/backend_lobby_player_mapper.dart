import 'package:card_game/features/online/room/domain/entities/room_lobby_snapshot.dart';

extension BackendLobbyPlayerMapper on RoomLobbyPlayer {
  RoomLobbyPlayer toLobbyPlayer() {
    return RoomLobbyPlayer(
      playerId: playerId,
      displayName: displayName,
      isHost: isHost,
      isReady: isConnected,
      isConnected: isConnected,
      seatIndex: seatIndex,
    );
  }
}
