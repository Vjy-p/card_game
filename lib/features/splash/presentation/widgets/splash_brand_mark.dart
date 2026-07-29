import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/core/theme/app_radius.dart';
import 'package:flutter/material.dart';

class SplashBrandMark extends StatelessWidget {
  const SplashBrandMark({required this.size, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Transform.rotate(
              angle: -0.16,
              child: _CardTile(
                size: size * 0.7,
                offset: Offset(-size * 0.11, size * 0.03),
                child: const Text(
                  '♠',
                  style: TextStyle(color: AppColors.cardBlack),
                ),
              ),
            ),
            Transform.rotate(
              angle: 0.16,
              child: _CardTile(
                size: size * 0.7,
                offset: Offset(size * 0.11, -size * 0.03),
                child: const Text(
                  '♥',
                  style: TextStyle(color: AppColors.cardRed),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardTile extends StatelessWidget {
  const _CardTile({
    required this.size,
    required this.offset,
    required this.child,
  });

  final double size;
  final Offset offset;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: offset,
      child: Container(
        width: size,
        height: size * 1.35,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.card),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: DefaultTextStyle.merge(
          style: TextStyle(fontSize: size * 0.42, fontWeight: FontWeight.w700),
          child: child,
        ),
      ),
    );
  }
}
