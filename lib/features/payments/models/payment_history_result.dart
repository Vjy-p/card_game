import 'package:card_game/features/payments/models/payment_history_model.dart';

class PaymentHistoryResult {
  final List<PaymentHistoryModel> payments;
  final int total;
  final bool hasMore;

  const PaymentHistoryResult({
    required this.payments,
    required this.total,
    required this.hasMore,
  });

  factory PaymentHistoryResult.fromJson(Map<String, dynamic> json) {
    final paymentsJson = json['payments'] as List<dynamic>? ?? [];

    return PaymentHistoryResult(
      payments: paymentsJson
          .map(
            (e) => PaymentHistoryModel.fromJson(Map<String, dynamic>.from(e)),
          )
          .toList(),
      total: (json['total'] as num?)?.toInt() ?? 0,
      hasMore: json['has_more'] == true,
    );
  }
}
