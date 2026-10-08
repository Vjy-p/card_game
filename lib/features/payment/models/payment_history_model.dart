class PaymentHistoryModel {
  final String id;
  final int amount;
  final String currency;
  final String status;

  final String? razorpayOrderId;
  final String? razorpayPaymentId;
  final String? razorpayStatus;
  final String? paymentMethod;

  final String? errorCode;
  final String? errorDescription;
  final String? errorReason;

  final String? receipt;

  final Map<String, dynamic>? metadata;

  final String? fulfilmentStatus;

  final DateTime createdAt;
  final DateTime updatedAt;

  final DateTime? paidAt;
  final DateTime? failedAt;

  const PaymentHistoryModel({
    required this.id,
    required this.amount,
    required this.currency,
    required this.status,
    this.razorpayOrderId,
    this.razorpayPaymentId,
    this.razorpayStatus,
    this.paymentMethod,
    this.errorCode,
    this.errorDescription,
    this.errorReason,
    this.receipt,
    this.metadata,
    this.fulfilmentStatus,
    required this.createdAt,
    required this.updatedAt,
    this.paidAt,
    this.failedAt,
  });

  factory PaymentHistoryModel.fromJson(Map<String, dynamic> json) {
    return PaymentHistoryModel(
      id: json['id'] as String,

      amount: (json['amount'] as num).toInt(),

      currency: json['currency'] as String,

      status: json['status'] as String,

      razorpayOrderId: json['razorpay_order_id'] as String?,

      razorpayPaymentId: json['razorpay_payment_id'] as String?,

      razorpayStatus: json['razorpay_status'] as String?,

      paymentMethod: json['payment_method'] as String?,

      errorCode: json['error_code'] as String?,

      errorDescription: json['error_description'] as String?,

      errorReason: json['error_reason'] as String?,

      receipt: json['receipt'] as String?,

      metadata: json['metadata'] == null
          ? null
          : Map<String, dynamic>.from(json['metadata'] as Map),

      fulfilmentStatus: json['fulfilment_status'] as String?,

      createdAt: DateTime.parse(json['created_at'] as String),

      updatedAt: DateTime.parse(json['updated_at'] as String),

      paidAt: json['paid_at'] == null
          ? null
          : DateTime.parse(json['paid_at'] as String),

      failedAt: json['failed_at'] == null
          ? null
          : DateTime.parse(json['failed_at'] as String),
    );
  }

  double get amountInRupees => amount / 100.0;

  bool get isSuccessful => status == 'captured';

  bool get isFailed => status == 'failed';

  bool get isPending => status == 'pending' || status == 'authorized';

  bool get isRefunded => status == 'refunded';
}
