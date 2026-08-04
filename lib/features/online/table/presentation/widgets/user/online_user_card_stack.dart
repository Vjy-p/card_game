import 'dart:developer';

import 'package:card_game/features/online/table/controller/online_game_controller.dart';
import 'package:card_game/features/online/table/presentation/widgets/user/online_user_card_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnlineUserCardStack extends GetView<OnlineGameController> {
  const OnlineUserCardStack({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SizedBox(
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
