import 'package:card_game/features/offline/controllers/ai_controller.dart';
import 'package:card_game/features/offline/controllers/game_config.dart';
import 'package:card_game/features/offline/controllers/timer_controller.dart';
import 'package:card_game/features/offline/engine/game_engine.dart';
import 'package:card_game/features/offline/presentation/animations/game_animation_controller.dart';
import 'package:get/get.dart';

class OfflineBinding extends Bindings {
  @override
  void dependencies() {
    final engine = GameEngine(config: GameConfig());
    // Get.put(GameController(engine: engine));
    Get.put(AIController(engine: engine));
    Get.put(TimerController());
    Get.put(GameAnimationController());
  }
}
