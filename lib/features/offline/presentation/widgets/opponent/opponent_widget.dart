import 'package:card_game/core/theme/app_spacing.dart';
import 'package:card_game/features/offline/models/player_status.dart';
import 'package:card_game/features/offline/presentation/widgets/opponent/opponent_avatar.dart';
import 'package:card_game/features/offline/presentation/widgets/opponent/opponent_card_stack.dart';
import 'package:card_game/features/offline/presentation/widgets/opponent/opponent_thinking.dart';
import 'package:flutter/material.dart';

class OpponentWidget extends StatelessWidget {
  const OpponentWidget({super.key, required this.player, this.rotation = 0});
  final PlayerStatus player;
  final double rotation;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation,
      child: Column(
        spacing: AppSpacing.xs,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (player.isThinking)
            const Padding(
              padding: EdgeInsets.only(bottom: 6),
              child: OpponentThinking(),
            ),
          OpponentAvatar(
            name: player.name,
            isCurrentTurn: player.isCurrentTurn,
            isJokerUnlocked: player.isJokerUnlocked,
          ),
          // OpponentName(name: player.name),
          OpponentCardStack(cardCount: player.cardCount),

          // Text('${player.cardCount} Cards'),
          if (player.hasWon) ...[
            const Icon(Icons.emoji_events, color: Colors.amber),
          ],
        ],
      ),
    );
  }
}
