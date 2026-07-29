
class OnboardingPageContent {
  const OnboardingPageContent({
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.visualType,
  });

  final String eyebrow;
  final String title;
  final String description;
  final OnboardingVisualType visualType;
}

enum OnboardingVisualType { rankMatch, duplicateCards, jokerUnlock, winningHand }
