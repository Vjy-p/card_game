enum TablePasswordStatus { editing, submitting, success, failure }

class TablePasswordState {
  const TablePasswordState({
    this.password = '',
    this.status = TablePasswordStatus.editing,
    this.errorMessage,
  });

  final String password;
  final TablePasswordStatus status;
  final String? errorMessage;

  bool get isSubmitting => status == TablePasswordStatus.submitting;
  bool get canSubmit => password.isNotEmpty && !isSubmitting;

  TablePasswordState copyWith({
    String? password,
    TablePasswordStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return TablePasswordState(
      password: password ?? this.password,
      status: status ?? this.status,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
