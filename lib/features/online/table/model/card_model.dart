import 'package:card_game/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

enum Suit {
  clubs,
  diamonds,
  hearts,
  spades,
  joker;

  // UI Helper: Get the color associated with the suit
  Color get color {
    switch (this) {
      case Suit.hearts:
      case Suit.diamonds:
        return AppColors.cardRed; // Premium Red
      case Suit.spades:
      case Suit.clubs:
        return AppColors.cardBlack; // Premium Black
      case Suit.joker:
        return AppColors.gold; // Premium Orange/Gold for Jokers
    }
  }

  String get symbol {
    switch (this) {
      case Suit.spades:
        return '♠';
      case Suit.hearts:
        return '♥';
      case Suit.diamonds:
        return '♦';
      case Suit.clubs:
        return '♣';
      case Suit.joker:
        return 'J';
    }
  }

  // Check if the suit is red
  bool get isRed => this == Suit.hearts || this == Suit.diamonds;
}

class CardModel {
  final String id;
  final Suit suit;
  final int rank;
  final String zone;
  final int? pilePosition;
  final String? ownerPlayerId;
  bool isWildJoker; // Changed to non-final so logic can update it

  CardModel({
    required this.id,
    required this.suit,
    required this.rank,
    required this.zone,
    this.isWildJoker = false,
    this.pilePosition,
    this.ownerPlayerId,
  });

  // UI Convenience Getters
  Color get color => suit.color;
  bool get isRed => suit.isRed;

  factory CardModel.fromJson(Map<String, dynamic> map) {
    return CardModel(
      id: map['id'].toString(),
      // ARCHITECT NOTE: Safe conversion from String to Enum
      suit: Suit.values.firstWhere(
        (e) => e.name == (map['suit']?.toString().toLowerCase() ?? 'joker'),
        orElse: () => Suit.joker,
      ),
      rank: map['rank'] as int? ?? 0,
      // Mapping snake_case from DB to camelCase in Flutter
      isWildJoker: map['is_wild_joker'] ?? false,
      zone: map['zone'] ?? '',
      ownerPlayerId: map['owner_player_id']?.toString(),
      pilePosition: map['pile_position'] as int?,
    );
  }

  // Logic helper
  bool get actsAsJoker => isWildJoker || suit == Suit.joker;
  String get cardNumber => switch (rank) {
    1 => 'A',
    2 => '2',
    3 => '3',
    4 => '4',
    5 => '5',
    6 => '6',
    7 => '7',
    8 => '8',
    9 => '9',
    10 => '10',
    11 => 'J',
    12 => 'Q',
    13 => 'K',
    _ => rank.toString(),
  };
}
