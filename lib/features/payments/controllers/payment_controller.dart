import 'dart:async';
import 'dart:developer';

import 'package:card_game/core/services/common_services.dart';
import 'package:card_game/features/payments/models/payment_history_model.dart';
import 'package:card_game/features/payments/models/payment_model.dart';
import 'package:card_game/features/payments/models/payment_status.dart';
import 'package:card_game/features/payments/services/payment_repository.dart';
import 'package:card_game/features/payments/services/razorpay_services.dart';
import 'package:card_game/utils/constants/constants.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class PaymentController extends GetxController {
  PaymentController({
    PaymentRepository? repository,
    RazorpayService? razorpayService,
  }) : _repository = repository ?? PaymentRepository(),
       _razorpay = razorpayService ?? RazorpayService();

  final PaymentRepository _repository;
  final RazorpayService _razorpay;

  final Rx<PaymentStatus> status = PaymentStatus.created.obs;

  final RxBool loading = false.obs;

  final RxString errorMessage = ''.obs;

  final Rxn<PaymentModel> payment = Rxn<PaymentModel>();

  final RxnString currentPaymentId = RxnString();

  final RxnString currentOrderId = RxnString();

  StreamSubscription? _razorpaySubscription;

  StreamSubscription? _connectivitySubscription;

  final payments = <PaymentHistoryModel>[].obs;

  final isLoading = false.obs;
  final isLoadingMore = false.obs;

  final hasMore = true.obs;

  int page = 1;

  static const pageSize = 20;

  @override
  void onInit() {
    super.onInit();
    loadPayments();
    _razorpaySubscription = _razorpay.events.listen(_handleRazorpayEvent);

    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      _onConnectivityChanged,
    );
  }

  // ============================================================
  // START PAYMENT
  // ============================================================

  Future<void> pay() async {
    if (loading.value) {
      return;
    }

    errorMessage.value = '';
    loading.value = true;

    final int amount = 100; //1 rupee
    final String razorpayKey = Constants.razorpayTestKey;
    final String name = CommonServices.getUserName();
    final String email = CommonServices.getEmail();
    final String phone = '';

    try {
      final clientRequestId = const Uuid().v4();

      final response = await _repository.createPaymentOrder(
        amount: amount,
        clientRequestId: clientRequestId,
      );

      final paymentJson = Map<String, dynamic>.from(response['payment'] as Map);

      final paymentModel = PaymentModel.fromJson(paymentJson);

      payment.value = paymentModel;

      currentPaymentId.value = paymentModel.id;

      currentOrderId.value = paymentModel.razorpayOrderId;

      status.value = PaymentStatus.checkoutStarted;

      _razorpay.open(
        key: razorpayKey,
        orderId: paymentModel.razorpayOrderId!,
        amount: amount,
        name: name,
        email: email,
        phone: phone,
      );
    } catch (e, stackTree) {
      errorMessage.value = e.toString();
      status.value = PaymentStatus.failed;
      log('razorpay error $e $stackTree');
    } finally {
      loading.value = false;
    }
  }

  // ============================================================
  // RAZORPAY EVENTS
  // ============================================================

  Future<void> _handleRazorpayEvent(RazorpayEvent event) async {
    log('razorpay event $event');

    if (event is RazorpaySuccessEvent) {
      await _handleSuccess(event);
      return;
    }

    if (event is RazorpayFailureEvent) {
      await _handleFailure(event);
      return;
    }

    if (event is RazorpayExternalWalletEvent) {
      errorMessage.value =
          'External wallet selected: '
          '${event.walletName}';
    }
  }

  // ============================================================
  // SUCCESS CALLBACK
  // ============================================================

  Future<void> _handleSuccess(RazorpaySuccessEvent event) async {
    log('payment success ${event.signature}');
    final paymentId = currentPaymentId.value;

    if (paymentId == null) {
      return;
    }

    status.value = PaymentStatus.pending;

    try {
      final result = await _repository.verifyPayment(
        paymentId: paymentId,
        orderId: event.orderId!,
        razorpayPaymentId: event.paymentId,
        signature: event.signature!,
      );

      final serverStatus = result['status'];

      if (serverStatus == 'captured') {
        status.value = PaymentStatus.captured;

        await refreshStatus();
        return;
      }

      if (serverStatus == 'authorized') {
        status.value = PaymentStatus.authorized;

        await refreshStatus();
        return;
      }

      if (serverStatus == 'failed') {
        status.value = PaymentStatus.failed;

        return;
      }

      status.value = PaymentStatus.pending;
    } catch (e, stackTree) {
      log('error payment $e $stackTree');
      // VERY IMPORTANT:
      //
      // Verification request failed.
      //
      // We don't know whether payment succeeded.
      //
      // Do NOT mark failed.

      status.value = PaymentStatus.pending;

      errorMessage.value =
          'Payment submitted. '
          'We could not confirm the result.';
    }
  }

  // ============================================================
  // FAILURE CALLBACK
  // ============================================================

  Future<void> _handleFailure(RazorpayFailureEvent event) async {
    log('payment ${event.message}');
    final paymentId = currentPaymentId.value;

    if (paymentId == null) {
      status.value = PaymentStatus.failed;

      errorMessage.value = event.message ?? 'Payment failed';

      return;
    }

    // Do NOT blindly mark failed.
    //
    // Razorpay callback failure can happen because of
    // network/bank timeout.
    //
    // Ask server first.

    status.value = PaymentStatus.pending;

    try {
      await refreshStatus();

      if (status.value == PaymentStatus.captured ||
          status.value == PaymentStatus.authorized ||
          status.value == PaymentStatus.failed) {
        return;
      }
    } catch (e, stackTree) {
      log('error payment $e $stackTree');
      // Remain pending.
    }

    errorMessage.value = event.message ?? 'Payment status is being checked.';
  }

  // ============================================================
  // STATUS RECOVERY
  // ============================================================

  Future<void> refreshStatus() async {
    final paymentId = currentPaymentId.value;

    if (paymentId == null) {
      return;
    }

    try {
      final result = await _repository.getPaymentStatus(paymentId);

      payment.value = result;

      status.value = result.status;

      if (result.status == PaymentStatus.failed) {
        errorMessage.value = result.errorDescription ?? 'Payment failed';
      }
    } catch (e) {
      status.value = PaymentStatus.pending;

      errorMessage.value = 'Unable to check payment status.';
    }
  }

  // ============================================================
  // NETWORK RESTORED
  // ============================================================

  Future<void> _onConnectivityChanged(dynamic result) async {
    if (result is List && result.isEmpty) {
      return;
    }

    if (status.value == PaymentStatus.pending ||
        status.value == PaymentStatus.authorized) {
      await refreshStatus();
    }
  }

  // ============================================================
  // APP RESUME RECOVERY
  // ============================================================

  Future<void> recoverPendingPayment() async {
    if (status.value == PaymentStatus.pending ||
        status.value == PaymentStatus.authorized) {
      await refreshStatus();
    }
  }

  // ============================================================
  // SAFE RETRY
  // ============================================================

  Future<bool> canRetryPayment() async {
    await refreshStatus();

    return status.value == PaymentStatus.failed;
  }

  Future<void> loadPayments({bool refresh = true}) async {
    if (refresh) {
      page = 1;
      hasMore.value = true;
    }

    if (isLoading.value || isLoadingMore.value) {
      return;
    }

    if (!refresh && !hasMore.value) {
      return;
    }

    if (refresh) {
      isLoading.value = true;
    } else {
      isLoadingMore.value = true;
    }

    try {
      final result = await _repository.getPaymentHistory(
        page: page,
        limit: pageSize,
      );

      final newPayments = result.payments;

      if (refresh) {
        payments.assignAll(newPayments);
      } else {
        payments.addAll(newPayments);
      }

      hasMore.value = result.hasMore;

      if (newPayments.isNotEmpty) {
        page++;
      }
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  @override
  void onClose() {
    _razorpaySubscription?.cancel();
    _connectivitySubscription?.cancel();

    _razorpay.dispose();

    super.onClose();
  }
}
