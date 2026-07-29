import 'dart:ui';

import 'package:card_game/features/offline/models/playing_card.dart';

class FlyingCard {
  FlyingCard({
    required this.card,
    required this.start,
    required this.end,
    this.faceUp = false,
    this.rotation = 0,
    this.scale = 0,
    this.opacity = 0,
  });

  final PlayingCard card;

  Offset start;

  Offset end;

  bool faceUp;

  double rotation;

  double scale;

  double opacity;
}
