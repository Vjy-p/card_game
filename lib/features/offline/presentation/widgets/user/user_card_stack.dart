import 'package:card_game/features/offline/controllers/game_controller.dart';
import 'package:card_game/features/offline/presentation/widgets/user/user_card_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserCardStack extends StatelessWidget {
  const UserCardStack({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GameController>();

    return Obx(() {
      final myCards = controller.table.myCards;
      final selectedCardId = controller.selectedCard?.id;
      final lockedCardIds = controller.players.first.fourthCard
          .map((c) => c.id)
          .toSet();

      return SizedBox(
        width: Get.width,
        child: Stack(
          clipBehavior: Clip.none,
          children: List.generate(myCards.length, (index) {
            final card = myCards[index];
            return UserCardTile(
              key: ValueKey(card.id),
              index: index,
              card: card,
              isLocked: lockedCardIds.contains(card.id),
              isSelected: selectedCardId == card.id,
              onTap: () => controller.selectCard(card),
            );
          }),
        ),
      );
    });
  }
}
