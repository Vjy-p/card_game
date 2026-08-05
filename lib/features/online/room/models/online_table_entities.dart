class PublicTableSummary {
  const PublicTableSummary({
    required this.roomId,
    required this.tableName,
    required this.maxPlayers,
    required this.playerCount,
    required this.createdAt,
  });

  final String roomId;
  final String tableName;
  final int maxPlayers;
  final int playerCount;
  final DateTime? createdAt;
}

class PrivateTableInvite {
  const PrivateTableInvite({
    required this.roomId,
    required this.joinCode,
    required this.inviteToken,
  });

  final String roomId;
  final String joinCode;
  final String inviteToken;
}

class RejoinableSession {
  const RejoinableSession({
    required this.roomId,
    required this.tableName,
    required this.status,
    required this.revision,
    required this.seatIndex,
    required this.isHost,
    required this.updatedAt,
  });

  final String roomId;
  final String tableName;
  final String status;
  final int revision;
  final int seatIndex;
  final bool isHost;
  final DateTime? updatedAt;
}
