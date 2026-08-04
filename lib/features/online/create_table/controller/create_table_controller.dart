import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum TableVisibility { publicTable, privateTable }

class CreateTableController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final displayNameController = TextEditingController();
  Rx<FocusNode> displayFocus = FocusNode().obs;
  final tableNameController = TextEditingController();
  Rx<FocusNode> tableFocus = FocusNode().obs;
  Rx<FocusNode> maxPlayersFocus = FocusNode().obs;

  final visibility = TableVisibility.privateTable.obs;

  final maxPlayers = 4.obs;
  List<int> maxPlayersList = [2, 3, 4, 5, 6, 7, 8, 9, 10];

  void changeMaxPlayer(int val) {
    maxPlayers.value = val;
  }

  bool validate() {
    return formKey.currentState?.validate() ?? false;
  }

  void nextFocus({
    required Rx<FocusNode> currentFocus,
    Rx<FocusNode>? nextFocus,
  }) {
    currentFocus.value.unfocus();
    if (nextFocus != null) {
      nextFocus.value.requestFocus();
    }
  }

  @override
  void onClose() {
    displayNameController.dispose();
    tableNameController.dispose();
    displayFocus.value.unfocus();
    tableFocus.value.unfocus();
    maxPlayersFocus.value.unfocus();
    super.onClose();
  }
}
