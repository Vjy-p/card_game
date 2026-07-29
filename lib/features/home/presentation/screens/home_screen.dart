import 'package:card_game/core/router/app_route.dart';
import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/core/theme/app_spacing.dart';
import 'package:card_game/features/home/application/controllers/home_controller.dart';
import 'package:card_game/features/home/application/state/home_state.dart';
import 'package:card_game/features/home/presentation/widgets/home_side_panel.dart';
import 'package:card_game/features/home/presentation/widgets/primary_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/route_manager.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _handleAction(
    BuildContext context,
    WidgetRef ref,
    HomePrimaryAction action,
  ) {
    final controller = ref.read(homeControllerProvider.notifier);
    controller.beginAction(action);

    // if (action == HomePrimaryAction.playOnline) {
    //   controller.completeAction();
    //   context.goNamed(AppRoute.publicMatchmaking.name);
    //   return;
    // }

    // if (action == HomePrimaryAction.createPrivateTable) {
    //   controller.completeAction();
    //   context.goNamed(AppRoute.createPrivateTable.name);
    //   return;
    // }

    // if (action == HomePrimaryAction.joinTable) {
    //   controller.completeAction();
    //   context.goNamed(AppRoute.joinTable.name);
    //   return;
    // }

    if (action == HomePrimaryAction.playOffline) {
      controller.completeAction();
      Get.toNamed(AppRoute.offline.path);
      return;
    }

    // final message = switch (action) {
    //   HomePrimaryAction.playOnline => '',
    //   HomePrimaryAction.createPrivateTable => '',
    //   HomePrimaryAction.joinTable => '',
    //   HomePrimaryAction.playOffline => '',
    // };

    // ScaffoldMessenger.of(context)
    //   ..hideCurrentSnackBar()
    //   ..showSnackBar(SnackBar(content: Text(message)));
    controller.completeAction();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeControllerProvider);
    // final sessions = ref.watch(rejoinableSessionsProvider);

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
                // sessions.when(
                //   loading: () =>
                //       const SliverToBoxAdapter(child: SizedBox.shrink()),
                //   error: (_, _) =>
                //       const SliverToBoxAdapter(child: SizedBox.shrink()),
                //   data: (items) => items.isEmpty
                //       ? const SliverToBoxAdapter(child: SizedBox.shrink())
                //       : SliverPadding(
                //           padding: EdgeInsets.symmetric(
                //             horizontal: wide ? AppSpacing.xxl : AppSpacing.lg,
                //           ),
                //           sliver: SliverToBoxAdapter(
                //             child: Card(
                //               child: ListTile(
                //                 leading: const Icon(
                //                   Icons.restore_rounded,
                //                   color: AppColors.actionPrimary,
                //                 ),
                //                 title: Text(
                //                   items.first.status == 'playing'
                //                       ? 'Resume ${items.first.tableName}'
                //                       : 'Return to ${items.first.tableName}',
                //                 ),
                //                 subtitle: Text(
                //                   items.first.status == 'playing'
                //                       ? 'Your active game is waiting.'
                //                       : 'Your lobby is still active.',
                //                 ),
                //                 trailing: const Icon(
                //                   Icons.chevron_right_rounded,
                //                 ),
                //                 onTap: () async {
                //                   final session = items.first;
                //                   await ref
                //                       .read(
                //                         roomLobbyControllerProvider.notifier,
                //                       )
                //                       .resumeRoom(session.roomId);
                //                   if (!context.mounted) return;
                //                   if (session.status == 'playing') {
                //                     context.goNamed(
                //                       AppRoute.gameTable.name,
                //                       pathParameters: {
                //                         'gameId': session.roomId,
                //                       },
                //                     );
                //                   } else {
                //                     context.goNamed(
                //                       session.isHost
                //                           ? AppRoute.hostLobby.name
                //                           : AppRoute.guestLobby.name,
                //                       pathParameters: {
                //                         'roomCode': session.roomId,
                //                       },
                //                     );
                //                   }
                //                 },
                //               ),
                //             ),
                //           ),
                //         ),
                // ),
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
                                      state: state,
                                      onAction: (action) =>
                                          _handleAction(context, ref, action),
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
                                    state: state,
                                    onAction: (action) =>
                                        _handleAction(context, ref, action),
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
