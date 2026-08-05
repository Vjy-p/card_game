import 'package:card_game/features/online/room/controllers/online_game_controller.dart';
import 'package:card_game/features/online/room/presentation/widgets/user/online_action_bar.dart';
import 'package:card_game/features/online/room/presentation/widgets/user/online_user_card_stack.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnlineUserWidget extends GetView<OnlineGameController> {
  const OnlineUserWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        OnlineUserCardStack(),
        Align(
          alignment: AlignmentGeometry.bottomCenter,
          child: OnlineActionBar(),
        ),
      ],
    );
  }
}
