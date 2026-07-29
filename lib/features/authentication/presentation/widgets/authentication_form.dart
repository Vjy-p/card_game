import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/core/theme/app_spacing.dart';
import 'package:card_game/features/authentication/application/controllers/authentication_controller.dart';
import 'package:card_game/utils/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthenticationForm extends StatelessWidget {
  const AuthenticationForm({super.key, required this.onGoogleSignIn});
  final Future<void> Function() onGoogleSignIn;

  @override
  Widget build(BuildContext context) {
    final AuthenticationController authenticationController = Get.put(
      AuthenticationController(),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'WELCOME TO THE TABLE',
          style: Theme.of(context).textTheme.labelMedium,
        ),

        const SizedBox(height: AppSpacing.sm),

        Text(
          'Play with friends',
          style: Theme.of(context).textTheme.headlineLarge,
        ),

        const SizedBox(height: AppSpacing.sm),

        Text(
          'Join multiplayer rooms and continue your games anytime.',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
        ),

        const SizedBox(height: AppSpacing.xxl),

        Obx(() {
          return FilledButton.icon(
            onPressed: authenticationController.isLoading.value
                ? null
                : onGoogleSignIn,
            icon: const Icon(Icons.login),
            label: authenticationController.isLoading.value
                ? CustomLoading()
                : Text(
                    authenticationController.isLoading.value
                        ? 'Signing in...'
                        : 'Continue with Google',
                  ),
          );
        }),

        const SizedBox(height: AppSpacing.lg),

        Text(
          'By continuing you agree to the Terms & Privacy Policy.',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
