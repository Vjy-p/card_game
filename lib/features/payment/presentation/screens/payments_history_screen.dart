import 'package:card_game/features/payment/controllers/payment_controller.dart';
import 'package:card_game/utils/custom_back_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentsHistoryScreen extends StatelessWidget {
  const PaymentsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final controller = Get.isRegistered<PaymentController>()
    //     ? Get.find<PaymentController>()
    //     : Get.put(PaymentController());

    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackButton(),
        centerTitle: false,
        title: const Text('History'),
      ),
      body: GetBuilder<PaymentController>(
        builder: (controller) {
          return const SizedBox();
        },
      ),
    );
  }
}
