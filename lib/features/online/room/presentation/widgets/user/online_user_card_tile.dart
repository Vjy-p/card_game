import 'package:card_game/core/responsive/get_device.dart';
import 'package:card_game/features/online/room/models/card_model.dart';
import 'package:card_game/features/online/room/presentation/widgets/online_card_face.dart';
import 'package:flutter/material.dart';

class OnlineUserCardTile extends StatelessWidget {
  const OnlineUserCardTile({
    super.key,
    required this.index,
    required this.card,
    required this.isLocked,
    required this.isSelected,
    required this.onTap,
  });

  final int index;
  final CardModel card;
  final bool isLocked;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isMobile = GetDevice.isMobile(context);
    final isTablet = GetDevice.isTablet(context);

    return AnimatedPositioned(
      top: isSelected ? -40 : 0,
      left: isMobile
          ? index * 24.0
          : isTablet
          ? index * 32.0
          : index * 48.0,
      duration: const Duration(milliseconds: 250),
      child: SizedBox(
        width: 65,
        child: GestureDetector(
          onTap: isLocked ? null : onTap,
          child: AspectRatio(
            aspectRatio: 0.656,
            child: OnlineCardFace(
              card: card,
              isLocked: isLocked,
            ),
          ),
        ),
      ),
    );
  }
}
