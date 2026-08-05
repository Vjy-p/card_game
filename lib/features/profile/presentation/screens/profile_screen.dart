import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/core/theme/app_spacing.dart';
import 'package:card_game/features/authentication/controllers/authentication_controller.dart';
import 'package:card_game/features/profile/controllers/profile_controller.dart';
import 'package:card_game/features/profile/presentation/widgets/profile_row_widget.dart';
import 'package:card_game/features/profile/presentation/widgets/profile_widget.dart';
import 'package:card_game/utils/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            actions: [
              IconButton(
                onPressed: () {
                  openLogOutAlertBox();
                },
                icon: Icon(Icons.logout, size: 20),
              ),
              IconButton(
                onPressed: () {
                  openDeleteAlertBox();
                },
                icon: Icon(Icons.delete_outline_rounded, size: 20),
              ),
            ],
          ),
          body: controller.isLoading
              ? Center(child: CircularProgressIndicator())
              : controller.error
              ? Center(
                  child: Column(
                    spacing: AppSpacing.lg,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Something went wrong'),
                      FilledButton.icon(
                        onPressed: () {
                          controller.getUserDetails();
                        },
                        label: Text('Retry'),
                        icon: Icon(Icons.restore),
                      ),
                    ],
                  ),
                )
              : Align(
                  alignment: AlignmentGeometry.topCenter,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.md,
                    ),
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      spacing: AppSpacing.lg,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ProfileWidget(
                          name: controller.userDetails?.displayName ?? '',
                          profilePath: controller.userDetails?.photoUrl ?? '',
                        ),
                        ProfileRowWidget(
                          label: 'Email',
                          value: controller.userDetails?.email ?? '',
                        ),
                        ProfileRowWidget(
                          label: 'Played',
                          value:
                              controller.userDetails?.gamesPlayed?.toString() ??
                              '',
                        ),
                        ProfileRowWidget(
                          label: 'Won',
                          value:
                              controller.userDetails?.gamesWon?.toString() ??
                              '',
                        ),
                        ProfileRowWidget(
                          label: 'First Place',
                          value:
                              controller.userDetails?.firstPlace?.toString() ??
                              '',
                        ),
                        ProfileRowWidget(
                          label: 'Second Place',
                          value:
                              controller.userDetails?.secondPlace?.toString() ??
                              '',
                        ),
                        ProfileRowWidget(
                          label: 'Third Place',
                          value:
                              controller.userDetails?.thirdPlace?.toString() ??
                              '',
                        ),
                        ProfileRowWidget(
                          label: 'Total Score',
                          value:
                              controller.userDetails?.totalScore?.toString() ??
                              '',
                        ),
                        // ProfileRowWidget(
                        //   label: 'Total Points',
                        //   value:
                        //       controller.userDetails?.totalPoints?.toString() ??
                        //       '',
                        // ),
                        ProfileRowWidget(
                          label: 'Win Streak',
                          value:
                              controller.userDetails?.currentWinStreak
                                  ?.toString() ??
                              '',
                        ),
                        ProfileRowWidget(
                          label: 'Longest Win Streak',
                          value:
                              controller.userDetails?.longestWinStreak
                                  ?.toString() ??
                              '',
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Future openLogOutAlertBox() {
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
              Text('Are you sure to Logout?', style: TextStyle(fontSize: 18)),
              Row(
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton.icon(
                    onPressed: authenticationController.isButtonLoading.value
                        ? null
                        : () {
                            Get.back();
                          },
                    icon: const Icon(Icons.arrow_back),
                    label: Text('Cancel'),
                  ),
                  Obx(() {
                    return FilledButton.icon(
                      iconAlignment: IconAlignment.end,
                      onPressed: authenticationController.isButtonLoading.value
                          ? null
                          : () {
                              authenticationController.logout();
                            },
                      icon: const Icon(Icons.logout),
                      label: authenticationController.isButtonLoading.value
                          ? CustomLoading()
                          : Text('Logout'),
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
                    onPressed: authenticationController.isButtonLoading.value
                        ? null
                        : () {
                            Get.back();
                          },
                    icon: const Icon(Icons.arrow_back),
                    label: Text('Cancel'),
                  ),
                  Obx(() {
                    return FilledButton.icon(
                      onPressed: authenticationController.isButtonLoading.value
                          ? null
                          : () {
                              authenticationController.deleteAccount();
                            },
                      icon: const Icon(Icons.delete),
                      label: authenticationController.isButtonLoading.value
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
