import 'package:flutter/material.dart';

class OpponentThinking extends StatelessWidget {
  const OpponentThinking({super.key});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.4, end: 1),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
      builder: (_, value, child) {
        return Opacity(opacity: value, child: child);
      },
      onEnd: () {},
      child: const Text(
        'Thinking...',
        style: TextStyle(
          color: Colors.orangeAccent,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
