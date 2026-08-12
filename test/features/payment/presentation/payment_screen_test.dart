import 'package:flutter_test/flutter_test.dart';

import '../controllers/payment_state_machine_test.dart';

void main() {
  group('Razorpay Payment State Machine', () {
    // 1
    test('created -> checkout started', () {
      final machine = PaymentStateMachine();

      machine.transition(TestPaymentStatus.checkoutStarted);

      expect(machine.state, TestPaymentStatus.checkoutStarted);
    });

    // 2
    test('checkout -> captured', () {
      final machine = PaymentStateMachine();

      machine.transition(TestPaymentStatus.checkoutStarted);

      machine.transition(TestPaymentStatus.captured);

      expect(machine.state, TestPaymentStatus.captured);
    });

    // 3
    test('checkout -> failed', () {
      final machine = PaymentStateMachine();

      machine.transition(TestPaymentStatus.checkoutStarted);

      machine.transition(TestPaymentStatus.failed);

      expect(machine.state, TestPaymentStatus.failed);
    });

    // 4
    test('checkout -> pending', () {
      final machine = PaymentStateMachine();

      machine.transition(TestPaymentStatus.checkoutStarted);

      machine.transition(TestPaymentStatus.pending);

      expect(machine.state, TestPaymentStatus.pending);
    });

    // 5
    test('pending -> authorized', () {
      final machine = PaymentStateMachine();

      machine.transition(TestPaymentStatus.pending);

      machine.transition(TestPaymentStatus.authorized);

      expect(machine.state, TestPaymentStatus.authorized);
    });

    // 6
    test('pending -> captured', () {
      final machine = PaymentStateMachine();

      machine.transition(TestPaymentStatus.pending);

      machine.transition(TestPaymentStatus.captured);

      expect(machine.state, TestPaymentStatus.captured);
    });

    // 7
    test('authorized -> captured', () {
      final machine = PaymentStateMachine();

      machine.transition(TestPaymentStatus.authorized);

      machine.transition(TestPaymentStatus.captured);

      expect(machine.state, TestPaymentStatus.captured);
    });

    // 8
    test('captured is terminal for failed', () {
      final machine = PaymentStateMachine();

      machine.transition(TestPaymentStatus.captured);

      final result = machine.transition(TestPaymentStatus.failed);

      expect(result, false);

      expect(machine.state, TestPaymentStatus.captured);
    });

    // 9
    test('captured -> refunded', () {
      final machine = PaymentStateMachine();

      machine.transition(TestPaymentStatus.captured);

      machine.transition(TestPaymentStatus.refunded);

      expect(machine.state, TestPaymentStatus.refunded);
    });

    // 10
    test('refunded is terminal', () {
      final machine = PaymentStateMachine();

      machine.transition(TestPaymentStatus.captured);

      machine.transition(TestPaymentStatus.refunded);

      final result = machine.transition(TestPaymentStatus.captured);

      expect(result, false);
    });

    // 11
    test('duplicate captured is safe', () {
      final machine = PaymentStateMachine();

      machine.transition(TestPaymentStatus.captured);

      machine.transition(TestPaymentStatus.captured);

      expect(machine.state, TestPaymentStatus.captured);
    });

    // 12
    test('authorized webhook after captured does not downgrade', () {
      final machine = PaymentStateMachine();

      machine.transition(TestPaymentStatus.captured);

      final result = machine.transition(TestPaymentStatus.authorized);

      expect(result, false);

      expect(machine.state, TestPaymentStatus.captured);
    });

    // 13
    test('failed then retry can reach checkout', () {
      final machine = PaymentStateMachine();

      machine.transition(TestPaymentStatus.failed);

      machine.transition(TestPaymentStatus.checkoutStarted);

      expect(machine.state, TestPaymentStatus.checkoutStarted);
    });

    // 14
    test('network error represented by pending', () {
      final machine = PaymentStateMachine();

      machine.transition(TestPaymentStatus.pending);

      expect(machine.state, TestPaymentStatus.pending);
    });

    // 15
    test('bank timeout stays pending', () {
      final machine = PaymentStateMachine();

      machine.transition(TestPaymentStatus.checkoutStarted);

      machine.transition(TestPaymentStatus.pending);

      expect(machine.state, TestPaymentStatus.pending);
    });

    // 16
    test('pending later becomes captured', () {
      final machine = PaymentStateMachine();

      machine.transition(TestPaymentStatus.pending);

      machine.transition(TestPaymentStatus.captured);

      expect(machine.state, TestPaymentStatus.captured);
    });

    // 17
    test('pending later becomes failed', () {
      final machine = PaymentStateMachine();

      machine.transition(TestPaymentStatus.pending);

      machine.transition(TestPaymentStatus.failed);

      expect(machine.state, TestPaymentStatus.failed);
    });

    // 18
    test('captured cannot become cancelled', () {
      final machine = PaymentStateMachine();

      machine.transition(TestPaymentStatus.captured);

      expect(machine.transition(TestPaymentStatus.cancelled), false);
    });

    // 19
    test('captured cannot become pending', () {
      final machine = PaymentStateMachine();

      machine.transition(TestPaymentStatus.captured);

      expect(machine.transition(TestPaymentStatus.pending), false);
    });

    // 20
    test('captured cannot become authorized', () {
      final machine = PaymentStateMachine();

      machine.transition(TestPaymentStatus.captured);

      expect(machine.transition(TestPaymentStatus.authorized), false);
    });

    // 21
    test('webhook order captured before authorized', () {
      final machine = PaymentStateMachine();

      machine.transition(TestPaymentStatus.captured);

      machine.transition(TestPaymentStatus.authorized);

      expect(machine.state, TestPaymentStatus.captured);
    });

    // 22
    test('webhook order failed before captured', () {
      final machine = PaymentStateMachine();

      machine.transition(TestPaymentStatus.failed);

      machine.transition(TestPaymentStatus.captured);

      expect(machine.state, TestPaymentStatus.captured);
    });

    // 23
    test('duplicate failed webhook is harmless', () {
      final machine = PaymentStateMachine();

      machine.transition(TestPaymentStatus.failed);

      machine.transition(TestPaymentStatus.failed);

      expect(machine.state, TestPaymentStatus.failed);
    });

    // 24
    test('offline recovery pending -> captured', () {
      final machine = PaymentStateMachine();

      machine.transition(TestPaymentStatus.pending);

      // Internet restored.
      machine.transition(TestPaymentStatus.captured);

      expect(machine.state, TestPaymentStatus.captured);
    });

    // 25
    test('app restart recovery pending -> captured', () {
      final machine = PaymentStateMachine();

      machine.transition(TestPaymentStatus.pending);

      // Simulates status check after app restart.
      machine.transition(TestPaymentStatus.captured);

      expect(machine.state, TestPaymentStatus.captured);
    });

    // 26
    test('bank server failure can recover', () {
      final machine = PaymentStateMachine();

      machine.transition(TestPaymentStatus.pending);

      machine.transition(TestPaymentStatus.captured);

      expect(machine.state, TestPaymentStatus.captured);
    });

    // 27
    test('payment callback failure does not require immediate retry', () {
      final machine = PaymentStateMachine();

      machine.transition(TestPaymentStatus.pending);

      expect(machine.state, TestPaymentStatus.pending);
    });

    // 28
    test('uncertain payment cannot be automatically treated as failed', () {
      final machine = PaymentStateMachine();

      machine.transition(TestPaymentStatus.pending);

      expect(machine.state, TestPaymentStatus.pending);
    });

    // 29
    test('successful payment remains successful after duplicate events', () {
      final machine = PaymentStateMachine();

      machine.transition(TestPaymentStatus.captured);

      machine.transition(TestPaymentStatus.captured);

      machine.transition(TestPaymentStatus.authorized);

      machine.transition(TestPaymentStatus.captured);

      expect(machine.state, TestPaymentStatus.captured);
    });

    // 30
    test('complete uncertain payment lifecycle', () {
      final machine = PaymentStateMachine();

      machine.transition(TestPaymentStatus.checkoutStarted);

      // Internet disappears.
      machine.transition(TestPaymentStatus.pending);

      // App restarts.
      machine.transition(TestPaymentStatus.pending);

      // Server checks Razorpay.
      machine.transition(TestPaymentStatus.captured);

      // Duplicate webhook.
      machine.transition(TestPaymentStatus.captured);

      expect(machine.state, TestPaymentStatus.captured);
    });
  });
}
