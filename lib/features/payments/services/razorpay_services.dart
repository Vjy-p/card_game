import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

sealed class RazorpayEvent {
  const RazorpayEvent();
}

class RazorpaySuccessEvent extends RazorpayEvent {
  final String paymentId;
  final String? orderId;
  final String? signature;

  const RazorpaySuccessEvent({
    required this.paymentId,
    required this.orderId,
    required this.signature,
  });
}

class RazorpayFailureEvent extends RazorpayEvent {
  final int code;
  final String? message;

  const RazorpayFailureEvent({required this.code, required this.message});
}

class RazorpayExternalWalletEvent extends RazorpayEvent {
  final String? walletName;

  const RazorpayExternalWalletEvent({required this.walletName});
}

class RazorpayService {
  RazorpayService() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onSuccess);

    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _onFailure);

    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _onExternalWallet);
  }

  final Razorpay _razorpay = Razorpay();

  final StreamController<RazorpayEvent> _events =
      StreamController<RazorpayEvent>.broadcast();

  Stream<RazorpayEvent> get events => _events.stream;

  void open({
    required String key,
    required String orderId,
    required int amount,
    required String name,
    required String email,
    required String phone,
  }) {
    final options = {
      'key': key,
      'amount': amount,
      'order_id': orderId,
      'name': name,
      'description': 'Payment',
      'prefill': {'name': name, 'email': email, 'contact': phone},
      'theme': {'color': '#1E1B33'},
    };

    try {
      _razorpay.open(options);
    } catch (e, stack) {
      debugPrint('Razorpay open error: $e\n$stack');

      _events.add(RazorpayFailureEvent(code: -1, message: e.toString()));
    }
  }

  void _onSuccess(PaymentSuccessResponse response) {
    _events.add(
      RazorpaySuccessEvent(
        paymentId: response.paymentId ?? '',
        orderId: response.orderId,
        signature: response.signature,
      ),
    );
  }

  void _onFailure(PaymentFailureResponse response) {
    _events.add(
      RazorpayFailureEvent(code: response.code!, message: response.message),
    );
  }

  void _onExternalWallet(ExternalWalletResponse response) {
    _events.add(RazorpayExternalWalletEvent(walletName: response.walletName));
  }

  void dispose() {
    _razorpay.clear();
    _events.close();
  }
}
