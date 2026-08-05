import 'package:card_game/core/theme/app_spacing.dart';
import 'package:card_game/features/authentication/controllers/authentication_controller.dart';
import 'package:card_game/features/authentication/presentation/widgets/authentication_brand_panel.dart';
import 'package:card_game/features/authentication/presentation/widgets/authentication_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthenticationController>(
      init: AuthenticationController(),
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth >= 840;

                return Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1080),
                      child: wide
                          ? Row(
                              children: [
                                const Expanded(
                                  child: AuthenticationBrandPanel(),
                                ),
                                const SizedBox(width: AppSpacing.xxl),
                                Expanded(
                                  child: AuthenticationForm(
                                    onGoogleSignIn: controller.signInWithGoogle,
                                  ),
                                ),
                              ],
                            )
                          : ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 520),
                              child: AuthenticationForm(
                                onGoogleSignIn: controller.signInWithGoogle,
                              ),
                            ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
