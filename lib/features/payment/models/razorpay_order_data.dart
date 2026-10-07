/// Holds Razorpay Order parameters returned by server / Edge functions
class RazorpayOrderData {
  final String orderId;
  final int amount;
  final String currency;
  final String? receipt;
  final Map<String, dynamic>? notes;

  const RazorpayOrderData({
    required this.orderId,
    required this.amount,
    required this.currency,
    this.receipt,
    this.notes,
  });

  factory RazorpayOrderData.fromJson(Map<String, dynamic> json) {
    return RazorpayOrderData(
      orderId: json['id'] ?? json['order_id'] ?? json['orderId'] ?? '',
      amount: json['amount'] is int
          ? json['amount']
          : int.tryParse(json['amount']?.toString() ?? '') ?? 0,
      currency: json['currency'] ?? 'INR',
      receipt: json['receipt']?.toString(),
      notes: json['notes'] is Map<String, dynamic>
          ? json['notes'] as Map<String, dynamic>
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': orderId,
    'amount': amount,
    'currency': currency,
    if (receipt != null) 'receipt': receipt,
    if (notes != null) 'notes': notes,
  };
}
