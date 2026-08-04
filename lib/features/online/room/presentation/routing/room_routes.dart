abstract final class RoomRoutes {
  static const create = '/room/create';
  static const join = '/room/join';

  static String game(String roomId) => '/game/$roomId';
}
