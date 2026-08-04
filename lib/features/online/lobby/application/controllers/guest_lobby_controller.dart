import 'package:card_game/features/online/lobby/application/state/guest_lobby_state.dart';
import 'package:card_game/features/online/room/domain/entities/room_lobby_snapshot.dart';
import 'package:get/get.dart';

class GuestLobbyController extends GetxController {
  GuestLobbyState state = const GuestLobbyState();

  void applyServerSnapshot({
    required String roomCode,
    required int maxPlayers,
    required String currentPlayerId,
    required List<RoomLobbyPlayer> players,
    bool gameStarplaying = false,
  }) {
    state = state.copyWith(
      roomCode: roomCode,
      maxPlayers: maxPlayers,
      currentPlayerId: currentPlayerId,
      players: List.unmodifiable(players),
      status: gameStarplaying
          ? GuestLobbyStatus.gameStarting
          : GuestLobbyStatus.waiting,
      clearError: true,
    );
  }

  Future<void> toggleReady() async {
    final currentPlayer = state.currentPlayer;
    if (currentPlayer == null ||
        state.isUpdatingReady ||
        state.isGameStarting) {
      return;
    }

    state = state.copyWith(
      status: GuestLobbyStatus.updatingReady,
      clearError: true,
    );

    // The authoritative set_ready command is connected in the backend phase.
    // This local replacement represents only the confirmed response boundary.
    await Future<void>.delayed(const Duration(milliseconds: 350));

    final updatedPlayers = state.players
        .map(
          (player) => player.playerId == state.currentPlayerId
              ? RoomLobbyPlayer(
                  playerId: player.playerId,
                  displayName: player.displayName,
                  isHost: player.isHost,
                  isReady: !player.isReady,
                  isConnected: player.isConnected,
                  seatIndex: player.seatIndex,
                )
              : player,
        )
        .toList(growable: false);

    state = state.copyWith(
      players: updatedPlayers,
      status: GuestLobbyStatus.waiting,
    );
  }
}
