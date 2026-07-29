import 'dart:math';

import 'package:flutter/material.dart';

class HandFlowDelegate extends FlowDelegate {
  HandFlowDelegate({required this.cardCount, required this.maxOverlap});

  final int cardCount;

  final double maxOverlap;

  @override
  void paintChildren(FlowPaintingContext context) {
    if (cardCount == 0) {
      return;
    }

    final cardWidth = context.getChildSize(0)!.width;

    final availableWidth = context.size.width;

    double spacing = cardWidth;

    if (cardCount > 1) {
      spacing = (availableWidth - cardWidth) / (cardCount - 1);

      final minimumSpacing = cardWidth * (1 - maxOverlap);

      spacing = max(spacing, minimumSpacing);

      spacing = min(spacing, cardWidth);
    }

    for (int i = 0; i < cardCount; i++) {
      context.paintChild(
        i,
        transform: Matrix4.translationValues(i * spacing, 0, 0),
      );
    }
  }

  @override
  Size getSize(BoxConstraints constraints) {
    return Size(constraints.maxWidth, constraints.maxHeight);
  }

  @override
  bool shouldRepaint(covariant HandFlowDelegate oldDelegate) {
    return cardCount != oldDelegate.cardCount ||
        maxOverlap != oldDelegate.maxOverlap;
  }
}
