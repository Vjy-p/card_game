import 'dart:io';

import 'package:card_game/core/theme/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

Future<void> customToast({
  required String message,
  Color? bgColor,
  Color? textColor,
  Widget? icon,
  int? durationInSeconds,
}) async {
  if (Get.testMode || (!kIsWeb && Platform.environment.containsKey('FLUTTER_TEST'))) {
    return;
  }
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: durationInSeconds ?? 3,
    textColor: AppColors.textPrimary,
    backgroundColor: AppColors.surfaceElevated,
    fontSize: 14,
  );
}
