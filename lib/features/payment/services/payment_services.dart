import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:card_game/features/payment/models/coin_package.dart';
import 'package:card_game/features/payment/models/payment_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class PaymentServices {
  PaymentServices._internal();

  static final PaymentServices _instance = PaymentServices._internal();

  // Factory returns the same instance every time
  factory PaymentServices() => _instance;
  final SupabaseClient apiClient = Supabase.instance.client;

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
    } catch (e, stackTree) {
      log(
        '[Razorpay] Edge function create-payment-order error: $e. Proceeding with standard checkout. $stackTree',
      );
      throw Exception(
        '[Razorpay] Edge function create-payment-order error: $e. Proceeding with standard checkout.',
      );
    }
  }

  Future<PaymentModel?> getPaymentStatus(String paymentId) async {
    try {
      final response = await apiClient.functions.invoke(
        'payment-status',
        body: {'payment_id': paymentId},
      );

      final data = Map<String, dynamic>.from(response.data as Map);

      if (data['error'] != null) {
        throw Exception(data['error'].toString());
      }

      return PaymentModel.fromJson(
        Map<String, dynamic>.from(data['payment'] as Map),
      );
    } catch (e, stackTree) {
      log('error get payment Status : $e $stackTree');
      throw Exception('error get payment history : $e $stackTree');
    }
  }

  Future<Map?> getPaymentHistory({int page = 1, int limit = 20}) async {
    try {
      final response = await apiClient.functions.invoke(
        'payment-history',
        body: {'page': page, 'limit': limit},
      );

      log(
        'payment history response: '
        '${response.data}',
      );

      final data = response.data;

      if (data == null) {
        throw Exception('Empty response from payment-history');
      }

      final json = Map<String, dynamic>.from(data as Map);

      if (json['success'] != true) {
        throw Exception(
          json['message'] ?? json['error'] ?? 'Unable to fetch payment history',
        );
      }

      return data;
      // } on  catch (e) {
      //   log(
      //     'payment history FunctionException '
      //     'status=${e.status} '
      //     'reason=${e.reasonPhrase} '
      //     'details=${e.details}',
      //   );

      //   throw Exception(
      //     e.details?.toString() ??
      //         e.reasonPhrase ??
      //         'Payment history request failed',
      //   );
    } catch (e, stackTree) {
      log('error get payment history : $e $stackTree');
      throw Exception('error get payment history : $e $stackTree');
    }
  }
}
