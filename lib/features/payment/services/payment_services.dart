import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:card_game/features/payment/models/coin_package.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class PaymentServices {
  PaymentServices._internal();

  static final PaymentServices _instance = PaymentServices._internal();

  // Factory returns the same instance every time
  factory PaymentServices() => _instance;

  Future verifyPayment({
    required String currentDbPaymentId,
    required String orderId,
    required String paymentId,
    required String signature,
  }) async {
    try {
      final verifyResponse = await Supabase.instance.client.functions.invoke(
        'verify-payment',
        body: {
          'payment_id': currentDbPaymentId,
          'order_id': orderId,
          'razorpay_payment_id': paymentId,
          'razorpay_signature': signature,
        },
      );
      log('verify payment $verifyResponse');

      final dynamic data = verifyResponse.data is String
          ? jsonDecode(verifyResponse.data as String)
          : verifyResponse.data;
      return data;
    } catch (e) {
      log('[Razorpay] Error calling verify-payment edge function: $e');
      return Exception(
        '[Razorpay] Error calling verify-payment edge function: $e',
      );
    }
  }

  Future getOrderID({required CoinPackage package}) async {
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

          return data;
        }
      }
    } catch (e) {
      log(
        '[Razorpay] Edge function create-payment-order error: $e. Proceeding with standard checkout.',
      );
      return Exception(
        '[Razorpay] Edge function create-payment-order error: $e. Proceeding with standard checkout.',
      );
    }
  }

  Future getPaymentHistory() async {
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

          return data;
        }
      }
    } catch (e) {
      log('Error in getting payment history');
    }
  }
}
