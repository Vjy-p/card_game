import 'dart:developer';

import 'package:card_game/features/payments/models/payment_history_result.dart';
import 'package:card_game/features/payments/models/payment_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PaymentRepository {
  PaymentRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<Map<String, dynamic>> createPaymentOrder({
    required int amount,
    required String clientRequestId,
  }) async {
    final response = await _client.functions.invoke(
      'create-payment-order',
      body: {'amount': amount, 'client_request_id': clientRequestId},
    );

    if (response.data == null) {
      throw Exception('No response from create-payment-order');
    }

    final data = Map<String, dynamic>.from(response.data as Map);

    if (data['error'] != null) {
      throw Exception(data['error'].toString());
    }

    return data;
  }

  Future<Map<String, dynamic>> verifyPayment({
    required String paymentId,
    required String orderId,
    required String razorpayPaymentId,
    required String signature,
  }) async {
    final response = await _client.functions.invoke(
      'verify-payment',
      body: {
        'payment_id': paymentId,
        'order_id': orderId,
        'razorpay_payment_id': razorpayPaymentId,
        'razorpay_signature': signature,
      },
    );

    final data = Map<String, dynamic>.from(response.data as Map);

    if (data['error'] != null) {
      throw Exception(data['error'].toString());
    }

    return data;
  }

  Future<PaymentModel> getPaymentStatus(String paymentId) async {
    final response = await _client.functions.invoke(
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
  }

  Future<PaymentHistoryResult> getPaymentHistory({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _client.functions.invoke(
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

      return PaymentHistoryResult.fromJson(json);
    } on FunctionException catch (e) {
      log(
        'payment history FunctionException '
        'status=${e.status} '
        'reason=${e.reasonPhrase} '
        'details=${e.details}',
      );

      throw Exception(
        e.details?.toString() ??
            e.reasonPhrase ??
            'Payment history request failed',
      );
    } catch (e) {
      log('payment history error: $e');

      rethrow;
    }
  }
}
