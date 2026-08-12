import 'package:card_game/features/authentication/controllers/authentication_controller.dart';
import 'package:card_game/utils/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget getGoogleSignInButton({Future<void> Function()? onPressed}) {
  return GoogleSignInMobileButton(onPressed: onPressed!);
}

class GoogleSignInMobileButton extends StatelessWidget {
  const GoogleSignInMobileButton({super.key, required this.onPressed});

  final Future<void> Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final AuthenticationController controller = Get.put(
      AuthenticationController(),
    );
    // final controller = Get.find<AuthenticationController>();

    return Obx(() {
      final isLoading = controller.isLoading.value;

      return FilledButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: const Icon(Icons.login),
        label: isLoading
            ? const CustomLoading()
            : const Text('Continue with Google'),
      );
    });
  }
}
