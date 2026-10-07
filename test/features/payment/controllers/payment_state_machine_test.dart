import 'package:card_game/features/payment/models/payment_state_machine.dart';
import 'package:card_game/features/payment/models/payment_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PaymentStateMachine', () {
    late PaymentStateMachine sm;

    setUp(() {
      sm = PaymentStateMachine();
    });

    test('initial state is created', () {
      expect(sm.state, PaymentStatus.created);
    });

    test(
        'valid lifecycle transitions: created -> checkoutStarted -> pending -> authorized -> captured -> refunded',
        () {
      expect(sm.transition(PaymentStatus.checkoutStarted), isTrue);
      expect(sm.state, PaymentStatus.checkoutStarted);

      expect(sm.transition(PaymentStatus.pending), isTrue);
      expect(sm.state, PaymentStatus.pending);

      expect(sm.transition(PaymentStatus.authorized), isTrue);
      expect(sm.state, PaymentStatus.authorized);

      expect(sm.transition(PaymentStatus.captured), isTrue);
      expect(sm.state, PaymentStatus.captured);

      expect(sm.transition(PaymentStatus.refunded), isTrue);
      expect(sm.state, PaymentStatus.refunded);
    });

    test('cannot transition after refunded', () {
      sm.transition(PaymentStatus.captured);
      sm.transition(PaymentStatus.refunded);
      expect(sm.transition(PaymentStatus.created), isFalse);
      expect(sm.transition(PaymentStatus.captured), isFalse);
      expect(sm.state, PaymentStatus.refunded);
    });

    test('captured can only transition to refunded, not failed or pending', () {
      sm.transition(PaymentStatus.captured);
      expect(sm.transition(PaymentStatus.failed), isFalse);
      expect(sm.transition(PaymentStatus.pending), isFalse);
      expect(sm.state, PaymentStatus.captured);
    });

    test('can transition to failed from created, checkoutStarted, or pending', () {
      sm = PaymentStateMachine(initial: PaymentStatus.created);
      expect(sm.transition(PaymentStatus.failed), isTrue);
      expect(sm.state, PaymentStatus.failed);

      sm = PaymentStateMachine(initial: PaymentStatus.checkoutStarted);
      expect(sm.transition(PaymentStatus.failed), isTrue);
      expect(sm.state, PaymentStatus.failed);

      sm = PaymentStateMachine(initial: PaymentStatus.pending);
      expect(sm.transition(PaymentStatus.failed), isTrue);
      expect(sm.state, PaymentStatus.failed);
    });

    test('can transition to cancelled from created, checkoutStarted, or pending', () {
      sm = PaymentStateMachine(initial: PaymentStatus.created);
      expect(sm.transition(PaymentStatus.cancelled), isTrue);
      expect(sm.state, PaymentStatus.cancelled);

      sm = PaymentStateMachine(initial: PaymentStatus.checkoutStarted);
      expect(sm.transition(PaymentStatus.cancelled), isTrue);
      expect(sm.state, PaymentStatus.cancelled);

      sm = PaymentStateMachine(initial: PaymentStatus.pending);
      expect(sm.transition(PaymentStatus.cancelled), isTrue);
      expect(sm.state, PaymentStatus.cancelled);
    });
  });
}
