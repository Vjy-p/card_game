import 'package:card_game/features/offline/models/meld_type.dart';

enum DeclarationStatus { valid, invalid }

class DeclarationResult {
  const DeclarationResult({
    required this.status,
    required this.melds,
    required this.score,
    this.error,
    this.unlocksJoker = false,
  });

  final DeclarationStatus status;

  final List<Meld> melds;

  final int score;

  final String? error;

  final bool unlocksJoker;

  bool get isValid => status == DeclarationStatus.valid;
}
