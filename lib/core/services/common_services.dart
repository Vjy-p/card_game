import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class CommonServices {
  static GetStorage box = GetStorage();
  static final Map<String, dynamic> _mockStorage = <String, dynamic>{};

  static void setMockStorage([Map<String, dynamic>? initialValues]) {
    _mockStorage.clear();
    if (initialValues != null) {
      _mockStorage.addAll(initialValues);
    }
  }

  static dynamic _read(String key) {
    if (Get.testMode) {
      return _mockStorage[key];
    }
    return box.read(key);
  }

  static Future<void> _write(String key, dynamic value) async {
    if (Get.testMode) {
      _mockStorage[key] = value;
      return;
    }
    await box.write(key, value);
  }

  static Future<void> setUser({
    required String userName,
    required String userId,
    required String email,
  }) async {
    await _write('userName', userName);
    await _write('userId', userId);
    await _write('email', email);
    log('set user');
  }

  static String getUserName() {
    final String userName = _read('userName') ?? '';

    log('get user $userName');
    return userName;
  }

  // static String get userName => box.read('userName') ?? '';

  static String getUserId() {
    final String userId = _read('userId') ?? '';

    log('get user id $userId');
    return userId;
  }

  static String getEmail() {
    final String email = _read('email') ?? '';

    log('get user email $email');
    return email;
  }

  static Future<void> clearData() async {
    if (Get.testMode) {
      _mockStorage.clear();
      return;
    }
    await box.erase();
    log('user clear data');
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }

  Future<void> launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'card.game.support@gmail.com',
      query: encodeQueryParameters(<String, String>{
        'subject': 'Card Game - Account Deletion Request',
        'body':
            'Hello,\n\nI request deletion of my Card Game account and associated data.\n\nAccount email: ',
      }),
    );
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    }
  }
}
