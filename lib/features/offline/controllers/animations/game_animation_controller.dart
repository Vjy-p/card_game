import 'package:get/get.dart';

typedef AnimationTask = Future<void> Function();

class GameAnimationController extends GetxService {
  final RxBool isDealing = false.obs;
  final RxBool isAnimating = false.obs;

  void startDealing() => isDealing.value = true;
  void stopDealing() => isDealing.value = false;

  Future<void> playInitialDeal() async {}

  Future<void> animateDrawCard() async {}

  Future<void> animateTakeOpenCard() async {}

  Future<void> animateDiscard() async {}

  Future<void> animateDeclare() async {}

  Future<void> animateWin() async {}
}
