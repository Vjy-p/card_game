import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JoinTableController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final codeController = TextEditingController();

  @override
  void onClose() {
    nameController.dispose();
    codeController.dispose();
    super.onClose();
  }

  String get displayName => nameController.text.trim();

  String get roomCode => codeController.text.trim().toUpperCase();
}
