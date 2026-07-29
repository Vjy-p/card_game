import 'package:card_game/features/offline/models/action_state.dart';
import 'package:card_game/features/offline/models/player_status.dart';
import 'package:card_game/features/offline/models/playing_card.dart';

class TableViewState {
  const TableViewState({
    required this.forwardCard,
    required this.hiddenJoker,
    required this.remainingCards,
    required this.opponents,
    required this.myCards,
    required this.actionState,
    this.selectedCard,
    this.openCard,
  });

  final PlayingCard? forwardCard;
  final PlayingCard? hiddenJoker;
  final int remainingCards;
  final List<PlayerStatus> opponents;
  final List<PlayingCard> myCards;
  final ActionState actionState;
  final PlayingCard? selectedCard;
  final PlayingCard? openCard;

  factory TableViewState.initial() {
    return const TableViewState(
      forwardCard: null,
      hiddenJoker: null,
      openCard: null,
      remainingCards: 0,
      opponents: [],
      myCards: [],
      actionState: ActionState.waitingToDraw,
      selectedCard: null,
    );
  }

  bool get canDraw => actionState == ActionState.waitingToDraw;

  bool get canTakeForward => actionState == ActionState.waitingToDraw;

  bool get canDiscard => actionState == ActionState.waitingToDiscard;

  bool get isOpponentTurn => actionState == ActionState.opponentTurn;

  bool get isGameFinished => actionState == ActionState.gameFinished;

  bool get hasSelection => selectedCard != null;

  TableViewState copyWith({
    PlayingCard? forwardCard,
    int? remainingCards,
    bool? canDraw,
    bool? canTakeForward,
    bool? isPlayerTurn,
    bool? isGameOver,
    List<PlayerStatus>? opponents,
    List<PlayingCard>? myCards,
    ActionState? actionState,
    PlayingCard? selectedCard,
    PlayingCard? hiddenJoker,
    PlayingCard? openCard,
  }) {
    return TableViewState(
      forwardCard: forwardCard ?? this.forwardCard,
      remainingCards: remainingCards ?? this.remainingCards,
      opponents: opponents ?? this.opponents,
      myCards: myCards ?? this.myCards,
      actionState: actionState ?? this.actionState,
      selectedCard: selectedCard ?? this.selectedCard,
      hiddenJoker: hiddenJoker ?? this.hiddenJoker,
      openCard: openCard ?? this.openCard,
    );
  }
}
