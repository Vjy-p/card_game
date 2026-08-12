import 'dart:developer';

import 'package:card_game/core/router/app_route.dart';
import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/core/theme/app_spacing.dart';
import 'package:card_game/features/ads/presentation/widgets/banner_ad_widget.dart';
import 'package:card_game/features/home/controllers/home_controller.dart';
import 'package:card_game/features/home/models/home_state.dart';
import 'package:card_game/features/home/presentation/widgets/home_side_panel.dart';
import 'package:card_game/features/home/presentation/widgets/primary_actions.dart';
import 'package:card_game/features/offline/controllers/ai_controller.dart';
import 'package:card_game/features/offline/controllers/animations/game_animation_controller.dart';
import 'package:card_game/features/offline/controllers/game_config.dart';
import 'package:card_game/features/offline/engine/game_engine.dart';
import 'package:card_game/features/online/create_table/controller/create_table_controller.dart';
import 'package:card_game/features/online/room/controllers/join_table_controller.dart';
import 'package:card_game/utils/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/state_manager.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final controller = Get.find<HomeController>();

  void _handleAction(HomePrimaryAction action) {
    controller.beginAction(action);
    log('action $action');
    if (!Get.isRegistered<GameAnimationController>()) {
      Get.lazyPut(() => GameAnimationController());
    }
    if (!Get.isRegistered<AIController>()) {
      Get.lazyPut(() => AIController(engine: GameEngine(config: GameConfig())));
    }

    if (action == HomePrimaryAction.playOffline) {
      controller.completeAction();
      AppRoute.offline.go();
      return;
    }

    if (action == HomePrimaryAction.playOnline) {
      if (!Get.isRegistered<JoinTableController>()) {
        Get.lazyPut<JoinTableController>(() => JoinTableController());
      }
      controller.completeAction();
      AppRoute.publicMatchmaking.go();
      return;
    }

    if (action == HomePrimaryAction.createTable) {
      if (!Get.isRegistered<CreateTableController>()) {
        Get.lazyPut<CreateTableController>(() => CreateTableController());
      }
      controller.completeAction();
      AppRoute.createTable.go();
      return;
    }

    if (action == HomePrimaryAction.joinTable) {
      if (!Get.isRegistered<JoinTableController>()) {
        Get.lazyPut<JoinTableController>(() => JoinTableController());
      }
      controller.completeAction();
      AppRoute.joinTable.go();
      return;
    }

    final message = switch (action) {
      HomePrimaryAction.playOffline => '',
      HomePrimaryAction.playOnline => '',
      HomePrimaryAction.createTable => '',
      HomePrimaryAction.joinTable => '',
    };

    customToast(message: message);

    controller.completeAction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 840;
            return CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: wide ? AppSpacing.xxl : AppSpacing.sm,
                    vertical: AppSpacing.md,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1120),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'CARD GAME',
                                  style: Theme.of(context).textTheme.labelMedium
                                      ?.copyWith(
                                        color: AppColors.actionPrimary,
                                        letterSpacing: 1.2,
                                      ),
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  'Ready for the next table?',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineMedium,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            style: ButtonStyle(
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                              padding: WidgetStatePropertyAll(EdgeInsets.zero),
                            ),
                            tooltip: 'Profile',
                            onPressed: () {
                              AppRoute.profile.go();
                            },
                            icon: const Icon(
                              Icons.person_outline_rounded,
                              size: 24,
                            ),
                          ),
                          // IconButton(
                          //   style: ButtonStyle(
                          //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          //     visualDensity: VisualDensity.compact,
                          //     padding: WidgetStatePropertyAll(EdgeInsets.zero),
                          //   ),
                          //   tooltip: 'Payments',
                          //   onPressed: () {
                          //     AppRoute.payments.go();
                          //   },
                          //   icon: Icon(Icons.payments, size: 24),
                          // ),
                          // IconButton(
                          //   tooltip: 'Settings',
                          //   onPressed: null,
                          //   icon: const Icon(Icons.settings_outlined),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
                Obx(() {
                  return controller.rejoinableSessions.isEmpty
                      ? const SliverToBoxAdapter(child: SizedBox.shrink())
                      : SliverPadding(
                          padding: EdgeInsets.symmetric(
                            horizontal: wide ? AppSpacing.xxl : AppSpacing.lg,
                          ),
                          sliver: SliverToBoxAdapter(
                            child: Card(
                              child: ListTile(
                                dense: true,
                                visualDensity: VisualDensity.comfortable,
                                leading: const Icon(
                                  Icons.restore_rounded,
                                  color: AppColors.actionPrimary,
                                ),
                                title: Text(
                                  controller.rejoinableSessions.first.status ==
                                          'playing'
                                      ? 'Resume ${controller.rejoinableSessions.first.tableName}'
                                      : 'Return to ${controller.rejoinableSessions.first.tableName}',
                                ),
                                subtitle: Text(
                                  controller.rejoinableSessions.first.status ==
                                          'playing'
                                      ? 'Your active game is waiting.'
                                      : 'Your lobby is still active.',
                                ),
                                trailing: const Icon(
                                  Icons.chevron_right_rounded,
                                ),
                                onTap: () async {
                                  final session =
                                      controller.rejoinableSessions.first;
                                  await controller.resumeRoom(session.roomId);
                                  if (!context.mounted) return;
                                  if (session.status == 'playing') {
                                    AppRoute.gameTable.go(
                                      pathParams: {'gameId': session.roomId},
                                    );
                                  } else {
                                    session.isHost
                                        ? AppRoute.hostLobby.go(
                                            pathParams: {
                                              'roomCode': session.roomId,
                                            },
                                          )
                                        : AppRoute.guestLobby.go(
                                            pathParams: {
                                              'roomCode': session.roomId,
                                            },
                                          );
                                  }
                                },
                              ),
                            ),
                          ),
                        );
                }),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: wide ? AppSpacing.xxl : AppSpacing.sm,
                    ),
                    child: const BannerAdWidget(),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    wide ? AppSpacing.xxl : AppSpacing.sm,
                    AppSpacing.md,
                    wide ? AppSpacing.xxl : AppSpacing.sm,
                    AppSpacing.xxl,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1120),
                        child: wide
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 6,
                                    child: PrimaryActions(
                                      controller: controller,
                                      onAction: (action) =>
                                          _handleAction(action),
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.xl),
                                  const Expanded(
                                    flex: 4,
                                    child: HomeSidePanel(),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  PrimaryActions(
                                    controller: controller,
                                    onAction: (action) => _handleAction(action),
                                  ),
                                  const SizedBox(height: AppSpacing.xl),
                                  const HomeSidePanel(),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
                // SliverToBoxAdapter(child: const NativeAdWidget()),
              ],
            );
          },
        ),
      ),
    );
  }
}
