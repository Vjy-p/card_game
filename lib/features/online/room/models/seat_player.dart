import 'package:card_game/features/online/room/models/room_lobby_snapshot.dart';

enum SeatPosition { bottom, left, top, right }

class SeatPlayer {
  final SeatPosition seat;
  final RoomLobbyPlayer player;

  SeatPlayer({required this.seat, required this.player});
}
