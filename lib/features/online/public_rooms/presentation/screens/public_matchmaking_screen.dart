import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/core/theme/app_spacing.dart';
import 'package:card_game/features/online/room/controllers/room_controller.dart';
import 'package:card_game/features/online/room/models/online_table_entities.dart';
import 'package:card_game/utils/custom_loading.dart';
import 'package:card_game/utils/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PublicMatchmakingScreen extends StatefulWidget {
  const PublicMatchmakingScreen({super.key});

  @override
  State<PublicMatchmakingScreen> createState() =>
      _PublicMatchmakingScreenState();
}

class _PublicMatchmakingScreenState extends State<PublicMatchmakingScreen> {
  final _nameController = TextEditingController();
  final _roomController = Get.find<RoomController>();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool _validateName() {
    final name = _nameController.text.trim();
    if (name.isNotEmpty && name.length <= 24) return true;
    customToast(message: 'Enter a display name of 1–24 characters.');
    return false;
  }

  // Future<void> _quickMatch() async {
  //   if (!_validateName()) return;
  //   await _roomController.joinMatchmaking(
  //     displayName: _nameController.text.trim(),
  //     maxPlayers: _maxPlayers,
  //   );
  // }

  Future<void> _join(PublicTableSummary table) async {
    if (!_validateName()) return;
    await _roomController.joinPublicTable(
      roomId: table.roomId,
      displayName: _nameController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Play Online')),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _roomController.getPublicRooms(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Text(
                  'Find a table',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Join the oldest compatible quick-match room, or choose an open public table.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Obx(() {
                  return TextField(
                    controller: _nameController,
                    enabled: !_roomController.isLoading.value,
                    maxLength: 24,
                    decoration: const InputDecoration(
                      labelText: 'Display name',
                      prefixIcon: Icon(Icons.person_outline_rounded),
                      counterText: '',
                    ),
                  );
                }),
                const SizedBox(height: AppSpacing.md),
                // DropdownButtonFormField<int>(
                //   initialValue: _maxPlayers,
                //   decoration: const InputDecoration(
                //     labelText: 'Quick match table size',
                //     prefixIcon: Icon(Icons.groups_rounded),
                //   ),
                //   items: [2, 3, 4, 5, 6, 7, 8, 9, 10]
                //       .map(
                //         (value) => DropdownMenuItem(
                //           value: value,
                //           child: Text('$value players'),
                //         ),
                //       )
                //       .toList(),
                //   onChanged: lobby.isLoading
                //       ? null
                //       : (value) => setState(() => _maxPlayers = value ?? 4),
                // ),
                // const SizedBox(height: AppSpacing.md),
                // FilledButton.icon(
                //   onPressed: lobby.isLoading ? null : _quickMatch,
                //   icon: lobby.isLoading
                //       ? const CustomLoading(dimension: 18, strokeWidth: 2)
                //       : const Icon(Icons.bolt_rounded),
                //   label: Text(lobby.isLoading ? 'Joining…' : 'Quick Match'),
                // ),
                // if (lobby.errorMessage != null) ...[
                //   const SizedBox(height: AppSpacing.md),
                //   Text(
                //     lobby.errorMessage!,
                //     style: TextStyle(color: Theme.of(context).colorScheme.error),
                //   ),
                // ],
                const SizedBox(height: AppSpacing.xl),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Open public tables',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Refresh tables',
                      onPressed: () => _roomController.getPublicRooms(),
                      icon: const Icon(Icons.refresh_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Obx(() {
                  return _roomController.isLoading.value
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.all(AppSpacing.xl),
                            child: CustomLoading(),
                          ),
                        )
                      : SizedBox();
                }),
                Obx(() {
                  return _roomController.errorMessage.isNotEmpty == true
                      ? _MessageCard(
                          message: 'Could not load public tables.',
                          actionLabel: 'Retry',
                          onAction: () => _roomController.getPublicRooms(),
                        )
                      : SizedBox();
                }),
                Obx(() {
                  return !_roomController.isLoading.value
                      ? ListView.separated(
                          shrinkWrap: true,
                          itemCount: _roomController.publicTables.length,
                          physics: NeverScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          itemBuilder: (context, index) {
                            final table = _roomController.publicTables[index];
                            return Card(
                              child: ListTile(
                                leading: const CircleAvatar(
                                  child: Icon(Icons.public_rounded),
                                ),
                                title: Text(table.tableName),
                                subtitle: Text(
                                  '${table.playerCount} / ${table.maxPlayers} players',
                                ),
                                trailing: FilledButton.tonal(
                                  onPressed: _roomController.isLoading.value
                                      ? null
                                      : () => _join(table),
                                  child: const Text('Join'),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(height: AppSpacing.md);
                          },
                        )
                      : SizedBox();
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({required this.message, this.actionLabel, this.onAction});
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          Text(message, textAlign: TextAlign.center),
          if (onAction != null) ...[
            const SizedBox(height: AppSpacing.md),
            OutlinedButton(
              onPressed: onAction,
              child: Text(actionLabel ?? 'Retry'),
            ),
          ],
        ],
      ),
    ),
  );
}
