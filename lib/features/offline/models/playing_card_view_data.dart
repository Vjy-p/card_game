import 'package:card_game/features/offline/models/playing_card.dart';

class PlayingCardViewData {
  const PlayingCardViewData({
    required this.card,
    this.selected = false,
    this.faceUp = true,
    this.highlighted = false,
    this.draggable = true,
  });

  final PlayingCard card;

  final bool selected;

  final bool faceUp;

  final bool highlighted;

  final bool draggable;
}
