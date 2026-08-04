import 'package:card_game/features/online/join_table/application/state/table_password_state.dart';
import 'package:get/get.dart';

class TablePasswordController extends GetxController {
  TablePasswordState tablePasswordState = TablePasswordState();

  void setPassword(String value) {
    tablePasswordState = tablePasswordState.copyWith(
      password: value,
      status: TablePasswordStatus.editing,
      clearError: true,
    );
  }

  Future<void> submit() async {
    if (!tablePasswordState.canSubmit) return;

    tablePasswordState = tablePasswordState.copyWith(
      status: TablePasswordStatus.submitting,
      clearError: true,
    );

    // Password verification and table admission must be performed by the
    // authoritative server. The client never compares or stores room passwords.
    await Future<void>.delayed(const Duration(milliseconds: 350));

    tablePasswordState = tablePasswordState.copyWith(
      status: TablePasswordStatus.success,
    );
  }
}
