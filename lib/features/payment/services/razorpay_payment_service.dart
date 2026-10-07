import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:card_game/features/payment/models/coin_package.dart';
import 'package:card_game/features/payment/models/payment_result.dart';
import 'package:card_game/utils/constants/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

abstract class IRazorpayPaymentService {
  Future<void> initialize();
  void dispose();
  Future<PaymentResult> openCheckout({
    required CoinPackage package,
    required String customerEmail,
    String? customerContact,
  });
}

class RazorpayPaymentService implements IRazorpayPaymentService {
  Razorpay? _razorpay;
  Completer<PaymentResult>? _pendingCompleter;
  bool _initialized = false;
  String? _currentDbPaymentId;
  String? _currentOrderId;

  @override
  Future<void> initialize() async {
    if (_initialized || kIsWeb || Get.testMode) {
      return;
    }
    try {
      _razorpay = Razorpay();
      _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
      _initialized = true;
      log('[Razorpay] Initialized successfully');
    } catch (e) {
      log('[Razorpay] Initialization error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    log('[Razorpay] Payment Success: paymentId=${response.paymentId}, orderId=${response.orderId}');

    if (_currentDbPaymentId != null && response.signature != null) {
      try {
        final verifyResponse = await Supabase.instance.client.functions.invoke(
          'verify-payment',
          body: {
            'payment_id': _currentDbPaymentId,
            'order_id': response.orderId ?? _currentOrderId,
            'razorpay_payment_id': response.paymentId,
            'razorpay_signature': response.signature,
          },
        );

        final dynamic data = verifyResponse.data is String
            ? jsonDecode(verifyResponse.data as String)
            : verifyResponse.data;

        if (data is Map && data['error'] != null) {
          log('[Razorpay] Verification rejected: ${data['error']}');
          if (_pendingCompleter != null && !_pendingCompleter!.isCompleted) {
            _pendingCompleter!.complete(PaymentResult.failure(
              errorMessage: 'Payment verification failed: ${data['error']}',
            ));
            return;
          }
        }
        log('[Razorpay] Payment verified successfully: $data');
      } catch (e) {
        log('[Razorpay] Error calling verify-payment edge function: $e');
      }
    }

    if (_pendingCompleter != null && !_pendingCompleter!.isCompleted) {
      _pendingCompleter!.complete(PaymentResult.success(
        paymentId: response.paymentId ?? '',
        orderId: response.orderId ?? _currentOrderId,
        signature: response.signature,
      ));
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    log('[Razorpay] Payment Error: code=${response.code}, message=${response.message}');
    if (_pendingCompleter != null && !_pendingCompleter!.isCompleted) {
      if (response.code == Razorpay.PAYMENT_CANCELLED) {
        _pendingCompleter!.complete(PaymentResult.cancelled(
          message: response.message ?? 'Payment cancelled by user',
        ));
      } else {
        _pendingCompleter!.complete(PaymentResult.failure(
          errorMessage: response.message ?? 'Payment failed',
          errorCode: response.code,
        ));
      }
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    log('[Razorpay] External Wallet Selected: ${response.walletName}');
    if (_pendingCompleter != null && !_pendingCompleter!.isCompleted) {
      _pendingCompleter!.complete(PaymentResult.success(
        paymentId: 'wallet_${response.walletName ?? "external"}',
      ));
    }
  }

  @override
  Future<PaymentResult> openCheckout({
    required CoinPackage package,
    required String customerEmail,
    String? customerContact,
  }) async {
    if (Get.testMode) {
      return PaymentResult.success(
        paymentId: 'pay_test_${const Uuid().v4()}',
        orderId: 'order_test_${const Uuid().v4()}',
      );
    }

    if (kIsWeb) {
      return PaymentResult.failure(
        errorMessage: 'Razorpay checkout is currently supported on mobile platforms.',
      );
    }

    if (!_initialized) {
      await initialize();
    }

    // Cancel any previous pending checkout attempt
    if (_pendingCompleter != null && !_pendingCompleter!.isCompleted) {
      _pendingCompleter!.complete(PaymentResult.cancelled(
        message: 'Superseded by new payment request',
      ));
    }

    _pendingCompleter = Completer<PaymentResult>();
    _currentDbPaymentId = null;
    _currentOrderId = null;

    final clientRequestId = const Uuid().v4();

    // Invoke create-payment-order edge function
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        final response = await Supabase.instance.client.functions.invoke(
          'create-payment-order',
          body: {
            'amount': package.amountInPaise,
            'client_request_id': clientRequestId,
            'package_id': package.id,
            'coins': package.coins,
          },
        );

        if (response.status == 200 && response.data != null) {
          final dynamic data = response.data is String
              ? jsonDecode(response.data as String)
              : response.data;
          if (data is Map && data['payment'] != null) {
            final paymentData = data['payment'] as Map;
            _currentDbPaymentId = paymentData['id']?.toString();
            _currentOrderId = paymentData['razorpay_order_id']?.toString();
          }
        }
      }
    } catch (e) {
      log('[Razorpay] Edge function create-payment-order error: $e. Proceeding with standard checkout.');
    }

    final options = <String, dynamic>{
      'key': Constants.razorpayKey,
      'amount': package.amountInPaise,
      'name': 'Card Game Store',
      'description': '${package.title} - ${package.coins} Coins',
      'currency': package.currency,
      'prefill': {
        'email': customerEmail,
        if (customerContact != null && customerContact.isNotEmpty)
          'contact': customerContact,
      },
      'notes': {
        'package_id': package.id,
        'coins': package.coins.toString(),
        'client_request_id': clientRequestId,
      },
      'theme': {
        'color': '#3395FF',
      },
      if (_currentOrderId != null && _currentOrderId!.isNotEmpty)
        'order_id': _currentOrderId,
    };

    try {
      _razorpay?.open(options);
    } catch (e) {
      log('[Razorpay] Open checkout exception: $e');
      if (!_pendingCompleter!.isCompleted) {
        _pendingCompleter!.complete(PaymentResult.failure(errorMessage: e.toString()));
      }
    }

    return _pendingCompleter!.future;
  }

  @override
  void dispose() {
    _razorpay?.clear();
    _initialized = false;
  }
}
