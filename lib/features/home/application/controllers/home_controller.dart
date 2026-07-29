import 'package:card_game/features/home/application/state/home_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeControllerProvider = NotifierProvider<HomeController, HomeState>(HomeController.new);

class HomeController extends Notifier<HomeState> {
  @override
  HomeState build() => const HomeState();

  void beginAction(HomePrimaryAction action) {
    if (state.isBusy) return;
    state = state.copyWith(pendingAction: action);
  }

  void completeAction() {
    state = state.copyWith(clearPendingAction: true);
  }
}
