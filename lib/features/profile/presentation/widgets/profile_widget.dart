import 'package:card_game/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({
    super.key,
    required this.name,
    required this.profilePath,
  });
  final String name;
  final String profilePath;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSpacing.xs,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // if (profilePath.isNotEmpty)
        //   CircleAvatar(
        //     radius: 42,
        //     child: Image.network(profilePath, fit: BoxFit.cover),
        //   ),
        Card(
          shape: CircleBorder(),
          margin: EdgeInsets.zero,
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : 'P',
              style: TextStyle(fontSize: 36),
            ),
          ),
        ),
        Text(
          name,
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
