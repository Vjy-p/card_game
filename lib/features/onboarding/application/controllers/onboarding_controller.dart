import 'dart:async';

import 'package:card_game/core/router/app_route.dart';
import 'package:card_game/features/onboarding/domain/entities/onboarding_page_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  // State variables
  final pageIndex = 0.obs;
  final int pageCount = 4;

  late PageController pageController;
  Timer? _autoScrollTimer;

  bool get isFirstPage => pageIndex.value == 0;
  bool get isLastPage => pageIndex.value == pageCount - 1;

  final pages = [
    OnboardingPageContent(
      eyebrow: 'THE CORE RULE',
      title: 'Match the rank. Suits do not decide the set.',
      description:
          '8♠, 8♥, 8♦ is valid because all three cards share the same rank. The real suits and colors stay visible for easy card reading.',
      visualType: OnboardingVisualType.rankMatch,
    ),
    OnboardingPageContent(
      eyebrow: 'MULTIPLE DECKS',
      title: 'Identical-looking cards can exist together.',
      description:
          '8♠, 8♠, 8♥ is also valid. Multiple physical decks create duplicate-looking cards, while every card remains uniquely tracked by the game.',
      visualType: OnboardingVisualType.duplicateCards,
    ),
    OnboardingPageContent(
      eyebrow: 'UNLOCK THE JOKER',
      title: 'Reveal four matching ranks to discover your joker.',
      description:
          'Reveal a natural four-of-a-kind to unlock the hidden joker for yourself. Other players still cannot see the joker until they unlock it too.',
      visualType: OnboardingVisualType.jokerUnlock,
    ),
    OnboardingPageContent(
      eyebrow: 'HOW TO WIN',
      title: 'Organize 13 cards into 3 + 3 + 3 + 4.',
      description:
          'Build three 3-card groups and one natural 4-card group. After drawing, one remaining card becomes your closing card when you declare.',
      visualType: OnboardingVisualType.winningHand,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
    startAutoScroll();
  }

  void startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (pageIndex.value < pageCount - 1) {
        nextPage();
      } else {
        stopAutoScroll();
      }
    });
  }

  void stopAutoScroll() {
    _autoScrollTimer?.cancel();
  }

  void setPage(int index) {
    pageIndex.value = index;
  }

  void nextPage() {
    if (!isLastPage) {
      pageController.animateToPage(
        pageIndex.value + 1,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void previousPage() {
    if (!isFirstPage) {
      pageController.animateToPage(
        pageIndex.value - 1,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void finish() {
    stopAutoScroll();
    Get.offAllNamed(AppRoute.authentication.path);
  }

  @override
  void onClose() {
    _autoScrollTimer?.cancel();
    pageController.dispose();
    super.onClose();
  }
}
