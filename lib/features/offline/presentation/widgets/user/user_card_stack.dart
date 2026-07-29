import 'package:card_game/features/offline/controllers/game_controller.dart';
import 'package:card_game/features/offline/presentation/widgets/user/user_card_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserCardStack extends StatefulWidget {
  const UserCardStack({super.key});

  @override
  State<UserCardStack> createState() => _UserCardStackState();
}

class _UserCardStackState extends State<UserCardStack> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<GameController>(
      builder: (controller) {
        return SizedBox(
          width: Get.width,
          child: Stack(
            clipBehavior: Clip.none,
            children: List.generate(controller.table.myCards.length, (index) {
              return UserCardTile(index: index);
            }),
          ),
        );
      },
    );
  }
}
