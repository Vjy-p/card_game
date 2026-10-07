import 'package:card_game/features/payment/models/payment_status.dart';

/// Encapsulates the outcome of a Razorpay payment attempt
class PaymentResult {
  final PaymentStatus status;
  final String? paymentId;
  final String? orderId;
  final String? signature;
  final String? errorMessage;
  final int? errorCode;
  final bool isCancelled;

  const PaymentResult({
    required this.status,
    this.paymentId,
    this.orderId,
    this.signature,
    this.errorMessage,
    this.errorCode,
    this.isCancelled = false,
  });

  /// Compatibility getter for legacy callers
  String? get paymentIntentId => paymentId;

  bool get isSuccess => status == PaymentStatus.captured;
  bool get isFailure => status == PaymentStatus.failed;

  factory PaymentResult.success({
    String? paymentId,
    String? paymentIntentId,
    String? orderId,
    String? signature,
  }) {
    return PaymentResult(
      status: PaymentStatus.captured,
      paymentId: paymentId ?? paymentIntentId ?? '',
      orderId: orderId,
      signature: signature,
    );
  }

  factory PaymentResult.cancelled({String? message}) {
    return PaymentResult(
      status: PaymentStatus.cancelled,
      isCancelled: true,
      errorMessage: message ?? 'Payment was cancelled by the user.',
    );
  }

  factory PaymentResult.failure({
    required String errorMessage,
    int? errorCode,
  }) {
    return PaymentResult(
      status: PaymentStatus.failed,
      errorMessage: errorMessage,
      errorCode: errorCode,
    );
  }
}
