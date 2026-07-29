import 'package:card_game/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:glass/glass.dart';

class OpponentAvatar extends StatelessWidget {
  const OpponentAvatar({
    super.key,
    required this.name,
    required this.isCurrentTurn,
    required this.isJokerUnlocked,
  });

  final String name;
  final bool isCurrentTurn;
  final bool isJokerUnlocked;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isCurrentTurn ? Colors.greenAccent : Colors.transparent,
              width: 3,
            ),
          ),
          child: CircleAvatar(
            radius: 22,
            child: Text(name.substring(0, 1).toUpperCase()),
          ),
        ),
        if (isJokerUnlocked) ...[
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child:
                Icon(
                  Icons.visibility,
                  color: AppColors.actionPrimary.withValues(alpha: 0.5),
                  size: 18,
                ).asGlass(
                  clipBorderRadius: BorderRadius.circular(12),
                  tintColor: AppColors.accent,
                ),
          ),
        ],
      ],
    );
  }
}
