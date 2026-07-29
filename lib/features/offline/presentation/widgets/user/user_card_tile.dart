import 'package:card_game/features/offline/controllers/game_controller.dart';
import 'package:card_game/features/offline/presentation/widgets/cards/card_face.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserCardTile extends StatelessWidget {
  const UserCardTile({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GameController>();
    return Obx(() {
      final bool isLocked = controller.players.first.fourthCard.any(
        (e) => e.id == controller.table.myCards[index].id,
      );
      return AnimatedPositioned(
        top: controller.selectedCard?.id == controller.table.myCards[index].id
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
                    controller.selectCard(controller.table.myCards[index]);
                  },
            child: AspectRatio(
              aspectRatio: 0.656,
              child: CardFace(
                card: controller.table.myCards[index],
                isLocked: isLocked,
              ),
            ),
          ),
        ),
      );
    });
  }
}
