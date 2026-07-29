enum TurnState {
  /// Waiting for the player to draw.
  waitingToDraw,

  /// Player has drawn and must pass.
  waitingToPass,

  /// Used while switching players.
  switching,

  /// Game ended.
  finished,
}
