import 'package:card_game/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class TurnGlow extends StatefulWidget {
  const TurnGlow({super.key, required this.active, required this.child});

  final bool active;
  final Widget child;

  @override
  State<TurnGlow> createState() => _TurnGlowState();
}

class _TurnGlowState extends State<TurnGlow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    if (widget.active) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant TurnGlow oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.active && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }

    if (!widget.active && _controller.isAnimating) {
      _controller.stop();
      _controller.value = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        final glow = widget.active ? _controller.value : 0;

        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              if (widget.active)
                BoxShadow(
                  color: AppColors.gold.withValues(alpha: 0.7),
                  blurRadius: 14 + glow * 18,
                  spreadRadius: 2 + glow * 8,
                ),
            ],
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
