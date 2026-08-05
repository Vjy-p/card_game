import 'package:card_game/features/online/room/models/card_model.dart';

class OnlinePlayerViewData {
  const OnlinePlayerViewData({
    required this.card,
    this.selected = false,
    this.faceUp = true,
    this.highlighted = false,
    this.draggable = true,
  });

  final CardModel? card;

  final bool selected;

  final bool faceUp;

  final bool highlighted;

  final bool draggable;
}
