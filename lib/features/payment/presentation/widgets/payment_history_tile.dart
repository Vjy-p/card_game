import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/features/payment/models/payment_history_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentHistoryTile extends StatelessWidget {
  const PaymentHistoryTile({super.key, required this.paymentDetails});
  final PaymentHistoryModel paymentDetails;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(12),
      ),
      collapsedBackgroundColor: AppColors.backgroundSecondary,
      collapsedIconColor: AppColors.textSecondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(12),
      ),
      backgroundColor: AppColors.backgroundSecondary,
      childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      title: Row(
        spacing: 20,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              '${paymentDetails.amountInRupees} ${paymentDetails.currency}',
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textMuted,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              DateFormat(
                'dd MMM yyyy hh:mm:ss a',
              ).format(paymentDetails.createdAt),
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
                // fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
      children: [
        rowTile(title: 'Id', value: paymentDetails.id),
        const SizedBox(height: 8),
        rowTile(
          title: 'payment id',
          value: paymentDetails.razorpayPaymentId ?? '',
        ),
        const SizedBox(height: 8),
        rowTile(title: 'Order id', value: paymentDetails.razorpayOrderId ?? ''),
        const SizedBox(height: 8),
        rowTile(
          title: 'Payment method',
          value: paymentDetails.paymentMethod ?? '',
        ),
        const SizedBox(height: 8),
        rowTile(title: 'Status', value: paymentDetails.status),
        const SizedBox(height: 8),
        if (paymentDetails.receipt != null) ...[
          rowTile(title: 'Receipt', value: paymentDetails.receipt ?? ''),
          const SizedBox(height: 8),
        ],
        if (paymentDetails.paidAt != null) ...[
          rowTile(
            title: 'Paid at',
            value: DateFormat(
              'dd MMM yyyy hh:mm:ss a',
            ).format(paymentDetails.paidAt!),
          ),
          const SizedBox(height: 8),
        ],
        if (paymentDetails.failedAt != null) ...[
          rowTile(
            title: 'Failed at',
            value: DateFormat(
              'dd MMM yyyy hh:mm:ss a',
            ).format(paymentDetails.failedAt!),
          ),
          const SizedBox(height: 8),
        ],
        if (paymentDetails.errorDescription != null) ...[
          rowTile(
            title: 'Failed reason',
            value: paymentDetails.errorDescription ?? '',
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }

  Widget rowTile({required String title, required String value}) {
    return Row(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textMuted,
              // letterSpacing: 0,
              // fontWeight: FontWeight.normal,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
