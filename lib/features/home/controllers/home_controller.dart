import 'package:card_game/features/home/models/home_state.dart';
import 'package:card_game/features/online/room/models/online_table_entities.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final Rxn<HomePrimaryAction> pendingAction = Rxn<HomePrimaryAction>();

  bool get isBusy => pendingAction.value != null;

  RxList<PublicTableSummary> publicTables = <PublicTableSummary>[].obs;

  RxList<RejoinableSession> rejoinableSessions = <RejoinableSession>[].obs;

  // Rxn<PrivateTableInvite> invite;
  // Rxn<RoomLobbySnapshot> lobby;

  RxString error = ''.obs;

  void beginAction(HomePrimaryAction action) {
    if (isBusy) return;
    pendingAction.value = action;
  }

  void completeAction() {
    pendingAction.value = null;
  }

  Future resumeRoom(String id) async {}

  @override
  void dispose() {
    pendingAction.value = null;
    rejoinableSessions.clear();
    error.value = '';
    super.dispose();
  }
}
