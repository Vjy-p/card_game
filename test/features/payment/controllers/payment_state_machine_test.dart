import 'package:flutter_test/flutter_test.dart';

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

void main() {
  group('PaymentStateMachine', () {
    late PaymentStateMachine sm;

    setUp(() {
      sm = PaymentStateMachine();
    });

    test('initial state is created', () {
      expect(sm.state, TestPaymentStatus.created);
    });

    test('valid lifecycle transitions: created -> checkoutStarted -> pending -> authorized -> captured -> refunded', () {
      expect(sm.transition(TestPaymentStatus.checkoutStarted), isTrue);
      expect(sm.state, TestPaymentStatus.checkoutStarted);

      expect(sm.transition(TestPaymentStatus.pending), isTrue);
      expect(sm.state, TestPaymentStatus.pending);

      expect(sm.transition(TestPaymentStatus.authorized), isTrue);
      expect(sm.state, TestPaymentStatus.authorized);

      expect(sm.transition(TestPaymentStatus.captured), isTrue);
      expect(sm.state, TestPaymentStatus.captured);

      expect(sm.transition(TestPaymentStatus.refunded), isTrue);
      expect(sm.state, TestPaymentStatus.refunded);
    });

    test('cannot transition after refunded', () {
      sm.state = TestPaymentStatus.refunded;
      expect(sm.transition(TestPaymentStatus.created), isFalse);
      expect(sm.transition(TestPaymentStatus.captured), isFalse);
      expect(sm.state, TestPaymentStatus.refunded);
    });

    test('captured can only transition to refunded, not failed or pending', () {
      sm.state = TestPaymentStatus.captured;
      expect(sm.transition(TestPaymentStatus.failed), isFalse);
      expect(sm.transition(TestPaymentStatus.pending), isFalse);
      expect(sm.state, TestPaymentStatus.captured);
    });

    test('can transition to failed from created, checkoutStarted, or pending', () {
      sm.state = TestPaymentStatus.created;
      expect(sm.transition(TestPaymentStatus.failed), isTrue);
      expect(sm.state, TestPaymentStatus.failed);

      sm.state = TestPaymentStatus.checkoutStarted;
      expect(sm.transition(TestPaymentStatus.failed), isTrue);
      expect(sm.state, TestPaymentStatus.failed);

      sm.state = TestPaymentStatus.pending;
      expect(sm.transition(TestPaymentStatus.failed), isTrue);
      expect(sm.state, TestPaymentStatus.failed);
    });
  });
}
