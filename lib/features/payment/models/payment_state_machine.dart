import 'package:card_game/features/payment/models/payment_status.dart';

/// State machine governing Razorpay payment lifecycles and webhook idempotency
class PaymentStateMachine {
  PaymentStatus _state = PaymentStatus.created;

  PaymentStateMachine({PaymentStatus initial = PaymentStatus.created})
      : _state = initial;

  PaymentStatus get state => _state;

  bool transition(PaymentStatus next) {
    // 1. Terminal states
    if (_state == PaymentStatus.refunded) {
      return false;
    }

    if (_state == PaymentStatus.captured) {
      if (next == PaymentStatus.refunded) {
        _state = next;
        return true;
      }
      if (next == PaymentStatus.captured) {
        // Idempotent duplicate event
        return true;
      }
      return false;
    }

    // 2. Successful capture from valid active states
    if (next == PaymentStatus.captured) {
      _state = next;
      return true;
    }

    // 3. Authorization event
    if (next == PaymentStatus.authorized) {
      if (_state == PaymentStatus.created ||
          _state == PaymentStatus.checkoutStarted ||
          _state == PaymentStatus.pending) {
        _state = next;
        return true;
      }
      return false;
    }

    // 4. Failure event
    if (next == PaymentStatus.failed) {
      if (_state == PaymentStatus.created ||
          _state == PaymentStatus.checkoutStarted ||
          _state == PaymentStatus.pending) {
        _state = next;
        return true;
      }
      if (_state == PaymentStatus.failed) {
        return true;
      }
      return false;
    }

    // 5. Cancellation event
    if (next == PaymentStatus.cancelled) {
      if (_state == PaymentStatus.created ||
          _state == PaymentStatus.checkoutStarted ||
          _state == PaymentStatus.pending) {
        _state = next;
        return true;
      }
      return false;
    }

    // 6. Generic forward transition (e.g., checkoutStarted, pending, retrying after failure)
    _state = next;
    return true;
  }
}
