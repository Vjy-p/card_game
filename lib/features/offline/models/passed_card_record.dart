import 'package:card_game/features/offline/models/playing_card.dart';

class PassedCardRecord {
  const PassedCardRecord({
    required this.card,
    required this.playerSeat,
    required this.time,
  });

  final PlayingCard card;
  final int playerSeat;
  final DateTime time;
}
