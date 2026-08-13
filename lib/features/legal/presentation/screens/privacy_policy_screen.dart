import 'package:card_game/core/router/app_route.dart';
import 'package:card_game/core/theme/app_spacing.dart';
import 'package:card_game/features/legal/models/legal_content_model.dart';
import 'package:card_game/features/legal/presentation/widgets/legal_footer.dart';
import 'package:card_game/features/legal/presentation/widgets/legal_header.dart';
import 'package:card_game/features/legal/presentation/widgets/legal_section.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  static const List<LegalContentModel> privacyPolicyContent = [
    LegalContentModel(
      title: '1. Information We Collect',
      content:
          'Depending on how you use Card Game, we may collect or process information such as your user ID, display name, authentication-related information, gameplay information, game results, scores, rankings, and technical information required to operate the application.',
    ),

    LegalContentModel(
      title: '2. Account Information',
      content:
          'Card Game may use anonymous authentication or other authentication methods. Depending on the features you use, we may process information such as your user ID, display name, and account-related information.',
    ),

    LegalContentModel(
      title: '3. Game Information',
      content:
          'When you use online multiplayer features, we may process information required to operate the game, including room IDs, player IDs, player names, game state, scores, rankings, match results, and related session information.',
    ),

    LegalContentModel(
      title: '4. Device and Technical Information',
      content:
          'We or our service providers may automatically process technical information such as device type, operating system, application version, IP address, network information, crash information, performance information, and diagnostic information.',
    ),

    LegalContentModel(
      title: '5. How We Use Information',
      content:
          'We use information to provide and maintain gameplay functionality, enable multiplayer games, manage game rooms, maintain game state, display player information, prevent cheating and abuse, diagnose technical issues, improve performance, understand app usage, display advertisements, provide support, maintain security, and comply with applicable laws.',
    ),

    LegalContentModel(
      title: '6. Supabase and Backend Services',
      content:
          'Card Game may use Supabase or other cloud infrastructure for authentication, databases, multiplayer functionality, game rooms, game state, player information, and game results. Information processed by these services is used to provide and maintain the functionality of the application.',
    ),

    LegalContentModel(
      title: '7. Advertising',
      content:
          'Card Game may display advertisements through third-party advertising services such as Google AdMob. Advertising providers may process device identifiers, advertising identifiers, approximate location, and interaction information depending on your device settings, consent choices, applicable laws, and the provider’s policies.',
    ),

    LegalContentModel(
      title: '8. Analytics',
      content:
          'We may use analytics and diagnostic services to understand how users interact with Card Game and to improve stability and performance. This may include information about app launches, screens or features used, sessions, device information, performance, crashes, and general usage patterns.',
    ),

    LegalContentModel(
      title: '9. Data Sharing',
      content:
          'We may allow trusted service providers to process information necessary to operate Card Game. These providers may include cloud hosting, authentication, analytics, advertising, security, crash reporting, and infrastructure providers. We do not sell your personal information as a standalone product.',
    ),

    LegalContentModel(
      title: '10. Data Retention',
      content:
          'We retain information for as long as reasonably necessary to provide the application, maintain game functionality, comply with legal obligations, resolve disputes, enforce agreements, and protect our legitimate interests.',
    ),

    LegalContentModel(
      title: '11. Data Security',
      content:
          'We take reasonable technical and organizational measures to protect information against unauthorized access, alteration, disclosure, or destruction. However, no internet transmission or electronic storage system can be guaranteed to be completely secure.',
    ),

    LegalContentModel(
      title: '12. Children’s Privacy',
      content:
          'Card Game is not intended to knowingly collect personal information from children in violation of applicable laws. If you believe that a child has provided personal information to us inappropriately, please contact us so that we can review the situation and take appropriate action.',
    ),

    LegalContentModel(
      title: '13. Your Privacy Rights',
      content:
          'Depending on your location and applicable law, you may have rights regarding your personal information, including requesting access, correction, deletion, restriction of processing, objection to certain processing, or withdrawal of consent where applicable.',
    ),

    LegalContentModel(
      title: '14. Account and Data Deletion',
      content:
          'If Card Game provides an account deletion feature, you may request deletion of your account and associated information through the available in-app functionality. You may also contact us directly to request account deletion. Certain information may need to be retained where required by law or for legitimate security and fraud-prevention purposes.',
    ),

    LegalContentModel(
      title: '15. Third-Party Services',
      content:
          'Card Game may use third-party services and may display third-party advertisements. We are not responsible for the privacy practices, content, or security of third-party websites or services. We encourage you to review the privacy policies of those services.',
    ),

    LegalContentModel(
      title: '16. International Data Processing',
      content:
          'Depending on the service providers we use, information may be processed or stored in countries other than the country where you live. Where required by applicable law, appropriate safeguards will be used for international data transfers.',
    ),

    LegalContentModel(
      title: '17. Changes to This Privacy Policy',
      content:
          'We may update this Privacy Policy from time to time. When changes are made, we will update the Last Updated date displayed on this page. We encourage you to periodically review this Privacy Policy.',
    ),

    LegalContentModel(
      title: '18. Contact Us',
      content:
          'If you have questions about this Privacy Policy or want to exercise applicable privacy rights, please contact us at: YOUR_SUPPORT_EMAIL',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        AppRoute.home.smartBack();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: false,
          leading: IconButton(
            onPressed: () => AppRoute.home.smartBack(),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          title: const Text(
            'Privacy Policy',
            // style: TextStyle(
            //   color: Colors.white,
            //   fontSize: 20,
            //   fontWeight: FontWeight.w700,
            // ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LegalHeader(
                icon: Icons.privacy_tip_outlined,
                title: 'Your Privacy Matters',
                description:
                    'We respect your privacy and explain how information is handled when you use Card Game.',
                lastUpdated: 'Last Updated: August 12, 2026',
              ),

              const SizedBox(height: 28),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                itemCount: privacyPolicyContent.length,
                itemBuilder: (context, index) {
                  final row = privacyPolicyContent[index];
                  return LegalSection(
                    index: index,
                    title: row.title,
                    content: row.content,
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: AppSpacing.xs);
                },
              ),
              LegalFooter(
                text:
                    'By using Card Game, you acknowledge that you have read and understood this Privacy Policy.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
