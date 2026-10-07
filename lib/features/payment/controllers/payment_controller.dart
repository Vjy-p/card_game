import 'dart:developer';

import 'package:card_game/core/services/common_services.dart';
import 'package:card_game/features/payment/models/coin_package.dart';
import 'package:card_game/features/payment/models/payment_result.dart';
import 'package:card_game/features/payment/models/payment_state_machine.dart';
import 'package:card_game/features/payment/models/payment_status.dart';
import 'package:card_game/features/payment/services/razorpay_payment_service.dart';
import 'package:card_game/features/profile/controllers/profile_controller.dart';
import 'package:card_game/utils/custom_toast.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PaymentController extends GetxController {
  PaymentController({IRazorpayPaymentService? paymentService})
      : _paymentService = paymentService ?? RazorpayPaymentService();

  final IRazorpayPaymentService _paymentService;
  final PaymentStateMachine stateMachine = PaymentStateMachine();

  late final Rx<PaymentStatus> status;
  final RxList<CoinPackage> packages = CoinPackage.defaultPackages.obs;
  final Rx<CoinPackage?> selectedPackage = Rx<CoinPackage?>(null);
  final RxBool isProcessing = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt userCoins = 0.obs;

  SupabaseClient get _supabase => Supabase.instance.client;

  @override
  void onInit() {
    super.onInit();
    status = stateMachine.state.obs;
    if (packages.isNotEmpty) {
      selectedPackage.value = packages[1]; // Select popular Bronze package by default
    }
    _paymentService.initialize();
    loadUserCoins();
  }

  @override
  void onClose() {
    _paymentService.dispose();
    super.onClose();
  }

  void selectPackage(CoinPackage package) {
    selectedPackage.value = package;
  }

  Future<void> loadUserCoins() async {
    final userId = CommonServices.getUserId();
    if (userId.isEmpty || Get.testMode) {
      userCoins.value = 1000;
      return;
    }

    try {
      final response = await _supabase
          .from('profiles')
          .select('coins')
          .eq('id', userId)
          .maybeSingle();

      if (response != null && response['coins'] != null) {
        userCoins.value = (response['coins'] as num).toInt();
      }
    } catch (e) {
      log('[PaymentController] Error loading coins: $e');
    }
  }

  Future<PaymentResult> buyPackage(CoinPackage package) async {
    if (isProcessing.value) {
      return PaymentResult.failure(errorMessage: 'A purchase is already in progress.');
    }

    isProcessing.value = true;
    errorMessage.value = '';

    stateMachine.transition(PaymentStatus.checkoutStarted);
    status.value = stateMachine.state;

    try {
      final userEmail = CommonServices.getEmail().isNotEmpty
          ? CommonServices.getEmail()
          : 'player@cardgame.com';

      stateMachine.transition(PaymentStatus.pending);
      status.value = stateMachine.state;

      // Open Razorpay Checkout modal
      final result = await _paymentService.openCheckout(
        package: package,
        customerEmail: userEmail,
      );

      if (result.isSuccess) {
        stateMachine.transition(PaymentStatus.captured);
        status.value = stateMachine.state;

        // Credit coins
        await _creditCoins(package.coins);
        customToast(message: 'Successfully purchased ${package.coins} coins!');
        return result;
      } else if (result.isCancelled) {
        stateMachine.transition(PaymentStatus.cancelled);
        status.value = stateMachine.state;
        customToast(message: 'Purchase was cancelled.');
        return result;
      } else {
        stateMachine.transition(PaymentStatus.failed);
        status.value = stateMachine.state;
        errorMessage.value = result.errorMessage ?? 'Payment failed.';
        customToast(message: errorMessage.value);
        return result;
      }
    } catch (e) {
      log('[PaymentController] Error during purchase: $e');
      stateMachine.transition(PaymentStatus.failed);
      status.value = stateMachine.state;
      errorMessage.value = e.toString();
      customToast(message: 'Payment error occurred.');
      return PaymentResult.failure(errorMessage: e.toString());
    } finally {
      isProcessing.value = false;
    }
  }

  Future<void> _creditCoins(int coinsToAdd) async {
    final userId = CommonServices.getUserId();

    if (userId.isEmpty || Get.testMode) {
      userCoins.value += coinsToAdd;
      return;
    }

    final previousCoins = userCoins.value;
    // Reload coins from database (credited by verify-payment or razorpay-webhook)
    await loadUserCoins();

    // If database coin count didn't increase (e.g. edge function bypassed or webhook delayed), update profiles directly
    if (userCoins.value <= previousCoins) {
      try {
        final newBalance = previousCoins + coinsToAdd;
        await _supabase
            .from('profiles')
            .update({'coins': newBalance})
            .eq('id', userId);
        userCoins.value = newBalance;
      } catch (e) {
        log('[PaymentController] Error crediting coins in database: $e');
      }
    }

    // If ProfileController is active, refresh its details
    if (Get.isRegistered<ProfileController>()) {
      Get.find<ProfileController>().getUserDetails();
    }
  }
}
