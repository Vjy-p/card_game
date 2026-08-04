import 'package:card_game/features/online/table/model/card_model.dart';

class OnlinePlayerModel {
  OnlinePlayerModel({
    required this.id,
    required this.name,
    required this.seat,
    required this.score,
    required this.rank,
    required this.cards,
  });

  final String id;

  final String name;

  final int seat;

  final int score;

  final int rank;

  final List<CardModel> cards;

  factory OnlinePlayerModel.fromJson(Map<String, dynamic> map) {
    final cardsJson = (map['cards'] as List<dynamic>? ?? []);

    return OnlinePlayerModel(
      id: map['id'].toString(),
      name: map['display_name'] ?? '',
      seat: map['seat_index'] ?? 0,
      score: map['score'] ?? 0,
      rank: map['final_rank'] as int? ?? -1,
      cards: cardsJson
          .map((e) => CardModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}
