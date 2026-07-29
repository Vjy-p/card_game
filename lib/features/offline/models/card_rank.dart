enum CardRank {
  ace('A', 1),

  two('2', 2),
  three('3', 3),
  four('4', 4),
  five('5', 5),
  six('6', 6),
  seven('7', 7),
  eight('8', 8),
  nine('9', 9),
  ten('10', 10),

  jack('J', 11),
  queen('Q', 12),
  king('K', 13);

  const CardRank(this.label, this.value);

  final String label;
  final int value;
}
