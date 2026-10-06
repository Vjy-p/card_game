import 'package:card_game/core/services/common_services.dart';
import 'package:card_game/features/ads/controllers/ads_controller.dart';
import 'package:card_game/features/offline/controllers/game_config.dart';
import 'package:card_game/features/offline/controllers/game_controller.dart';
import 'package:card_game/features/offline/engine/game_engine.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    Get.testMode = true;
    CommonServices.setMockStorage({
      'userId': 'test_user_id',
      'userName': 'Test User',
    });
    Get.put(AdsController());
  });

  tearDown(() {
    Get.reset();
  });

  group('GameController - Lifecycle & Safety', () {
    test('refreshTable does not throw when DeckManager is not initialized', () {
      final engine = GameEngine(config: const GameConfig());
      final controller = GameController(engine: engine);

      // DeckManager is not initialized yet
      expect(engine.deckManager.isInitialized, isFalse);
      expect(controller.openCard, isNull);

      // refreshTable should not throw StateError
      expect(() => controller.refreshTable(), returnsNormally);
      expect(controller.table.openCard, isNull);
    });

    test('clearData safely resets table state and clears session', () {
      final engine = GameEngine(config: const GameConfig());
      final controller = GameController(engine: engine);

      controller.clearData();

      expect(controller.gameSessionId, isEmpty);
      expect(controller.table.openCard, isNull);
      expect(controller.table.myCards, isEmpty);
      expect(controller.openCard, isNull);
    });

    test('initializeGame starts and deals cards without errors', () async {
      final engine = GameEngine(config: const GameConfig());
      final controller = GameController(engine: engine);

      final initFuture = controller.initializeGame();
      expect(initFuture, completes);
      await initFuture;

      expect(engine.deckManager.isInitialized, isTrue);
      expect(controller.openCard, isNotNull);
      expect(controller.table.openCard, isNotNull);
      expect(controller.table.myCards.length, 13);
    });

    test('clearData while initializeGame is dealing cancels dealing safely', () async {
      final engine = GameEngine(config: const GameConfig());
      final controller = GameController(engine: engine);

      // Start initializeGame but immediately clearData to simulate user navigating away or restarting
      final initFuture = controller.initializeGame();
      controller.clearData();

      // Wait for any remaining async callbacks in initializeGame to finish
      await initFuture;
      await Future<void>.delayed(const Duration(milliseconds: 150));

      expect(controller.gameSessionId, isEmpty);
      expect(engine.deckManager.isInitialized, isFalse);
      expect(controller.table.openCard, isNull);
    });

    test('restart completes without throwing uninitialized DeckManager error', () async {
      final engine = GameEngine(config: const GameConfig());
      final controller = GameController(engine: engine);

      await controller.initializeGame();
      expect(controller.openCard, isNotNull);

      // Restarting should clear data and re-initialize cleanly
      await controller.restart();

      expect(controller.openCard, isNotNull);
      expect(controller.table.openCard, isNotNull);
      expect(controller.table.myCards.length, 13);
    });
  });
}
