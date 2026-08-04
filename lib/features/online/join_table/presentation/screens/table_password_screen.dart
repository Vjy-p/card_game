import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/core/theme/app_radius.dart';
import 'package:card_game/core/theme/app_spacing.dart';
import 'package:card_game/features/online/join_table/application/controllers/table_password_controller.dart';
import 'package:card_game/utils/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class TablePasswordScreen extends StatefulWidget {
  const TablePasswordScreen({required this.roomCode, super.key});

  final String roomCode;

  @override
  State<TablePasswordScreen> createState() => _TablePasswordScreenState();
}

class _TablePasswordScreenState extends State<TablePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TablePasswordController>(
      init: TablePasswordController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(title: const Text('Table Password')),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth >= 840;

                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: wide ? AppSpacing.xxl : AppSpacing.lg,
                    vertical: AppSpacing.xl,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 560),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Icon(
                              Icons.lock_outline_rounded,
                              size: 56,
                              color: AppColors.actionPrimary,
                              semanticLabel: 'Password protected table',
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Text(
                              'This table is protected',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              'Enter the password shared by the host to continue to ${widget.roomCode}.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            Container(
                              padding: const EdgeInsets.all(AppSpacing.lg),
                              decoration: BoxDecoration(
                                color: AppColors.surfacePrimary,
                                borderRadius: BorderRadius.circular(
                                  AppRadius.lg,
                                ),
                                border: Border.all(
                                  color: AppColors.borderSubtle,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  TextFormField(
                                    enabled: !controller
                                        .tablePasswordState
                                        .isSubmitting,
                                    autofocus: true,
                                    obscureText: !_passwordVisible,
                                    textInputAction: TextInputAction.done,
                                    autofillHints: const [
                                      AutofillHints.password,
                                    ],
                                    onChanged: controller.setPassword,
                                    onFieldSubmitted: (_) =>
                                        controller.tablePasswordState.canSubmit
                                        ? () async {
                                            if (_formKey.currentState
                                                    ?.validate() ==
                                                true) {
                                              await controller.submit();
                                            }
                                          }
                                        : null,
                                    decoration: InputDecoration(
                                      labelText: 'Table password',
                                      border: const OutlineInputBorder(),
                                      suffixIcon: IconButton(
                                        tooltip: _passwordVisible
                                            ? 'Hide password'
                                            : 'Show password',
                                        onPressed:
                                            controller
                                                .tablePasswordState
                                                .isSubmitting
                                            ? null
                                            : () => setState(
                                                () => _passwordVisible =
                                                    !_passwordVisible,
                                              ),
                                        icon: Icon(
                                          _passwordVisible
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined,
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if ((value ?? '').isEmpty) {
                                        return 'Enter the table password.';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: AppSpacing.md),
                                  FilledButton.icon(
                                    onPressed:
                                        controller.tablePasswordState.canSubmit
                                        ? () async {
                                            if (_formKey.currentState
                                                    ?.validate() ==
                                                true) {
                                              await controller.submit();
                                            }
                                          }
                                        : null,
                                    icon:
                                        controller
                                            .tablePasswordState
                                            .isSubmitting
                                        ? const SizedBox.square(
                                            dimension: 18,
                                            child: CustomLoading(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Icon(Icons.lock_open_rounded),
                                    label: Text(
                                      controller.tablePasswordState.isSubmitting
                                          ? 'Verifying…'
                                          : 'Join Table',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Semantics(
                              container: true,
                              label: 'Password security information',
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.shield_outlined,
                                    color: AppColors.actionPrimary,
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Expanded(
                                    child: Text(
                                      'The password is sent only to the secure server for verification. The client never decides whether it is correct.',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
