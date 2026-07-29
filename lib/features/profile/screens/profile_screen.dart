import 'package:card_game/core/services/common_services.dart';
import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/features/authentication/application/controllers/authentication_controller.dart';
import 'package:card_game/utils/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: () {
              openDeleteAlertBox();
            },
            icon: Icon(Icons.delete_outline_rounded, size: 20),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        physics: BouncingScrollPhysics(),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.backgroundSecondary,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),

              child: Text(CommonServices.getUserName()),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.backgroundSecondary,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                CommonServices.getEmail(),
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future openDeleteAlertBox() {
    final AuthenticationController authenticationController = Get.put(
      AuthenticationController(),
    );
    return Get.dialog(
      Dialog(
        child: Container(
          height: Get.height * 0.3,
          width: Get.width,
          decoration: BoxDecoration(
            color: AppColors.actionPrimaryForeground,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Delete Account ?', style: TextStyle(fontSize: 18)),
              Row(
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton.icon(
                    onPressed: authenticationController.isDeleteLoading.value
                        ? null
                        : () {
                            Get.back();
                          },
                    icon: const Icon(Icons.arrow_back),
                    label: Text('Cancel'),
                  ),
                  Obx(() {
                    return FilledButton.icon(
                      onPressed: authenticationController.isDeleteLoading.value
                          ? null
                          : () {
                              authenticationController.deleteAccount();
                            },
                      icon: const Icon(Icons.login),
                      label: authenticationController.isDeleteLoading.value
                          ? CustomLoading()
                          : Text('Delete'),
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
