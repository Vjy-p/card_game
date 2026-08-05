import 'dart:developer';

import 'package:card_game/features/profile/models/user_model.dart';
import 'package:card_game/utils/custom_toast.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileController extends GetxController {
  bool isLoading = false;
  bool error = false;

  final user = Supabase.instance.client.auth.currentUser;

  UserModel? userDetails;

  @override
  void onInit() {
    getUserDetails();
    super.onInit();
  }

  Future getUserDetails() async {
    try {
      log('user id ${user?.id}');
      isLoading = true;
      error = false;
      update();
      final profile = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', user!.id)
          .maybeSingle();

      if (profile != null) {
        userDetails = UserModel.fromJson(profile);
        isLoading = false;
        error = false;
        update();
      } else {
        isLoading = false;
        error = true;
        update();
      }

      log('profile ${userDetails?.gamesPlayed}');
    } on PostgrestException catch (e, stackTree) {
      log('error profile $e $stackTree');
      customToast(message: e.message);
      isLoading = false;
      error = true;
      update();
    }
  }
}
