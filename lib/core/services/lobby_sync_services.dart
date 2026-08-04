import 'dart:async';

import 'package:card_game/features/online/room/data/repositories/supabase_room_repository.dart';

class LobbySyncService {
  LobbySyncService(this._repository);

  final SupabaseRoomRepository _repository;

  StreamSubscription<int>? _subscription;

  void start({
    required String roomId,
    required int currentRevision,
    required Future<void> Function() onRevisionChanged,
  }) {
    stop();

    _subscription = _repository.watchLobbyRevision(roomId: roomId).listen((
      revision,
    ) {
      if (revision > currentRevision) {
        onRevisionChanged();
      }
    });
  }

  void stop() {
    _subscription?.cancel();
    _subscription = null;
  }

  void dispose() {
    stop();
  }
}
