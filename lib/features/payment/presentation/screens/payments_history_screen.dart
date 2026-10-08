import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/features/payment/controllers/payment_controller.dart';
import 'package:card_game/features/payment/presentation/widgets/payment_history_tile.dart';
import 'package:card_game/utils/custom_back_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentsHistoryScreen extends StatelessWidget {
  const PaymentsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<PaymentController>()
        ? Get.find<PaymentController>()
        : Get.put(PaymentController());

    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackButton(),
        centerTitle: false,
        title: const Text('History'),
      ),
      body: Obx(() {
        return controller.isHistoryLoading.value
            ? const Center(child: CircularProgressIndicator())
            : controller.isHistoryError.value
            ? Center(
                child: Column(
                  spacing: 30,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Something went wrong!',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    MaterialButton(
                      color: AppColors.darkBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(12),
                      ),
                      onPressed: () {
                        controller.getPaymentHistory();
                      },
                      child: const Text(
                        'Retry',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              )
            : listWidget(controller: controller);
      }),
    );
  }

  Widget listWidget({required PaymentController controller}) {
    return Obx(() {
      return controller.paymentHistoryList.isEmpty
          ? const Center(
              child: Text(
                'No Payments Yet!',
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : ListView.separated(
              itemCount: controller.paymentHistoryList.length,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              itemBuilder: (context, index) {
                return PaymentHistoryTile(
                  paymentDetails: controller.paymentHistoryList[index],
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            );
    });
  }
}
