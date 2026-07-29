import 'package:card_game/core/router/app_route.dart';
// Import all your screens...
import 'package:card_game/features/authentication/presentation/screens/authentication_screen.dart';
import 'package:card_game/features/home/presentation/screens/home_screen.dart';
import 'package:card_game/features/offline/controllers/bindings.dart';
import 'package:card_game/features/offline/presentation/screens/offline_screen.dart';
import 'package:card_game/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:card_game/features/profile/screens/profile_screen.dart';
import 'package:card_game/features/splash/presentation/screens/splash_screen.dart';
import 'package:get/get.dart';

class AppPages {
  static final routes = [
    GetPage(name: AppRoute.splash.path, page: () => const SplashScreen()),
    GetPage(
      name: AppRoute.onboarding.path,
      page: () => const OnboardingScreen(),
    ),
    GetPage(
      name: AppRoute.authentication.path,
      page: () => const AuthenticationScreen(),
    ),
    GetPage(name: AppRoute.home.path, page: () => const HomeScreen()),
    // GetPage(
    //   name: AppRoute.publicMatchmaking.path,
    //   page: () => const PublicMatchmakingScreen(),
    // ),
    // GetPage(
    //   name: AppRoute.createPrivateTable.path,
    //   page: () => const CreatePrivateTableScreen(),
    // ),
    // GetPage(
    //   name: AppRoute.joinTable.path,
    //   page: () => JoinTableScreen(
    //     // GetX equivalent of state.uri.queryParameters
    //     inviteToken: Get.parameters['invite'],
    //   ),
    // ),
    // GetPage(
    //   name: AppRoute.tablePassword.path, // Path is '/tables/:roomCode/password'
    //   page: () => TablePasswordScreen(
    //     // GetX equivalent of state.pathParameters
    //     roomCode: Get.parameters['roomCode'] ?? '',
    //   ),
    // ),
    // GetPage(name: AppRoute.hostLobby.path, page: () => const HostLobbyScreen()),
    // GetPage(
    //   name: AppRoute.guestLobby.path,
    //   page: () => const GuestLobbyScreen(),
    // ),
    // GetPage(
    //   name: AppRoute.gameTable.path, // Path is '/games/:gameId'
    //   page: () => const GameTableScreen(),
    // ),
    GetPage(name: AppRoute.profile.path, page: () => const ProfileScreen()),
    GetPage(
      name: AppRoute.offline.path,
      page: () => OfflineScreen(),
      binding: OfflineBinding(),
    ),
  ];
}
