import 'package:card_game/features/online/table/controller/online_game_controller.dart';
import 'package:card_game/features/online/table/presentation/widgets/online_card_face.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnlineUserCardTile extends GetView<OnlineGameController> {
  const OnlineUserCardTile({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isLocked = controller.fourthCard.any(
        (e) => e.id == controller.myHand[index].id,
      );
      return AnimatedPositioned(
        top: controller.selectedCard.value?.id == controller.myHand[index].id
            ? -40
            : 0,
        left: index * 24.0,
        duration: const Duration(milliseconds: 250),
        child: SizedBox(
          width: 65,
          child: GestureDetector(
            onTap: isLocked
                ? null
                : () {
                    controller.selectCard(card: controller.myHand[index]);
                  },
            child: AspectRatio(
              aspectRatio: 0.656,
              child: OnlineCardFace(
                card: controller.myHand[index],
                isLocked: isLocked,
              ),
            ),
          ),
        ),
      );
    });
  }
}
