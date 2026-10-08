import 'dart:convert';

import 'package:card_game/features/payment/models/payment_status.dart';

PaymentModel paymentModelFromJson(String str) =>
    PaymentModel.fromJson(json.decode(str));

String paymentModelToJson(PaymentModel data) => json.encode(data.toJson());

PaymentStatus paymentStatusFromString(String value) {
  switch (value) {
    case 'created':
      return PaymentStatus.created;

    case 'checkout_started':
      return PaymentStatus.checkoutStarted;

    case 'pending':
      return PaymentStatus.pending;

    case 'authorized':
      return PaymentStatus.authorized;

    case 'captured':
      return PaymentStatus.captured;

    case 'failed':
      return PaymentStatus.failed;

    case 'cancelled':
      return PaymentStatus.cancelled;

    case 'refunded':
      return PaymentStatus.refunded;

    case 'refund_pending':
      return PaymentStatus.refundPending;

    case 'refund_failed':
      return PaymentStatus.refundFailed;

    default:
      return PaymentStatus.pending;
  }
}

class PaymentModel {
  final String id;
  final String? razorpayOrderId;
  final String? razorpayPaymentId;
  final int amount;
  final String currency;
  final PaymentStatus status;
  final String? signature;
  final String? errorCode;
  final String? errorDescription;

  const PaymentModel({
    required this.id,
    required this.razorpayOrderId,
    required this.razorpayPaymentId,
    required this.amount,
    required this.currency,
    required this.status,
    this.signature,
    this.errorCode,
    this.errorDescription,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as String,
      razorpayOrderId: json['razorpay_order_id'] as String?,
      razorpayPaymentId: json['razorpay_payment_id'] as String?,
      amount: (json['amount'] as num).toInt(),
      currency: json['currency'] as String? ?? 'INR',
      status: paymentStatusFromString(json['status'] as String? ?? 'pending'),
      errorCode: json['error_code'] as String?,
      errorDescription: json['error_description'] as String?,
      signature: json['signature'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'razorpay_order_id': razorpayOrderId,
      'razorpay_payment_id': razorpayPaymentId,
      'amount': amount,
      'currency': currency,
      'status': status.name,
      'signature': signature,
      'errorCode': errorCode,
      'errorDescription': errorDescription,
    };
  }

  PaymentModel copyWith({
    String? razorpayOrderId,
    String? razorpayPaymentId,
    int? amount,
    String? currency,
    PaymentStatus? status,
    String? signature,
    String? errorCode,
    String? errorDescription,
  }) {
    return PaymentModel(
      id: id,
      razorpayOrderId: razorpayOrderId ?? this.razorpayOrderId,
      razorpayPaymentId: razorpayPaymentId ?? this.razorpayPaymentId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      signature: signature ?? this.signature,
      errorCode: errorCode ?? this.errorCode,
      errorDescription: errorDescription ?? this.errorDescription,
    );
  }
}
