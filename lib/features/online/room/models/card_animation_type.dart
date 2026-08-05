import 'package:card_game/features/online/room/models/card_model.dart';

enum CardAnimationType { drawFromDeck, drawFromOpen, discard, deal }

class CardFlight {
  const CardFlight({required this.card, required this.type, this.cardId});

  final CardModel? card;
  final CardAnimationType type;
  final int? cardId;
}
