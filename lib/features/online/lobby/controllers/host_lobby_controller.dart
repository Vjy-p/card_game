import 'package:card_game/features/online/lobby/models/host_lobby_state.dart';
import 'package:card_game/features/online/room/models/room_lobby_snapshot.dart';
import 'package:get/get.dart';

class HostLobbyController extends GetxController {
  HostLobbyState state = const HostLobbyState();

  void applyServerSnapshot({
    required String roomCode,
    required String shareLink,
    required int maxPlayers,
    required List<RoomLobbyPlayer> players,
  }) {
    state = state.copyWith(
      roomCode: roomCode,
      shareLink: shareLink,
      maxPlayers: maxPlayers,
      players: List.unmodifiable(players),
      status: HostLobbyStatus.waiting,
      clearError: true,
    );
  }

  Future<void> startGame() async {
    if (!state.canStart) return;

    state = state.copyWith(status: HostLobbyStatus.starting, clearError: true);

    // The authoritative start_game command is connected in the backend phase.
    // The host requests a start; only the server can validate membership,
    // readiness, player count, deck count, initial deal, and first turn.
    await Future<void>.delayed(const Duration(milliseconds: 350));
    state = state.copyWith(status: HostLobbyStatus.started);
  }
}
