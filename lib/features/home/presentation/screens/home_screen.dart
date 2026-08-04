import 'dart:developer';

import 'package:card_game/core/router/app_route.dart';
import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/core/theme/app_spacing.dart';
import 'package:card_game/features/home/application/controllers/home_controller.dart';
import 'package:card_game/features/home/application/state/home_state.dart';
import 'package:card_game/features/home/presentation/widgets/home_side_panel.dart';
import 'package:card_game/features/home/presentation/widgets/primary_actions.dart';
import 'package:card_game/utils/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final controller = Get.find<HomeController>();

  void _handleAction(HomePrimaryAction action) {
    controller.beginAction(action);
    log('action $action');

    if (action == HomePrimaryAction.playOnline) {
      controller.completeAction();
      Get.toNamed(AppRoute.publicMatchmaking.path);

      return;
    }

    if (action == HomePrimaryAction.createTable) {
      controller.completeAction();
      Get.toNamed(AppRoute.createTable.path);
      return;
    }

    if (action == HomePrimaryAction.joinTable) {
      controller.completeAction();
      Get.toNamed(AppRoute.joinTable.path);
      return;
    }

    if (action == HomePrimaryAction.playOffline) {
      controller.completeAction();
      Get.toNamed(AppRoute.offline.path);
      return;
    }

    final message = switch (action) {
      HomePrimaryAction.playOnline => '',
      HomePrimaryAction.createTable => '',
      HomePrimaryAction.joinTable => '',
      HomePrimaryAction.playOffline => '',
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
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: wide ? AppSpacing.xxl : AppSpacing.lg,
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
                                  ).textTheme.headlineLarge,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            tooltip: 'Profile',
                            onPressed: () {
                              Get.toNamed(AppRoute.profile.path);
                            },
                            icon: const Icon(Icons.person_outline_rounded),
                          ),
                          IconButton(
                            tooltip: 'Settings',
                            onPressed: null,
                            icon: const Icon(Icons.settings_outlined),
                          ),
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
                                    Get.toNamed(
                                      AppRoute.gameTable.path,
                                      arguments: {'gameId': session.roomId},
                                    );
                                  } else {
                                    Get.toNamed(
                                      session.isHost
                                          ? AppRoute.hostLobby.path
                                          : AppRoute.guestLobby.path,
                                      arguments: {'roomCode': session.roomId},
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        );
                }),

                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    wide ? AppSpacing.xxl : AppSpacing.lg,
                    AppSpacing.lg,
                    wide ? AppSpacing.xxl : AppSpacing.lg,
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
              ],
            );
          },
        ),
      ),
    );
  }
}
