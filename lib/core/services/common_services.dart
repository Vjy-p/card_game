import 'dart:developer';

import 'package:get_storage/get_storage.dart';

class CommonServices {
  static GetStorage box = GetStorage();

  static Future<void> setUser({
    required String userName,
    required String userId,
    required String email,
  }) async {
    await box.write('userName', userName);
    await box.write('userId', userId);
    await box.write('email', email);
    log('set user');
  }

  static String getUserName() {
    final String userName = box.read('userName') ?? '';

    log('get user $userName');
    return userName;
  }

  // static String get userName => box.read('userName') ?? '';

  static String getUserId() {
    final String userId = box.read('userId') ?? '';

    log('get user id $userId');
    return userId;
  }

  static String getEmail() {
    final String email = box.read('email') ?? '';

    log('get user email $email');
    return email;
  }

  static Future<void> clearData() async {
    await box.erase();
    log('user clear data');
  }
}
