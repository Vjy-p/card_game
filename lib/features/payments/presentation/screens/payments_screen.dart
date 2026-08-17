import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/core/theme/app_radius.dart';
import 'package:card_game/core/theme/app_spacing.dart';
import 'package:card_game/features/offline/presentation/widgets/user/action_bar/action_button.dart';
import 'package:card_game/features/payments/controllers/payment_controller.dart';
import 'package:card_game/features/payments/models/payment_history_model.dart';
import 'package:card_game/features/payments/models/payment_status.dart';
import 'package:card_game/utils/custom_back_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PaymentsScreen extends GetView<PaymentController> {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        bool isExit = false;
        if (controller.status.value == PaymentStatus.pending ||
            controller.status.value == PaymentStatus.refundPending ||
            controller.loading.value) {
          // isExit = await openExitDialog();
          isExit = false;
        } else {
          isExit = true;
        }
        if (isExit) {
          Get.back();
        }
        // final bool isExit = await openExitDialog();
        // if (isExit) {
        //   Get.back();
        // }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.backgroundSecondary,
          surfaceTintColor: AppColors.backgroundSecondary,
          leading: CustomBackButton(),
          title: Text('Payments'),
        ),
        backgroundColor: AppColors.backgroundSecondary,
        body: Obx(() {
          return controller.isLoading.value
              ? Center(child: CircularProgressIndicator.adaptive())
              : controller.payments.isEmpty
              ? Center(child: Text('No Payments Yet'))
              : ListView.separated(
                  itemCount: controller.payments.length,
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppRadius.md,
                  ),
                  itemBuilder: (context, index) {
                    final PaymentHistoryModel payment =
                        controller.payments[index];
                    return ExpansionTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(
                          AppRadius.card,
                        ),
                      ),
                      collapsedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(
                          AppRadius.card,
                        ),
                      ),
                      backgroundColor: AppColors.backgroundPrimary,
                      collapsedBackgroundColor: AppColors.backgroundPrimary,
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        spacing: AppSpacing.md,
                        children: [
                          Text(
                            payment.amountInRupees.toString(),
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              DateFormat(
                                'dd/MMM/yyyy',
                              ).format(payment.createdAt),
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      childrenPadding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.md,
                      ),
                      tilePadding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: 0,
                      ),
                      expandedAlignment: Alignment.centerLeft,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          spacing: AppSpacing.md,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Payment id :',
                                style: TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                payment.id,
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.xs,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            spacing: AppSpacing.md,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'Payment amount :',
                                  style: TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  payment.amountInRupees.toString(),
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          spacing: AppSpacing.md,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Razorpay id :',
                                style: TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 12,
                                  // fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                payment.razorpayPaymentId ?? '',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.xs,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            spacing: AppSpacing.md,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'Payment method :',
                                  style: TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  payment.paymentMethod ?? '',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          spacing: AppSpacing.md,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Payment receipt :',
                                style: TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                payment.receipt ?? '',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.xs,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            spacing: AppSpacing.md,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'Created at :',
                                  style: TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  DateFormat(
                                    'dd MMM yyyy',
                                  ).format(payment.createdAt),
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (payment.paidAt != null)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            spacing: AppSpacing.md,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'Paid at :',
                                  style: TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  DateFormat(
                                    'dd MMM yyyy',
                                  ).format(payment.paidAt!),
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          )
                        else if (payment.failedAt != null)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            spacing: AppSpacing.md,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'Failed at :',
                                  style: TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  DateFormat(
                                    'dd MMM yyyy',
                                  ).format(payment.failedAt!),
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        if (payment.errorReason != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.xs,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              spacing: AppSpacing.md,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Failed due to :',
                                    style: TextStyle(
                                      color: AppColors.textMuted,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    payment.errorReason ?? '',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.xs,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            spacing: AppSpacing.md,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'status :',
                                  style: TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  payment.status,
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(
                        //     vertical: AppSpacing.xs,
                        //   ),
                        //   child: Row(
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     spacing: AppSpacing.md,
                        //     children: [
                        //       Expanded(
                        //         flex: 2,
                        //         child: Text(
                        //           'Fullfilment status :',
                        //           style: TextStyle(
                        //             color: AppColors.textMuted,
                        //             fontSize: 12,
                        //           ),
                        //         ),
                        //       ),
                        //       Expanded(
                        //         flex: 3,
                        //         child: Text(
                        //           payment.fulfilmentStatus ?? '',
                        //           style: TextStyle(
                        //             color: AppColors.textSecondary,
                        //             fontSize: 12,
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // if (payment.errorDescription != null)
                        //   Row(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     spacing: AppSpacing.md,
                        //     children: [
                        //       Expanded(
                        //         flex: 2,
                        //         child: Text(
                        //           'Failed due to :',
                        //           style: TextStyle(
                        //             color: AppColors.textMuted,
                        //             fontSize: 12,
                        //           ),
                        //         ),
                        //       ),
                        //       Expanded(
                        //         flex: 3,
                        //         child: Text(
                        //           payment.errorDescription ?? '',
                        //           style: TextStyle(
                        //             color: AppColors.textSecondary,
                        //             fontSize: 12,
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: AppSpacing.xs);
                  },
                );
        }),
        bottomNavigationBar: BottomAppBar(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
          color: AppColors.backgroundSecondary,
          surfaceTintColor: AppColors.backgroundPrimary,
          height: 50,
          child: Obx(() {
            return FilledButton.tonal(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(AppColors.darkBlue),
              ),
              onPressed: controller.loading.value
                  ? null
                  : () {
                      controller.pay();
                    },
              child: controller.loading.value
                  ? CircularProgressIndicator.adaptive()
                  : Text('Pay'),
            );
          }),
        ),
      ),
    );
  }

  Future<bool> openExitDialog() async {
    return await Get.dialog(
      Dialog(
        backgroundColor: AppColors.backgroundSecondary,
        insetPadding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(AppRadius.card),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: AppSpacing.xxxl,
            children: [
              Text(
                'Are you sure to exit?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                spacing: AppSpacing.sm,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: ActionButton(
                      onPressed: () {
                        Get.back(result: false);
                      },
                      label: 'Cancel',
                      icon: Icon(Icons.arrow_back_ios_new, size: 18),
                    ),
                  ),
                  Expanded(
                    child: ActionButton(
                      onPressed: () async {
                        Get.back(result: true);
                        controller.status.value;
                      },
                      label: 'Exit',
                      icon: Icon(Icons.restart_alt, size: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
