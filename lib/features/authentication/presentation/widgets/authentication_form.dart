import 'package:card_game/core/router/app_route.dart';
import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/core/theme/app_spacing.dart';
import 'package:card_game/features/authentication/presentation/widgets/google_sign_in_button.dart'
    if (dart.library.js_interop) 'google_sign_in_web_button.dart'
    if (dart.library.io) 'google_sign_in_mobile_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AuthenticationForm extends StatelessWidget {
  const AuthenticationForm({super.key, required this.onGoogleSignIn});
  final Future<void> Function() onGoogleSignIn;

  @override
  Widget build(BuildContext context) {
    // final AuthenticationController authenticationController = Get.put(
    //   AuthenticationController(),
    // );
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

        getGoogleSignInButton(onPressed: onGoogleSignIn),

        const SizedBox(height: AppSpacing.lg),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: 'By continuing you agree to the ',
            style: TextStyle(color: AppColors.textMuted),
            children: [
              TextSpan(
                text: 'Terms',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    AppRoute.terms.go();
                  },
              ),
              TextSpan(
                text: ' & ',
                style: TextStyle(color: AppColors.textMuted),
              ),
              TextSpan(
                text: 'Privacy Policy.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    AppRoute.privacy.go();
                  },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
