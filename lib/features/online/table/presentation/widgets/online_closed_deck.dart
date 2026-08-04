import 'dart:async';
import 'dart:developer';

import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/core/theme/app_motion.dart';
import 'package:card_game/core/theme/card_dimensions.dart';
import 'package:card_game/features/offline/presentation/widgets/cards/card_back.dart';
import 'package:flutter/material.dart';

class OnlineClosedDeck extends StatefulWidget {
  const OnlineClosedDeck({
    super.key,
    required this.remainingCards,
    required this.enabled,
    required this.onTap,
  });

  final int remainingCards;
  final bool enabled;
  final VoidCallback onTap;

  @override
  State<OnlineClosedDeck> createState() => _ClosedDeckState();
}

class _ClosedDeckState extends State<OnlineClosedDeck>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;
  bool initialise = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: AppMotion.fast, vsync: this);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );
    initialLoad();
  }

  void initialLoad() {
    timer = Timer.periodic(Duration(milliseconds: 300), (Timer t) {
      if (t.tick <= 10) {
        log('time ${t.tick}');
        setState(() {});
      } else {
        timer?.cancel();
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!widget.enabled) return;

    _controller.forward().then((_) {
      _controller.reverse();
    });
    widget.onTap();
  }

  void _setHovered(bool value) {
    if (!widget.enabled) return;
    setState(() => _isHovered = value);
  }

  @override
  Widget build(BuildContext context) {
    final cardWidth = CardDimensions.width(context);
    final cardHeight = CardDimensions.height(context);
    const stackCount = 10;
    const stackOffset = 4.0;

    return ((timer?.tick ?? 12) < 11)
        ? SizedBox(
            width: cardWidth + (stackOffset * (10 - (timer?.tick ?? 0))) * 1,
            height: cardHeight,
            child: Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              clipBehavior: Clip.antiAlias,
              direction: Axis.horizontal,
              spacing: -48,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: List.generate(12 - (timer?.tick ?? 0), (index) {
                return Container(
                  width: cardWidth,
                  height: cardHeight,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade900,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.white54),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: CardBack(),
                );
              }),
            ),
          )
        : Tooltip(
            message: widget.enabled
                ? 'Draw a card (${widget.remainingCards})'
                : 'No cards available',
            child: MouseRegion(
              onEnter: (_) => _setHovered(true),
              onExit: (_) => _setHovered(false),
              cursor: widget.enabled
                  ? SystemMouseCursors.click
                  : MouseCursor.defer,
              child: GestureDetector(
                onTap: _handleTap,
                child: AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: child,
                    );
                  },
                  child: AnimatedOpacity(
                    opacity: widget.enabled ? 1.0 : 0.5,
                    duration: AppMotion.fast,
                    child: SizedBox(
                      width: cardWidth + (stackOffset * (stackCount - 1)) * 1,
                      height: cardHeight,

                      child: Stack(
                        alignment: AlignmentGeometry.center,
                        children: List.generate(
                          widget.remainingCards >= stackCount
                              ? stackCount
                              : widget.remainingCards,
                          (index) {
                            if ((widget.remainingCards >= 10 &&
                                    index + 1 == 10) ||
                                (widget.remainingCards < 10 &&
                                    index + 1 == widget.remainingCards)) {
                              return Positioned(
                                left: index * stackOffset,
                                child: _buildCardBackWithShadow(
                                  width: cardWidth,
                                  height: cardHeight,
                                  isHovered: _isHovered && widget.enabled,
                                  elevation: 4,
                                ),
                              );
                            }

                            return Positioned(
                              left: index * stackOffset,
                              child: Container(
                                width: cardWidth,
                                height: cardHeight,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey.shade900,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.white54),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: CardBack(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  Widget _buildCardBackWithShadow({
    required double width,
    required double height,
    required bool isHovered,
    required int elevation,
  }) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade900,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white54),
        boxShadow: [
          // Primary shadow
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25 + (elevation * 0.05)),
            blurRadius: 4 + (elevation * 1.5),
            offset: Offset(0, 2.0 + elevation),
          ),
          // Accent glow when hovered and enabled
          if (isHovered && widget.enabled)
            BoxShadow(
              color: AppColors.actionPrimary.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 0),
            ),
        ],
      ),
      clipBehavior: Clip.antiAlias,

      child: const CardBack(),
    );
  }
}
