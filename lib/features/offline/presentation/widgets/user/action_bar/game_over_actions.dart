import 'package:card_game/core/theme/app_spacing.dart';
import 'package:card_game/features/offline/presentation/widgets/user/action_bar/action_button.dart';
import 'package:flutter/material.dart';

class GameOverActions extends StatelessWidget {
  const GameOverActions({
    super.key,
    required this.onPlayAgain,
    required this.onExit,
  });
  final VoidCallback onPlayAgain;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSpacing.sm,
      children: [
        Text('Game Over'),
        Row(
          spacing: AppSpacing.sm,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ActionButton(
                onPressed: onExit,
                label: 'EXit',
                icon: Icon(Icons.exit_to_app),
              ),
            ),
            Expanded(
              child: ActionButton(
                onPressed: onPlayAgain,
                label: 'Play again',
                icon: Icon(Icons.restart_alt),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
