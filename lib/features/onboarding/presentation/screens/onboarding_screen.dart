import 'package:card_game/core/responsive/responsive_value.dart';
import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/core/theme/app_spacing.dart';
import 'package:card_game/features/onboarding/controllers/onboarding_controller.dart';
import 'package:card_game/features/onboarding/presentation/widgets/onboarding_page.dart';
import 'package:card_game/features/onboarding/presentation/widgets/onboarding_progress.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject Controller
    final controller = Get.put(OnboardingController());

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = responsiveValue<double>(
              width: constraints.maxWidth,
              smallPhone: 16,
              phone: 24,
              largePhone: 32,
              tablet: 48,
              desktop: 64,
            );

            final maxContentWidth = constraints.maxWidth >= 840
                ? 1040.0
                : 640.0;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxContentWidth),
                child: Column(
                  children: [
                    // Header Area
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: AppSpacing.sm,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'HOW TO PLAY',
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: controller.finish,
                            child: const Text('Skip'),
                          ),
                        ],
                      ),
                    ),

                    // Main Content (PageView)
                    Expanded(
                      child: PageView.builder(
                        controller: controller.pageController,
                        itemCount: controller.pageCount,
                        onPageChanged: controller.setPage,
                        itemBuilder: (context, index) => OnboardingPage(
                          content: controller.pages[index],
                          horizontalPadding: horizontalPadding,
                        ),
                      ),
                    ),

                    // Bottom Navigation Area
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        AppSpacing.sm,
                        horizontalPadding,
                        AppSpacing.lg,
                      ),
                      child: Column(
                        children: [
                          // Reactive Progress Bar
                          Obx(
                            () => OnboardingProgress(
                              currentIndex: controller.pageIndex.value,
                              count: controller.pageCount,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),

                          // Navigation Buttons
                          Obx(
                            () => Row(
                              children: [
                                if (!controller.isFirstPage)
                                  IconButton(
                                    tooltip: 'Previous step',
                                    onPressed: controller.previousPage,
                                    icon: const Icon(Icons.arrow_back_rounded),
                                  )
                                else
                                  const SizedBox(width: 48),
                                const Spacer(),
                                FilledButton.icon(
                                  onPressed: controller.isLastPage
                                      ? controller.finish
                                      : controller.nextPage,
                                  icon: Icon(
                                    controller.isLastPage
                                        ? Icons.play_arrow_rounded
                                        : Icons.arrow_forward_rounded,
                                  ),
                                  label: Text(
                                    controller.isLastPage
                                        ? 'Get Started'
                                        : 'Next',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
