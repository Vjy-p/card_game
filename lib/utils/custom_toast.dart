import 'package:card_game/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<void> customToast({
  required String message,
  Color? bgColor,
  Color? textColor,
  Widget? icon,
  int? durationInSeconds,
}) async {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    textColor: AppColors.textPrimary,
    backgroundColor: AppColors.surfaceElevated,
    fontSize: 14,
  );
}
