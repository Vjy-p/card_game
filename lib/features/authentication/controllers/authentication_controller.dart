import 'dart:convert';
import 'dart:developer';

import 'package:card_game/core/router/app_route.dart';
import 'package:card_game/core/services/common_services.dart';
import 'package:card_game/utils/custom_toast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthenticationController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isButtonLoading = false.obs;

  final SupabaseClient _supabase = Supabase.instance.client;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  Future signInWithGoogle() async {
    try {
      isLoading.value = true;

      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
      log('auth 1 ${googleUser.email} ${googleUser.authentication}');

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // log("google id  ${googleAuth.idToken ?? 'No Google ID token'}");

      final response = await Supabase.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken ?? '',
      );

      log('auth response $response ${response.session}');

      final user = Supabase.instance.client.auth.currentUser;
      log('auth user $user');

      final resp = await _supabase.rpc(
        'get_or_create_profile',
        params: {
          'p_display_name': googleUser.displayName ?? '',
          'p_email': googleUser.email,
          'p_photo_url': googleUser.photoUrl,
        },
      );
      log('supabase resp $resp');

      CommonServices.setUser(
        userName: googleUser.displayName ?? '',
        userId: googleUser.id,
        email: googleUser.email,
      );

      AppRoute.home.offAll();
      isLoading.value = false;

      await FirebaseMessaging.instance.subscribeToTopic(
        Supabase.instance.client.auth.currentUser!.id,
      );
      isLoading.value = false;
    } catch (e, stackTree) {
      log('google signin Error -> $e $stackTree');
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      isButtonLoading.value = true;
      await _googleSignIn.signOut();
      await _supabase.auth.signOut();
      CommonServices.clearData();
      AppRoute.splash.offAll();
    } catch (e) {
      log('error log out user account ${e.toString()}');
      customToast(message: 'Something went wrong!');
      isButtonLoading.value = false;
    }
  }

  Future<void> deleteAccount() async {
    try {
      isButtonLoading.value = true;

      final FunctionResponse response = await _supabase.functions.invoke(
        'delete-account',
      );
      log('delete ${response.data}');

      final Map body = jsonDecode(response.data);

      if (body['success'] == true) {
        final userId = _supabase.auth.currentUser?.id;

        await _googleSignIn.signOut();
        await _supabase.auth.signOut();

        CommonServices.clearData();

        isButtonLoading.value = false;
        AppRoute.splash.offAll();
        if (userId != null) {
          await FirebaseMessaging.instance.unsubscribeFromTopic(userId);
        }
      } else {
        customToast(message: body['message'] ?? 'Failed to delete account');
        isButtonLoading.value = false;
      }
    } catch (e) {
      log('error delete user account ${e.toString()}');
      customToast(message: 'Something went wrong!');
      isButtonLoading.value = false;
    }
  }
}
