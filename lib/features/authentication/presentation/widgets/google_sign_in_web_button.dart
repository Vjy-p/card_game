import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in_web/web_only.dart' as google_web;

Widget getGoogleSignInButton({Future<void> Function()? onPressed}) {
  return const GoogleSignInWebButton();
}

class GoogleSignInWebButton extends StatelessWidget {
  const GoogleSignInWebButton({super.key});

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return const SizedBox.shrink();
    }

    return google_web.renderButton(
      configuration: google_web.GSIButtonConfiguration(
        theme: google_web.GSIButtonTheme.outline,
        size: google_web.GSIButtonSize.large,
        text: google_web.GSIButtonText.signinWith,
        shape: google_web.GSIButtonShape.rectangular,
        minimumWidth: 300,
      ),
    );
  }
}
