import 'package:card_game/features/online/room/controllers/base_controller.dart';
import 'package:card_game/features/online/room/repositories/supabase_room_repository.dart';
import 'package:get/get.dart';

class PublicRoomController extends BaseController {
  RxInt joinedPlayerCount = 0.obs;

  final SupabaseRoomRepository _repository = Get.put(SupabaseRoomRepository());
}
