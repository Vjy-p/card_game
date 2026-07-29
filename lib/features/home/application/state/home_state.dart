enum HomePrimaryAction { playOnline, createPrivateTable, joinTable, playOffline }

class HomeState {
  const HomeState({this.pendingAction});

  final HomePrimaryAction? pendingAction;

  bool get isBusy => pendingAction != null;

  HomeState copyWith({HomePrimaryAction? pendingAction, bool clearPendingAction = false}) {
    return HomeState(pendingAction: clearPendingAction ? null : pendingAction ?? this.pendingAction);
  }
}
