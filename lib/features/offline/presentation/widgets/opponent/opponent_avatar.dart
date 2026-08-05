import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/features/online/room/presentation/widgets/turn_glow_widget.dart';
import 'package:flutter/material.dart';
import 'package:glass/glass.dart';

class OpponentAvatar extends StatelessWidget {
  const OpponentAvatar({
    super.key,
    required this.name,
    required this.isCurrentTurn,
    required this.isJokerUnlocked,
    required this.isGameEnded,
  });

  final String name;
  final bool isCurrentTurn;
  final bool isJokerUnlocked;
  final bool isGameEnded;

  @override
  Widget build(BuildContext context) {
    return Stack(
      // alignment: AlignmentGeometry.center,
      children: [
        TurnGlow(
          active: isCurrentTurn && !isGameEnded,
          child: CircleAvatar(
            radius: 24,
            backgroundColor: isCurrentTurn && !isGameEnded
                ? Colors.orange
                : AppColors.tableDark,
            child: isCurrentTurn
                ? Text(name[0], style: const TextStyle(fontSize: 22))
                : const Icon(Icons.person_outline),
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
