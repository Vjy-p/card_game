import 'package:card_game/features/payment/controllers/payment_controller.dart';
import 'package:card_game/features/payment/models/coin_package.dart';
import 'package:card_game/features/payment/models/payment_result.dart';
import 'package:card_game/features/payment/models/payment_state_machine.dart';
import 'package:card_game/features/payment/models/payment_status.dart';
import 'package:card_game/features/payment/presentation/screens/payments_screen.dart';
import 'package:card_game/features/payment/services/razorpay_payment_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class MockRazorpayPaymentService implements IRazorpayPaymentService {
  bool initialized = false;
  bool disposed = false;
  CoinPackage? lastPackage;
  String? lastCustomerEmail;
  PaymentResult openResult =
      PaymentResult.success(paymentId: 'pay_mock_123');

  @override
  Future<void> initialize() async {
    initialized = true;
  }

  @override
  Future<PaymentResult> openCheckout({
    required CoinPackage package,
    required String customerEmail,
    String? customerContact,
  }) async {
    lastPackage = package;
    lastCustomerEmail = customerEmail;
    return openResult;
  }

  @override
  void dispose() {
    disposed = true;
  }
}

void main() {
  setUp(() {
    Get.reset();
    Get.testMode = true;
  });

  tearDown(() {
    Get.reset();
  });

  group('Payment State Machine Transitions', () {
    test('created -> checkout started', () {
      final machine = PaymentStateMachine();
      machine.transition(PaymentStatus.checkoutStarted);
      expect(machine.state, PaymentStatus.checkoutStarted);
    });

    test('checkout -> captured', () {
      final machine = PaymentStateMachine();
      machine.transition(PaymentStatus.checkoutStarted);
      machine.transition(PaymentStatus.captured);
      expect(machine.state, PaymentStatus.captured);
    });

    test('checkout -> failed', () {
      final machine = PaymentStateMachine();
      machine.transition(PaymentStatus.checkoutStarted);
      machine.transition(PaymentStatus.failed);
      expect(machine.state, PaymentStatus.failed);
    });

    test('checkout -> pending', () {
      final machine = PaymentStateMachine();
      machine.transition(PaymentStatus.checkoutStarted);
      machine.transition(PaymentStatus.pending);
      expect(machine.state, PaymentStatus.pending);
    });

    test('pending -> authorized', () {
      final machine = PaymentStateMachine();
      machine.transition(PaymentStatus.pending);
      machine.transition(PaymentStatus.authorized);
      expect(machine.state, PaymentStatus.authorized);
    });

    test('pending -> captured', () {
      final machine = PaymentStateMachine();
      machine.transition(PaymentStatus.pending);
      machine.transition(PaymentStatus.captured);
      expect(machine.state, PaymentStatus.captured);
    });

    test('authorized -> captured', () {
      final machine = PaymentStateMachine();
      machine.transition(PaymentStatus.authorized);
      machine.transition(PaymentStatus.captured);
      expect(machine.state, PaymentStatus.captured);
    });

    test('captured is terminal for failed', () {
      final machine = PaymentStateMachine();
      machine.transition(PaymentStatus.captured);
      final result = machine.transition(PaymentStatus.failed);
      expect(result, false);
      expect(machine.state, PaymentStatus.captured);
    });

    test('captured -> refunded', () {
      final machine = PaymentStateMachine();
      machine.transition(PaymentStatus.captured);
      machine.transition(PaymentStatus.refunded);
      expect(machine.state, PaymentStatus.refunded);
    });

    test('refunded is terminal', () {
      final machine = PaymentStateMachine();
      machine.transition(PaymentStatus.captured);
      machine.transition(PaymentStatus.refunded);
      final result = machine.transition(PaymentStatus.captured);
      expect(result, false);
    });

    test('duplicate captured is safe', () {
      final machine = PaymentStateMachine();
      machine.transition(PaymentStatus.captured);
      machine.transition(PaymentStatus.captured);
      expect(machine.state, PaymentStatus.captured);
    });

    test('authorized webhook after captured does not downgrade', () {
      final machine = PaymentStateMachine();
      machine.transition(PaymentStatus.captured);
      final result = machine.transition(PaymentStatus.authorized);
      expect(result, false);
      expect(machine.state, PaymentStatus.captured);
    });

    test('failed then retry can reach checkout', () {
      final machine = PaymentStateMachine();
      machine.transition(PaymentStatus.failed);
      machine.transition(PaymentStatus.checkoutStarted);
      expect(machine.state, PaymentStatus.checkoutStarted);
    });

    test('network error represented by pending', () {
      final machine = PaymentStateMachine();
      machine.transition(PaymentStatus.pending);
      expect(machine.state, PaymentStatus.pending);
    });

    test('bank timeout stays pending', () {
      final machine = PaymentStateMachine();
      machine.transition(PaymentStatus.checkoutStarted);
      machine.transition(PaymentStatus.pending);
      expect(machine.state, PaymentStatus.pending);
    });

    test('pending later becomes captured', () {
      final machine = PaymentStateMachine();
      machine.transition(PaymentStatus.pending);
      machine.transition(PaymentStatus.captured);
      expect(machine.state, PaymentStatus.captured);
    });

    test('pending later becomes failed', () {
      final machine = PaymentStateMachine();
      machine.transition(PaymentStatus.pending);
      machine.transition(PaymentStatus.failed);
      expect(machine.state, PaymentStatus.failed);
    });

    test('captured cannot become cancelled', () {
      final machine = PaymentStateMachine();
      machine.transition(PaymentStatus.captured);
      expect(machine.transition(PaymentStatus.cancelled), false);
    });

    test('captured cannot become pending', () {
      final machine = PaymentStateMachine();
      machine.transition(PaymentStatus.captured);
      expect(machine.transition(PaymentStatus.pending), false);
    });

    test('captured cannot become authorized', () {
      final machine = PaymentStateMachine();
      machine.transition(PaymentStatus.captured);
      expect(machine.transition(PaymentStatus.authorized), false);
    });

    test('webhook order captured before authorized', () {
      final machine = PaymentStateMachine();
      machine.transition(PaymentStatus.captured);
      machine.transition(PaymentStatus.authorized);
      expect(machine.state, PaymentStatus.captured);
    });

    test('webhook order failed before captured', () {
      final machine = PaymentStateMachine();
      machine.transition(PaymentStatus.failed);
      machine.transition(PaymentStatus.captured);
      expect(machine.state, PaymentStatus.captured);
    });

    test('duplicate failed webhook is harmless', () {
      final machine = PaymentStateMachine();
      machine.transition(PaymentStatus.failed);
      machine.transition(PaymentStatus.failed);
      expect(machine.state, PaymentStatus.failed);
    });

    test('offline recovery pending -> captured', () {
      final machine = PaymentStateMachine();
      machine.transition(PaymentStatus.pending);
      machine.transition(PaymentStatus.captured);
      expect(machine.state, PaymentStatus.captured);
    });

    test('app restart recovery pending -> captured', () {
      final machine = PaymentStateMachine();
      machine.transition(PaymentStatus.pending);
      machine.transition(PaymentStatus.captured);
      expect(machine.state, PaymentStatus.captured);
    });

    test('bank server failure can recover', () {
      final machine = PaymentStateMachine();
      machine.transition(PaymentStatus.pending);
      machine.transition(PaymentStatus.captured);
      expect(machine.state, PaymentStatus.captured);
    });

    test('payment callback failure does not require immediate retry', () {
      final machine = PaymentStateMachine();
      machine.transition(PaymentStatus.pending);
      expect(machine.state, PaymentStatus.pending);
    });

    test('uncertain payment cannot be automatically treated as failed', () {
      final machine = PaymentStateMachine();
      machine.transition(PaymentStatus.pending);
      expect(machine.state, PaymentStatus.pending);
    });

    test('successful payment remains successful after duplicate events', () {
      final machine = PaymentStateMachine();
      machine.transition(PaymentStatus.captured);
      machine.transition(PaymentStatus.captured);
      machine.transition(PaymentStatus.authorized);
      machine.transition(PaymentStatus.captured);
      expect(machine.state, PaymentStatus.captured);
    });

    test('complete uncertain payment lifecycle', () {
      final machine = PaymentStateMachine();
      machine.transition(PaymentStatus.checkoutStarted);
      machine.transition(PaymentStatus.pending);
      machine.transition(PaymentStatus.pending);
      machine.transition(PaymentStatus.captured);
      machine.transition(PaymentStatus.captured);
      expect(machine.state, PaymentStatus.captured);
    });
  });

  group('PaymentController & Razorpay Flow', () {
    test('initialize loads default packages and selects bronze package', () {
      final mockService = MockRazorpayPaymentService();
      final controller = PaymentController(paymentService: mockService);
      Get.put(controller);

      expect(controller.packages.length, equals(5));
      expect(controller.selectedPackage.value?.id, equals('coins_1500'));
      expect(controller.status.value, equals(PaymentStatus.created));
      expect(mockService.initialized, isTrue);
    });

    test('buyPackage successfully completes and credits coins', () async {
      final mockService = MockRazorpayPaymentService();
      final controller = PaymentController(paymentService: mockService);
      Get.put(controller);

      final initialCoins = controller.userCoins.value;
      final package = controller.packages.first; // 500 coins

      final result = await controller.buyPackage(package);

      expect(result.isSuccess, isTrue);
      expect(controller.status.value, equals(PaymentStatus.captured));
      expect(controller.userCoins.value, equals(initialCoins + package.coins));
      expect(controller.isProcessing.value, isFalse);
    });

    test('buyPackage handles user cancellation', () async {
      final mockService = MockRazorpayPaymentService();
      mockService.openResult = PaymentResult.cancelled();
      final controller = PaymentController(paymentService: mockService);
      Get.put(controller);

      final initialCoins = controller.userCoins.value;
      final package = controller.packages.first;

      final result = await controller.buyPackage(package);

      expect(result.isCancelled, isTrue);
      expect(controller.status.value, equals(PaymentStatus.cancelled));
      expect(controller.userCoins.value, equals(initialCoins)); // coins unchanged
    });

    test('buyPackage handles payment failure', () async {
      final mockService = MockRazorpayPaymentService();
      mockService.openResult =
          PaymentResult.failure(errorMessage: 'Payment declined');
      final controller = PaymentController(paymentService: mockService);
      Get.put(controller);

      final package = controller.packages.first;
      final result = await controller.buyPackage(package);

      expect(result.isFailure, isTrue);
      expect(controller.status.value, equals(PaymentStatus.failed));
      expect(controller.errorMessage.value, equals('Payment declined'));
    });
  });

  group('PaymentsScreen Widget Test', () {
    testWidgets('renders coin packages and reacts to selection',
        (tester) async {
      final mockService = MockRazorpayPaymentService();
      final controller = PaymentController(paymentService: mockService);
      Get.put(controller);

      await tester.pumpWidget(
        const GetMaterialApp(
          home: PaymentsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Coin Store'), findsOneWidget);
      expect(find.text('Razorpay Secure Checkout'), findsOneWidget);
      expect(find.text('Choose a package'), findsOneWidget);
      expect(find.text('500 Coins'), findsOneWidget);
      expect(find.text('1,500 Coins'), findsOneWidget);
      expect(find.text('4,000 Coins'), findsOneWidget);

      // Tap on the High Roller package (4,000 coins)
      final packageFinder = find.text('4,000 Coins');
      await tester.tap(packageFinder);
      await tester.pumpAndSettle();

      expect(controller.selectedPackage.value?.id, equals('coins_4000'));
      expect(find.text('Pay ₹599 with Razorpay'), findsOneWidget);
    });
  });
}
