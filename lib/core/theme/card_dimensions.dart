import 'package:flutter/material.dart';

class CardDimensions {
  CardDimensions._();

  static const double aspectRatio = 0.70;

  static const double borderRadius = 10;

  static const double elevation = 4;

  static double width(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    if (w < 400) {
      return 54;
    }

    if (w < 700) {
      return 68;
    }

    return 82;
  }

  static double height(BuildContext context) {
    return width(context) / aspectRatio;
  }
}
