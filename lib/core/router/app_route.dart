import 'package:get/get.dart';

enum AppRoute {
  splash(name: 'splash', path: '/'),
  onboarding(name: 'onboarding', path: '/onboarding'),
  authentication(name: 'authentication', path: '/authentication'),
  home(name: 'home', path: '/home'),
  publicMatchmaking(name: 'public-matchmaking', path: '/matchmaking/public'),
  createTable(name: 'create-table', path: '/tables/create'),
  joinTable(name: 'join-table', path: '/tables/join'),
  tablePassword(name: 'table-password', path: '/tables/:roomCode/password'),
  hostLobby(name: 'host-lobby', path: '/tables/:roomCode/lobby/host'),
  guestLobby(name: 'guest-lobby', path: '/tables/:roomCode/lobby/guest'),
  gameTable(name: 'game-table', path: '/games/:gameId'),
  offline(name: 'offline', path: '/offline'),
  profile(name: 'profile', path: '/profile');

  const AppRoute({required this.name, required this.path});
  final String name;
  final String path;
}

extension AppRouteNavigation on AppRoute {
  void go({Map<String, String>? parameters}) {
    Get.toNamed(path, parameters: parameters);
  }

  void offAll() {
    Get.offAllNamed(path);
  }
}
