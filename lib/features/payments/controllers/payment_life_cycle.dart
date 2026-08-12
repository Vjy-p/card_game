import 'package:card_game/features/payments/controllers/payment_controller.dart';
import 'package:flutter/material.dart';

class PaymentLifecycleObserver with WidgetsBindingObserver {
  final PaymentController controller;

  PaymentLifecycleObserver(this.controller);

  void start() {
    WidgetsBinding.instance.addObserver(this);
  }

  void stop() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      controller.recoverPendingPayment();
    }
  }
}
