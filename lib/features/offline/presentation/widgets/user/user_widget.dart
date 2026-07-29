import 'package:card_game/features/offline/models/action_state.dart';
import 'package:card_game/features/offline/models/playing_card.dart';
import 'package:card_game/features/offline/presentation/widgets/user/action_bar/action_bar.dart';
import 'package:card_game/features/offline/presentation/widgets/user/user_card_stack.dart';
import 'package:flutter/material.dart';

class UserWidget extends StatelessWidget {
  const UserWidget({
    super.key,
    required this.state,
    required this.selectedCard,
    required this.onDraw,
    required this.onTakeOpen,
    required this.onDiscard,
    required this.onPlayAgain,
    required this.onExit,
    required this.onSort,
    required this.cards,
    required this.canDeclare,
    required this.fourthCard,
  });
  final ActionState state;
  final PlayingCard? selectedCard;

  final VoidCallback onDraw;
  final VoidCallback onTakeOpen;
  final VoidCallback onDiscard;
  final VoidCallback onPlayAgain;
  final VoidCallback onExit;
  final VoidCallback onSort;
  final List<PlayingCard> cards;
  final bool canDeclare;
  final List<PlayingCard> fourthCard;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        UserCardStack(),
        Align(
          alignment: AlignmentGeometry.bottomCenter,
          child: ActionBar(
            state: state,
            selectedCard: selectedCard,
            onDraw: onDraw,
            onTakeOpen: onTakeOpen,
            onDiscard: onDiscard,
            onPlayAgain: onPlayAgain,
            onExit: onExit,
            onSort: onSort,
            cards: cards,
            canDeclare: canDeclare,
            fourthCard: fourthCard,
          ),
        ),

        // if (player.isThinking)
        //   const Padding(
        //     padding: EdgeInsets.only(bottom: 6),
        //     child: OpponentThinking(),
        //   ),
        // OpponentAvatar(
        //   name: CommonServices.getUserName(),
        //   isCurrentTurn: false,
        // ),
        // OpponentName(name: player.name),
        // if (player.hasWon) ...[
        //   const Icon(Icons.emoji_events, color: Colors.amber),
        // ],
      ],
    );
  }
}
