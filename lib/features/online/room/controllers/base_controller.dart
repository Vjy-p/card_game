import 'dart:developer';

import 'package:card_game/utils/custom_toast.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class BaseController extends GetxController {
  final RxBool isLoading = false.obs;

  final RxnString errorMessage = RxnString();

  final RxBool hasError = false.obs;

  Future<T?> execute<T>(
    Future<T> Function() action, {
    bool showLoading = true,
  }) async {
    try {
      if (showLoading) {
        isLoading.value = true;
      }

      errorMessage.value = null;
      hasError.value = false;

      return await action();
    } catch (e, stackTree) {
      log('error $e, $stackTree');
      hasError.value = true;
      errorMessage.value = e.toString();
      if (e.toString().contains('PostgrestException') == true) {
        final PostgrestException exceptionMessage = e as PostgrestException;
        customToast(message: '${exceptionMessage.message}!');
      } else {
        customToast(message: 'Something went wrong!');
      }
      return null;
    } finally {
      if (showLoading) {
        isLoading.value = false;
      }
    }
  }

  void clearError() {
    hasError.value = false;
    errorMessage.value = null;
  }
}
