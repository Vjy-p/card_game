class ScoreBreakdown {
  const ScoreBreakdown({
    this.completedSets = 0,
    this.almostCompletedSets = 0,
    this.pairs = 0,
    this.deadCards = 0,
    this.jokers = 0,
    this.total = 0,
  });

  final int completedSets;

  final int almostCompletedSets;

  final int pairs;

  final int deadCards;

  final int jokers;

  final int total;

  ScoreBreakdown copyWith({
    int? completedSets,
    int? almostCompletedSets,
    int? pairs,
    int? deadCards,
    int? jokers,
    int? total,
  }) {
    return ScoreBreakdown(
      completedSets: completedSets ?? this.completedSets,
      almostCompletedSets: almostCompletedSets ?? this.almostCompletedSets,
      pairs: pairs ?? this.pairs,
      deadCards: deadCards ?? this.deadCards,
      jokers: jokers ?? this.jokers,
      total: total ?? this.total,
    );
  }
}
