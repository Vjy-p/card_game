import 'package:card_game/core/router/app_route.dart';
// Import all your screens...
import 'package:card_game/features/authentication/presentation/screens/authentication_screen.dart';
import 'package:card_game/features/home/presentation/screens/home_screen.dart';
import 'package:card_game/features/legal/presentation/screens/delete_account_screen.dart';
import 'package:card_game/features/legal/presentation/screens/privacy_policy_screen.dart';
import 'package:card_game/features/legal/presentation/screens/terms_conditions_screen.dart';
import 'package:card_game/features/offline/presentation/screens/offline_screen.dart';
import 'package:card_game/features/offline/presentation/screens/ranking_screen.dart';
import 'package:card_game/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:card_game/features/online/create_table/presentation/screens/create_table_screen.dart';
import 'package:card_game/features/online/join_table/presentation/screens/join_table_screen.dart';
import 'package:card_game/features/online/join_table/presentation/screens/table_password_screen.dart';
import 'package:card_game/features/online/lobby/presentation/screens/guest_lobby_screen.dart';
import 'package:card_game/features/online/lobby/presentation/screens/host_lobby_screen.dart';
import 'package:card_game/features/online/public_rooms/presentation/screens/public_matchmaking_screen.dart';
import 'package:card_game/features/online/room/controllers/join_table_controller.dart';
import 'package:card_game/features/online/room/controllers/online_game_controller.dart';
import 'package:card_game/features/online/room/presentation/screens/online_ranking_screen.dart';
import 'package:card_game/features/online/room/presentation/screens/table_screen.dart';
import 'package:card_game/features/payments/presentation/screens/payments_screen.dart';
import 'package:card_game/features/profile/presentation/screens/profile_screen.dart';
import 'package:card_game/features/splash/presentation/screens/splash_screen.dart';
import 'package:get/get.dart';

class AppPages {
  // static final routes = GoRouter(
  //   initialLocation: '/',
  //   routes: [
  //     GoRoute(
  //       name: AppRoute.splash.name,
  //       path: AppRoute.splash.path,
  //       builder: (context, state) => const SplashScreen(),
  //     ),
  //     GoRoute(
  //       name: AppRoute.onboarding.name,
  //       path: AppRoute.onboarding.path,
  //       builder: (context, state) => const OnboardingScreen(),
  //     ),
  //     GoRoute(
  //       name: AppRoute.authentication.name,
  //       path: AppRoute.authentication.path,
  //       builder: (context, state) => const AuthenticationScreen(),
  //     ),
  //     GoRoute(
  //       name: AppRoute.home.name,
  //       path: AppRoute.home.path,
  //       builder: (context, state) => HomeScreen(),
  //     ),
  //     GoRoute(
  //       name: AppRoute.publicMatchmaking.name,
  //       path: AppRoute.publicMatchmaking.path,
  //       builder: (context, state) => const PublicMatchmakingScreen(),
  //     ),
  //     GoRoute(
  //       name: AppRoute.createTable.name,
  //       path: AppRoute.createTable.path,
  //       builder: (context, state) => const CreateTableScreen(),
  //     ),
  //     GoRoute(
  //       name: AppRoute.joinTable.name,
  //       path: AppRoute.joinTable.path,
  //       builder: (context, state) {
  //         Get.lazyPut(() => JoinTableController());
  //         return JoinTableScreen(
  //           // GetX equivalent of state.uri.queryParameters
  //           inviteToken: Get.parameters['invite'],
  //         );
  //       },
  //     ),
  //     GoRoute(
  //       name: AppRoute.tablePassword.name,
  //       path:
  //           AppRoute.tablePassword.path, // Path is '/tables/:roomCode/password'
  //       builder: (context, state) => TablePasswordScreen(
  //         // GetX equivalent of state.pathParameters
  //         roomCode: Get.parameters['roomCode'] ?? '',
  //       ),
  //     ),
  //     GoRoute(
  //       name: AppRoute.hostLobby.name,
  //       path: AppRoute.hostLobby.path,
  //       builder: (context, state) => const HostLobbyScreen(),
  //     ),
  //     GoRoute(
  //       name: AppRoute.guestLobby.name,
  //       path: AppRoute.guestLobby.path,
  //       builder: (context, state) => const GuestLobbyScreen(),
  //     ),
  //     GoRoute(
  //       name: AppRoute.gameTable.name,
  //       path: AppRoute.gameTable.path, // Path is '/games/:gameId'
  //       builder: (context, state) {
  //         Get.lazyPut(
  //           () => OnlineGameController(
  //             Get.parameters['roomId'] ?? '',
  //             Get.parameters['localPlayerId'] ?? '',
  //             Get.parameters['snapshotString'] ?? '',
  //           ),
  //         );
  //         return const TableScreen();
  //       },
  //     ),
  //     GoRoute(
  //       name: AppRoute.profile.name,
  //       path: AppRoute.profile.path,
  //       builder: (context, state) => const ProfileScreen(),
  //     ),
  //     GoRoute(
  //       name: AppRoute.offline.name,
  //       path: AppRoute.offline.path,
  //       builder: (context, state) => OfflineScreen(),
  //       // binding: AppBinding(),
  //     ),
  //     GoRoute(
  //       name: AppRoute.offlineRanking.name,
  //       path: AppRoute.offlineRanking.path,
  //       builder: (context, state) => RankingScreen(),
  //       // binding: AppBinding(),
  //     ),
  //     GoRoute(
  //       name: AppRoute.onlineRanking.name,
  //       path: AppRoute.onlineRanking.path,
  //       builder: (context, state) => OnlineRankingScreen(),
  //       // binding: AppBinding(),
  //     ),
  //     GoRoute(
  //       name: AppRoute.payments.name,
  //       path: AppRoute.payments.path,
  //       builder: (context, state) => const PaymentsScreen(),
  //     ),
  //     GoRoute(
  //       name: AppRoute.privacy.name,
  //       path: AppRoute.privacy.path,
  //       builder: (context, state) => const PrivacyPolicyScreen(),
  //     ),
  //     GoRoute(
  //       name: AppRoute.terms.name,
  //       path: AppRoute.terms.path,
  //       builder: (context, state) => const TermsConditionsScreen(),
  //     ),
  //     GoRoute(
  //       name: AppRoute.delete.name,
  //       path: AppRoute.delete.path,
  //       builder: (context, state) => const DeleteAccountScreen(),
  //     ),
  //   ],
  // );
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
    GetPage(name: AppRoute.home.path, page: () => HomeScreen()),
    GetPage(
      name: AppRoute.publicMatchmaking.path,
      page: () => const PublicMatchmakingScreen(),
    ),
    GetPage(
      name: AppRoute.createTable.path,
      page: () => const CreateTableScreen(),
    ),
    GetPage(
      name: AppRoute.joinTable.path,
      page: () => JoinTableScreen(
        // GetX equivalent of state.uri.queryParameters
        inviteToken: Get.parameters['invite'],
      ),
      binding: BindingsBuilder.put(() => JoinTableController()),
    ),
    GetPage(
      name: AppRoute.tablePassword.path, // Path is '/tables/:roomCode/password'
      page: () => TablePasswordScreen(
        // GetX equivalent of state.pathParameters
        roomCode: Get.parameters['roomCode'] ?? '',
      ),
    ),
    GetPage(name: AppRoute.hostLobby.path, page: () => const HostLobbyScreen()),
    GetPage(
      name: AppRoute.guestLobby.path,
      page: () => const GuestLobbyScreen(),
    ),
    GetPage(
      name: AppRoute.gameTable.path, // Path is '/games/:gameId'
      page: () => const TableScreen(),
      binding: BindingsBuilder.put(
        () => OnlineGameController(
          Get.parameters['roomId'] ?? '',
          Get.parameters['localPlayerId'] ?? '',
          Get.parameters['snapshotString'] ?? '',
        ),
      ),
    ),
    GetPage(name: AppRoute.profile.path, page: () => const ProfileScreen()),
    GetPage(
      name: AppRoute.offline.path,
      page: () => OfflineScreen(),
      // binding: AppBinding(),
    ),
    GetPage(
      name: AppRoute.offlineRanking.path,
      page: () => RankingScreen(),
      // binding: AppBinding(),
    ),
    GetPage(
      name: AppRoute.onlineRanking.path,
      page: () => OnlineRankingScreen(),
      // binding: AppBinding(),
    ),
    GetPage(name: AppRoute.payments.path, page: () => const PaymentsScreen()),
    GetPage(
      name: AppRoute.privacy.path,
      page: () => const PrivacyPolicyScreen(),
    ),
    GetPage(
      name: AppRoute.terms.path,
      page: () => const TermsConditionsScreen(),
    ),
    GetPage(
      name: AppRoute.delete.path,
      page: () => const DeleteAccountScreen(),
    ),
  ];
}
