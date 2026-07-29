class GameConfig {
  final int cardsPerPlayer;
  final int turnTimeout;
  final int maxPlayers;
  final int minPlayers;

  const GameConfig({
    this.cardsPerPlayer = 13,
    this.turnTimeout = 20,
    this.minPlayers = 2,
    this.maxPlayers = 10,
  });
}
