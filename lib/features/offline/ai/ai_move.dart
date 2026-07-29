import 'package:card_game/features/offline/models/playing_card.dart';

class AIMove {
  final bool takeOpenCard;
  final PlayingCard discardCard;
  final bool unlockJoker;
  final bool declareWin;
  List<PlayingCard> fourthCard;

  AIMove({
    required this.takeOpenCard,
    required this.discardCard,
    this.unlockJoker = false,
    this.declareWin = false,
    this.fourthCard = const [],
  });
}
