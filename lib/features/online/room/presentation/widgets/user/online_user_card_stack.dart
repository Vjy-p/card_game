import 'package:card_game/features/online/room/controllers/online_game_controller.dart';
import 'package:card_game/features/online/room/presentation/widgets/user/online_user_card_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnlineUserCardStack extends GetView<OnlineGameController> {
  const OnlineUserCardStack({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final myHand = controller.myHand;
      final selectedCardId = controller.selectedCard.value?.id;
      final lockedCardIds = controller.fourthCard.map((c) => c.id).toSet();

      return SizedBox(
        key: controller.handKey,
        width: Get.width,
        child: Stack(
          clipBehavior: Clip.none,
          children: List.generate(myHand.length, (index) {
            final card = myHand[index];
            return OnlineUserCardTile(
              key: ValueKey(card.id),
              index: index,
              card: card,
              isLocked: lockedCardIds.contains(card.id),
              isSelected: selectedCardId == card.id,
              onTap: () => controller.selectCard(card: card),
            );
          }),
        ),
      );
    });
  }
}
