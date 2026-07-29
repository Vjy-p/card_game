import 'package:flutter/material.dart';

class CustomLoading extends StatelessWidget {
  const CustomLoading({
    super.key,
    this.strokeWidth,
    this.dimension,
    this.color,
  });
  final double? strokeWidth;
  final double? dimension;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.square(
        dimension: dimension ?? 24,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth ?? 2.5,
          semanticsLabel: 'Starting game',
          color: color,
        ),
      ),
    );
  }
}
