import 'package:card_game/features/offline/engine/turn_manager.dart';
import 'package:card_game/features/offline/models/turn_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TurnManager - Lifecycle & Validation', () {
    test('initializes and starts with specified first player', () {
      final turnManager = TurnManager(playerCount: 4);
      turnManager.start(firstPlayer: 2);

      expect(turnManager.currentPlayer, 2);
      expect(turnManager.turnNumber, 1);
      expect(turnManager.state, TurnState.waitingToDraw);
      expect(turnManager.waitingForDraw, isTrue);
      expect(turnManager.waitingForPass, isFalse);
      expect(turnManager.isFinished, isFalse);
    });

    test('throws ArgumentError if firstPlayer is out of bounds', () {
      final turnManager = TurnManager(playerCount: 4);

      expect(() => turnManager.start(firstPlayer: -1), throwsArgumentError);
      expect(() => turnManager.start(firstPlayer: 4), throwsArgumentError);
    });

    test('validates turn permissions for draw and pass', () {
      final turnManager = TurnManager(playerCount: 3);
      turnManager.start(firstPlayer: 0);

      // Player 0's turn
      expect(turnManager.isPlayersTurn(0), isTrue);
      expect(turnManager.isPlayersTurn(1), isFalse);
      expect(turnManager.canDraw(0), isTrue);
      expect(turnManager.canDraw(1), isFalse);
      expect(turnManager.canPass(0), isFalse); // Has not drawn yet

      // Player 0 draws card
      turnManager.playerDrewCard(0);
      expect(turnManager.waitingForDraw, isFalse);
      expect(turnManager.waitingForPass, isTrue);
      expect(turnManager.canDraw(0), isFalse);
      expect(turnManager.canPass(0), isTrue);
      expect(turnManager.canPass(1), isFalse);
    });

    test('throws StateError on illegal state transitions', () {
      final turnManager = TurnManager(playerCount: 3);
      turnManager.start(firstPlayer: 0);

      // Cannot pass before drawing
      expect(() => turnManager.playerPassedCard(0), throwsStateError);

      // Non-active player cannot draw
      expect(() => turnManager.playerDrewCard(1), throwsStateError);

      turnManager.playerDrewCard(0);

      // Cannot draw twice in one turn
      expect(() => turnManager.playerDrewCard(0), throwsStateError);

      // Non-active player cannot pass
      expect(() => turnManager.playerPassedCard(1), throwsStateError);
    });

    test('advances to next player and increments turn number on round completion', () {
      final turnManager = TurnManager(playerCount: 3);
      turnManager.start(firstPlayer: 0);

      // Player 0 finishes turn
      turnManager.playerDrewCard(0);
      turnManager.playerPassedCard(0);

      expect(turnManager.currentPlayer, 1);
      expect(turnManager.turnNumber, 2);
      expect(turnManager.waitingForDraw, isTrue);

      // Player 1 finishes turn
      turnManager.playerDrewCard(1);
      turnManager.playerPassedCard(1);

      expect(turnManager.currentPlayer, 2);
      expect(turnManager.turnNumber, 3);

      // Player 2 finishes turn - wraps back to seat 0
      turnManager.playerDrewCard(2);
      turnManager.playerPassedCard(2);

      expect(turnManager.currentPlayer, 0);
      expect(turnManager.turnNumber, 4);
    });

    test('timeout advances turn to next player', () {
      final turnManager = TurnManager(playerCount: 2);
      turnManager.start(firstPlayer: 0);

      turnManager.timeout();
      expect(turnManager.currentPlayer, 1);
      expect(turnManager.waitingForDraw, isTrue);
    });

    test('finishGame sets state to finished', () {
      final turnManager = TurnManager(playerCount: 2);
      turnManager.start(firstPlayer: 0);

      turnManager.finishGame();
      expect(turnManager.state, TurnState.finished);
      expect(turnManager.isFinished, isTrue);
      expect(turnManager.canDraw(0), isFalse);
      expect(turnManager.canPass(0), isFalse);
    });

    test('info getter exposes immutable snapshot of turn state', () {
      final turnManager = TurnManager(playerCount: 2);
      turnManager.start(firstPlayer: 1);

      final info = turnManager.info;
      expect(info.currentPlayer, 1);
      expect(info.turnNumber, 1);
      expect(info.state, TurnState.waitingToDraw);
      expect(info.turnStartedAt, isNotNull);
    });
  });
}
