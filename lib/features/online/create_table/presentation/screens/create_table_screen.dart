import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/core/theme/app_radius.dart';
import 'package:card_game/core/theme/app_spacing.dart';
import 'package:card_game/features/online/create_table/controller/create_table_controller.dart';
import 'package:card_game/features/online/room/controllers/room_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateTableScreen extends GetView<RoomController> {
  const CreateTableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final form = Get.find<CreateTableController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Create Table')),
      body: Obx(() {
        return IgnorePointer(
          ignoring: controller.isLoading.value,
          child: Form(
            key: form.formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.md,
              ),
              child: Column(
                spacing: AppSpacing.lg,
                children: [
                  TextFormField(
                    controller: form.displayNameController,
                    focusNode: form.displayFocus.value,
                    maxLength: 40,
                    onEditingComplete: () {
                      form.nextFocus(
                        currentFocus: form.displayFocus,
                        nextFocus: form.tableFocus,
                      );
                    },
                    onFieldSubmitted: (value) {
                      form.nextFocus(
                        currentFocus: form.displayFocus,
                        nextFocus: form.tableFocus,
                      );
                    },
                    onTapOutside: (event) {
                      form.nextFocus(
                        currentFocus: form.displayFocus,
                        nextFocus: form.tableFocus,
                      );
                    },
                    decoration: InputDecoration(
                      enabled: true,
                      isDense: true,
                      label: Text('Display Name'),
                      hint: Text('Enter Display Name'),
                      prefixIcon: Icon(
                        Icons.label,
                        color: AppColors.textSecondary,
                      ),
                      counterText: '',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        borderSide: BorderSide(
                          color: AppColors.lightTextSecondary,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        borderSide: BorderSide(
                          color: AppColors.lightTextSecondary,
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        borderSide: BorderSide(
                          color: AppColors.lightTextSecondary,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        borderSide: BorderSide(color: AppColors.actionPrimary),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        borderSide: BorderSide(color: AppColors.actionPrimary),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        borderSide: BorderSide(color: AppColors.error),
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: form.tableNameController,
                    focusNode: form.tableFocus.value,
                    maxLength: 100,
                    onEditingComplete: () {
                      form.nextFocus(
                        currentFocus: form.tableFocus,
                        nextFocus: form.maxPlayersFocus,
                      );
                    },
                    onFieldSubmitted: (value) {
                      form.nextFocus(
                        currentFocus: form.tableFocus,
                        nextFocus: form.maxPlayersFocus,
                      );
                    },
                    onTapOutside: (event) {
                      form.nextFocus(
                        currentFocus: form.tableFocus,
                        nextFocus: form.maxPlayersFocus,
                      );
                    },
                    decoration: InputDecoration(
                      enabled: true,
                      isDense: true,
                      label: Text('Table Name'),
                      hint: Text('Enter Table Name'),
                      prefixIcon: Icon(
                        Icons.label,
                        color: AppColors.textSecondary,
                      ),
                      counterText: '',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        borderSide: BorderSide(
                          color: AppColors.lightTextSecondary,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        borderSide: BorderSide(
                          color: AppColors.lightTextSecondary,
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        borderSide: BorderSide(
                          color: AppColors.lightTextSecondary,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        borderSide: BorderSide(color: AppColors.actionPrimary),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        borderSide: BorderSide(color: AppColors.actionPrimary),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        borderSide: BorderSide(color: AppColors.error),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Table name is required';
                      }

                      return null;
                    },
                  ),

                  DropdownButtonFormField(
                    focusNode: form.maxPlayersFocus.value,
                    initialValue: form.maxPlayers.value,
                    items: form.maxPlayersList
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text('$e players'),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        form.changeMaxPlayer(v);
                      }
                      form.nextFocus(currentFocus: form.maxPlayersFocus);
                    },
                    isDense: true,
                    decoration: InputDecoration(
                      enabled: true,
                      isDense: true,
                      labelText: 'Maximum players',
                      hint: Text(
                        form.maxPlayers.value == 4
                            ? '4 players'
                            : 'Maximum: ${form.maxPlayers.value} players',
                      ),
                      prefixIcon: Icon(
                        Icons.groups_rounded,
                        color: AppColors.textSecondary,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        borderSide: BorderSide(
                          color: AppColors.lightTextSecondary,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        borderSide: BorderSide(
                          color: AppColors.lightTextSecondary,
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        borderSide: BorderSide(
                          color: AppColors.lightTextSecondary,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        borderSide: BorderSide(color: AppColors.actionPrimary),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        borderSide: BorderSide(color: AppColors.actionPrimary),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        borderSide: BorderSide(color: AppColors.error),
                      ),
                    ),
                  ),

                  Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      if (!form.validate()) return;

                      await controller.createTable(
                        displayName: form.displayNameController.text.trim(),
                        tableName: form.tableNameController.text.trim(),
                        maxPlayers: form.maxPlayers.value,
                        visibility:
                            form.visibility.value == TableVisibility.publicTable
                            ? 'public'
                            : 'private',
                      );
                    },
                    child: controller.isLoading.value
                        ? CircularProgressIndicator.adaptive()
                        : const Text('Create'),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
