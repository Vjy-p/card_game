import 'package:card_game/core/services/lobby_sync_services.dart';
import 'package:card_game/features/ads/controllers/ads_controller.dart';
import 'package:card_game/features/home/controllers/home_controller.dart';
import 'package:card_game/features/offline/controllers/ai_controller.dart';
import 'package:card_game/features/offline/controllers/animations/game_animation_controller.dart';
import 'package:card_game/features/offline/controllers/game_config.dart';
import 'package:card_game/features/offline/engine/game_engine.dart';
import 'package:card_game/features/online/create_table/controller/create_table_controller.dart';
import 'package:card_game/features/online/room/controllers/join_table_controller.dart';
import 'package:card_game/features/online/room/controllers/room_controller.dart';
import 'package:card_game/features/online/room/repositories/supabase_room_repository.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController(), fenix: true);
    Get.lazyPut(() => GameAnimationController(), fenix: true);
    Get.lazyPut(
      () => AIController(engine: GameEngine(config: const GameConfig())),
      fenix: true,
    );

    Get.lazyPut<SupabaseRoomRepository>(
      () => SupabaseRoomRepository(),
      fenix: true,
    );

    Get.lazyPut<LobbySyncService>(
      () => LobbySyncService(Get.find()),
      fenix: true,
    );

    // Get.lazyPut<RoomController>(() => RoomController(Get.find(), Get.find()));
    Get.lazyPut<RoomController>(() => RoomController(Get.find()), fenix: true);
    Get.lazyPut<SupabaseClient>(() => Supabase.instance.client, fenix: true);
    Get.lazyPut<JoinTableController>(() => JoinTableController());
    Get.lazyPut<CreateTableController>(() => CreateTableController());
    Get.lazyPut<AdsController>(() => AdsController(), fenix: true);
  }
}
