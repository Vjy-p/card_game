import 'dart:developer';

import 'package:card_game/features/online/room/controllers/online_game_controller.dart';
import 'package:card_game/features/online/room/presentation/widgets/user/online_user_card_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnlineUserCardStack extends GetView<OnlineGameController> {
  const OnlineUserCardStack({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SizedBox(
        key: controller.handKey,
        width: Get.width,
        child: Stack(
          clipBehavior: Clip.none,
          children: List.generate(controller.myHand.length, (index) {
            log('card length ${controller.myHand.length}');
            return OnlineUserCardTile(index: index);
          }),
        ),
      );
    });
  }
}
