enum TestPaymentStatus {
  created,
  checkoutStarted,
  pending,
  authorized,
  captured,
  failed,
  cancelled,
  refunded,
}

class PaymentStateMachine {
  TestPaymentStatus state = TestPaymentStatus.created;

  bool transition(TestPaymentStatus next) {
    if (state == TestPaymentStatus.captured) {
      if (next == TestPaymentStatus.refunded) {
        state = next;
        return true;
      }

      return false;
    }

    if (state == TestPaymentStatus.refunded) {
      return false;
    }

    if (next == TestPaymentStatus.captured) {
      state = next;
      return true;
    }

    if (next == TestPaymentStatus.failed &&
        (state == TestPaymentStatus.created ||
            state == TestPaymentStatus.checkoutStarted ||
            state == TestPaymentStatus.pending)) {
      state = next;
      return true;
    }

    if (next == TestPaymentStatus.authorized &&
        (state == TestPaymentStatus.created ||
            state == TestPaymentStatus.checkoutStarted ||
            state == TestPaymentStatus.pending)) {
      state = next;
      return true;
    }

    state = next;
    return true;
  }
}
