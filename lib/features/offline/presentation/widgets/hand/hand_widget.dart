import 'package:card_game/features/offline/presentation/widgets/hand/hand_flow.dart';
import 'package:flutter/material.dart';

class HandLayout extends StatelessWidget {
  const HandLayout({
    super.key,
    required this.children,
    this.maxOverlap = 0.45,
    this.padding = const EdgeInsets.symmetric(horizontal: 8),
  });

  final List<Widget> children;

  /// 0.0 = no overlap
  /// 0.45 = 45% overlap
  final double maxOverlap;

  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Flow(
        delegate: HandFlowDelegate(
          cardCount: children.length,
          maxOverlap: maxOverlap,
        ),
        children: children,
      ),
    );
  }
}
