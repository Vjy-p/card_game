enum JoinTableStatus {
  idle,
  submitting,
  success,
  failure,
}

class JoinTableState {
  const JoinTableState({
    this.roomCode = '',
    this.status = JoinTableStatus.idle,
    this.requiresPassword = false,
    this.errorMessage,
  });

  final String roomCode;
  final JoinTableStatus status;
  final bool requiresPassword;
  final String? errorMessage;

  String get normalizedRoomCode =>
      roomCode.replaceAll(RegExp(r'\\s+'), '').toUpperCase();

  bool get canSubmit => normalizedRoomCode.length >= 6;

  JoinTableState copyWith({
    String? roomCode,
    JoinTableStatus? status,
    bool? requiresPassword,
    String? errorMessage,
    bool clearError = false,
  }) {
    return JoinTableState(
      roomCode: roomCode ?? this.roomCode,
      status: status ?? this.status,
      requiresPassword: requiresPassword ?? this.requiresPassword,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
