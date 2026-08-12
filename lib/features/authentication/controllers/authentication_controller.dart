import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:card_game/core/router/app_route.dart';
import 'package:card_game/core/services/common_services.dart';
import 'package:card_game/utils/custom_toast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthenticationController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isButtonLoading = false.obs;

  final SupabaseClient _supabase = Supabase.instance.client;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  StreamSubscription<GoogleSignInAuthenticationEvent>? googleAuthSubscription;

  @override
  void onInit() {
    super.onInit();

    if (kIsWeb) {
      initializeGoogleWebListener();
    }
  }

  @override
  void onClose() {
    googleAuthSubscription?.cancel();
    super.onClose();
  }

  Future<void> initializeGoogleWebListener() async {
    log('initial');
    try {
      googleAuthSubscription = _googleSignIn.authenticationEvents.listen(
        (GoogleSignInAuthenticationEvent event) async {
          log('event $event');
          if (event is GoogleSignInAuthenticationEventSignIn) {
            await signInWithGoogleWeb(event.user);
          } else if (event is GoogleSignInAuthenticationEventSignOut) {
            log('Google Web user signed out');
          }
        },
        onError: (Object error, StackTrace stackTrace) {
          log(
            'Google Web authentication error: $error',
            stackTrace: stackTrace,
          );

          isLoading.value = false;
        },
      );
      update();
    } catch (e, satckTree) {
      log('error $e $satckTree');
    }
  }

  Future signInWithGoogleWeb(GoogleSignInAccount googleUser) async {
    try {
      log('sign in web ${googleUser.email}');
      isLoading.value = true;

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      log('auth 1 ${googleUser.email} $googleAuth');

      final String? idToken = googleAuth.idToken;

      if (idToken == null || idToken.isEmpty) {
        throw Exception('Google Web ID token is null or empty');
      }

      log('Google Web ID token received');

      final AuthResponse response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
      );

      final User? user = response.user;

      if (user == null) {
        throw Exception('Supabase user is null after Google sign-in');
      }

      log(
        'Supabase Web user: '
        '${user.id} ${user.email}',
      );

      await createProfile(
        displayName: googleUser.displayName ?? '',
        email: googleUser.email,
        photoUrl: googleUser.photoUrl,
      );

      CommonServices.setUser(
        userName: googleUser.displayName ?? '',
        userId: user.id,
        email: googleUser.email,
      );

      AppRoute.home.offAll();
      isLoading.value = false;

      await FirebaseMessaging.instance.subscribeToTopic(
        _supabase.auth.currentUser!.id,
      );
      isLoading.value = false;
    } catch (e, stackTree) {
      log('google signin Error -> $e $stackTree');
      isLoading.value = false;
    }
  }

  Future signInWithGoogleMobile() async {
    try {
      isLoading.value = true;

      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
      log('auth 1 ${googleUser.email} ${googleUser.authentication}');

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // log("google id  ${googleAuth.idToken ?? 'No Google ID token'}");

      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken ?? '',
      );

      log('auth response ${response.user?.email} ${response.session}');

      await createProfile(
        displayName: googleUser.displayName ?? '',
        email: googleUser.email,
        photoUrl: googleUser.photoUrl,
      );

      final user = _supabase.auth.currentUser;
      log('auth user $user');

      CommonServices.setUser(
        userName: googleUser.displayName ?? '',
        // userId: googleUser.id,
        userId: _supabase.auth.currentUser!.id,
        email: googleUser.email,
      );

      AppRoute.home.offAll();
      isLoading.value = false;

      await FirebaseMessaging.instance.subscribeToTopic(
        _supabase.auth.currentUser!.id,
      );
      isLoading.value = false;
    } catch (e, stackTree) {
      log('google signin Error -> $e $stackTree');
      isLoading.value = false;
    }
  }

  Future<void> createProfile({
    required String displayName,
    required String email,
    String? photoUrl,
  }) async {
    final response = await _supabase.rpc(
      'get_or_create_profile',
      params: {
        'p_display_name': displayName,
        'p_email': email,
        'p_photo_url': photoUrl,
      },
    );

    log('profile response: $response');
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
