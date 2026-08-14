import 'package:card_game/core/router/can_go_back.dart';
import 'package:card_game/core/theme/app_spacing.dart';
import 'package:card_game/features/legal/models/legal_content_model.dart';
import 'package:card_game/features/legal/presentation/widgets/legal_footer.dart';
import 'package:card_game/features/legal/presentation/widgets/legal_header.dart';
import 'package:card_game/features/legal/presentation/widgets/legal_section.dart';
import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  static const List<LegalContentModel> termsAndConditionsContent = [
    LegalContentModel(
      title: '1. About Card Game',
      content:
          'Card Game is a mobile card game that allows users to play card games through offline gameplay against computer-controlled players and online multiplayer gameplay, depending on the features available in the application.',
    ),

    LegalContentModel(
      title: '2. Acceptance of Terms',
      content:
          'By downloading, accessing, or using Card Game, you agree to these Terms & Conditions. If you do not agree with these Terms, please do not use the application.',
    ),

    LegalContentModel(
      title: '3. Eligibility',
      content:
          'You must meet the minimum age requirements applicable in your country to use Card Game. If you are under the applicable age of consent, you should use the application only with the involvement and permission of a parent or legal guardian where required by law.',
    ),

    LegalContentModel(
      title: '4. User Accounts',
      content:
          'Some features may require an account. You agree to provide accurate information when requested, keep your account information secure, not impersonate another person, and not use another person’s account without authorization.',
    ),

    LegalContentModel(
      title: '5. Acceptable Use',
      content:
          'You must not cheat, exploit game mechanics, use unauthorized bots or scripts, access another user’s account, interfere with game servers, attempt unauthorized access to backend systems, reverse engineer the application where prohibited by law, engage in fraudulent activity, harass other players, transmit malicious software, or circumvent security mechanisms.',
    ),

    LegalContentModel(
      title: '6. Multiplayer Gameplay',
      content:
          'Online gameplay depends on internet connectivity, servers, and third-party infrastructure. We do not guarantee that multiplayer services will always be available, error-free, uninterrupted, or free from delays. Game rooms, matches, player connections, and game states may be affected by network failures, maintenance, or circumstances beyond our control.',
    ),

    LegalContentModel(
      title: '7. Game Results',
      content:
          'Game results, scores, rankings, and other gameplay information may be generated automatically by the application and backend systems. We reserve the right to correct game results or rankings when technical errors, exploits, cheating, or other issues are discovered.',
    ),

    LegalContentModel(
      title: '8. Advertisements',
      content:
          'Card Game may display advertisements provided by third-party advertising services such as Google AdMob. We do not control the content of third-party advertisements and are not responsible for products or services promoted through those advertisements.',
    ),

    LegalContentModel(
      title: '9. Intellectual Property',
      content:
          'The Card Game application, including its software, graphics, interface, logos, game design, animations, text, sounds, and other content, is owned by or licensed to us and is protected by applicable intellectual-property laws. You may not copy, reproduce, distribute, modify, sell, or create derivative works from our content without appropriate authorization.',
    ),

    LegalContentModel(
      title: '10. Third-Party Services',
      content:
          'The application may use third-party services for authentication, cloud databases, multiplayer infrastructure, analytics, advertising, crash reporting, notifications, and other functionality. These services may have their own terms and privacy policies.',
    ),

    LegalContentModel(
      title: '11. Availability and Changes',
      content:
          'We may update, modify, suspend, or discontinue any part of Card Game at any time. Updates may change gameplay mechanics, features, graphics, balancing, or technical requirements. We are not obligated to provide continued support for older versions of the application.',
    ),

    LegalContentModel(
      title: '12. Disclaimer',
      content:
          'Card Game is provided on an “as is” and “as available” basis to the maximum extent permitted by applicable law. We do not guarantee that the application will always operate without errors, remain available, be compatible with every device, or be free from bugs and interruptions.',
    ),

    LegalContentModel(
      title: '13. Limitation of Liability',
      content:
          'To the maximum extent permitted by applicable law, we will not be liable for indirect, incidental, special, consequential, or similar damages arising from your use of or inability to use Card Game. Nothing in these Terms excludes or limits liability that cannot legally be excluded or limited.',
    ),

    LegalContentModel(
      title: '14. Termination',
      content:
          'We may suspend or terminate your access to Card Game if you violate these Terms, engage in cheating or fraudulent activity, attempt to compromise the application or infrastructure, create a security or legal risk, or when required by applicable law.',
    ),

    LegalContentModel(
      title: '15. Privacy',
      content:
          'Your use of Card Game is also governed by our Privacy Policy. Please review the Privacy Policy to understand how information is collected, used, stored, and processed.',
    ),

    LegalContentModel(
      title: '16. Changes to These Terms',
      content:
          'We may update these Terms from time to time. When changes are made, we will update the Last Updated date displayed on this page. Your continued use of Card Game after changes become effective means that you accept the updated Terms.',
    ),

    LegalContentModel(
      title: '17. Governing Law',
      content:
          'These Terms shall be governed by the applicable laws of India, unless applicable law requires otherwise. Any disputes will be subject to the jurisdiction of the appropriate courts in India, subject to applicable consumer-protection and other mandatory legal rights.',
    ),

    LegalContentModel(
      title: '18. Contact Us',
      content:
          'If you have questions, concerns, or requests regarding these Terms, please contact us at: YOUR_SUPPORT_EMAIL',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        CanGoBack.go();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            onPressed: () => CanGoBack.go(),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          title: const Text(
            'Terms & Conditions',
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
                icon: Icons.description_outlined,
                title: 'Terms of Use',
                description:
                    'Please read these terms carefully before using Card Game.',
                lastUpdated: 'Last Updated: August 12, 2026',
              ),

              const SizedBox(height: 28),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                itemCount: termsAndConditionsContent.length,
                itemBuilder: (context, index) {
                  final row = termsAndConditionsContent[index];
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
                    'By using Card Game, you acknowledge that you have read, understood, and agreed to these Terms & Conditions.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
