import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/core/theme/app_radius.dart';
import 'package:card_game/core/theme/app_spacing.dart';
import 'package:card_game/features/online/room/controllers/join_table_controller.dart';
import 'package:card_game/features/online/room/controllers/room_controller.dart';
import 'package:card_game/utils/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class JoinTableScreen extends GetView<RoomController> {
  const JoinTableScreen({super.key, this.inviteToken});

  final String? inviteToken;

  @override
  Widget build(BuildContext context) {
    final formController = Get.find<JoinTableController>();

    return Obx(() {
      final loading = controller.isLoading.value;
      final error = controller.errorMessage.value;

      return Scaffold(
        appBar: AppBar(title: const Text('Join Table')),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  decoration: BoxDecoration(
                    color: AppColors.surfacePrimary,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Form(
                    key: formController.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Icon(
                          Icons.login_rounded,
                          size: 52,
                          color: AppColors.actionPrimary,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          inviteToken == null
                              ? 'Join a private table'
                              : 'Accept private invitation',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          inviteToken == null
                              ? 'Enter the character room code shared by the host.'
                              : 'Enter your display name to join this invited table.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        TextFormField(
                          controller: formController.nameController,
                          enabled: !loading,
                          autofocus: true,
                          maxLength: 40,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Display name',
                            counterText: '',
                            prefixIcon: Icon(Icons.person_outline_rounded),
                          ),
                          validator: (value) {
                            final name = value?.trim() ?? '';
                            if (name.isEmpty) {
                              return 'Enter your display name.';
                            }
                            if (name.length > 24) {
                              return 'Use 24 characters or fewer.';
                            }
                            return null;
                          },
                        ),
                        if (inviteToken == null) ...[
                          const SizedBox(height: AppSpacing.md),
                          TextFormField(
                            controller: formController.codeController,
                            enabled: !loading,
                            maxLength: 10,
                            textCapitalization: TextCapitalization.characters,
                            textInputAction: TextInputAction.done,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp('[a-zA-Z0-9]'),
                              ),
                              LengthLimitingTextInputFormatter(10),
                            ],
                            decoration: const InputDecoration(
                              labelText: 'Room code',
                              hintText: 'ABC123',
                              prefixIcon: Icon(Icons.key_rounded),
                              counterText: '',
                            ),
                            validator: (value) {
                              if ((value?.trim().length ?? 0) == 0) {
                                return 'Enter the character room code.';
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) async {
                              if (!loading) {
                                await controller.joinRoom(
                                  joinCode: formController.roomCode,
                                  displayName: formController.displayName,
                                );
                              }
                            },
                          ),
                        ],
                        // if (error != null) ...[
                        //   const SizedBox(height: AppSpacing.md),
                        //   _BackendError(message: error),
                        // ],
                        const SizedBox(height: AppSpacing.xl),
                        FilledButton.icon(
                          onPressed: loading
                              ? null
                              : () async {
                                  await controller.joinRoom(
                                    joinCode: formController.roomCode,
                                    displayName: formController.displayName,
                                  );
                                },
                          icon: loading
                              ? const CustomLoading(
                                  dimension: 18,
                                  strokeWidth: 2,
                                )
                              : const Icon(Icons.login_rounded),
                          label: Text(
                            loading ? 'Joining table…' : 'Join Table',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _BackendError extends StatelessWidget {
  const _BackendError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
        ),
      ),
    );
  }
}
