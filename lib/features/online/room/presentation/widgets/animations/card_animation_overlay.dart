import 'dart:ui';

import 'package:card_game/core/theme/card_dimensions.dart';
import 'package:card_game/features/offline/presentation/widgets/cards/card_back.dart';
import 'package:card_game/features/online/room/controllers/online_game_controller.dart';
import 'package:card_game/features/online/room/models/card_animation_type.dart';
import 'package:card_game/features/online/room/models/online_player_view_data.dart';
import 'package:card_game/features/online/room/presentation/widgets/online_player_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardAnimationOverlay extends StatefulWidget {
  const CardAnimationOverlay({super.key});

  @override
  State<CardAnimationOverlay> createState() => _CardAnimationOverlayState();
}

class _CardAnimationOverlayState extends State<CardAnimationOverlay>
    with SingleTickerProviderStateMixin {
  final controller = Get.find<OnlineGameController>();

  late final AnimationController animationController;
  late final Animation<double> animation;
  late final Worker _flightWorker;

  Offset? start;
  Offset? end;
  Offset? control;

  // Which flight is currently being shown, so build() knows how to render it
  CardFlight? _activeFlight;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOutCubic,
    );

    _flightWorker = ever(controller.cardFlight, (CardFlight? flight) {
      if (flight == null) return;
      _prepareAnimation(flight);
    });
  }

  Offset _center(GlobalKey key) {
    final box = key.currentContext!.findRenderObject() as RenderBox;
    return box.localToGlobal(box.size.center(Offset.zero));
  }

  /// New cards land at the end of the hand fan (right side), not the
  /// center of the whole hand widget - so target a point near the right
  /// edge instead of dead center. Tweak `widthFraction`/`heightFraction`
  /// to match where your fan actually lands visually.
  Offset _handTarget(GlobalKey key) {
    final box = key.currentContext!.findRenderObject() as RenderBox;
    final size = box.size;

    const widthFraction = 0.88; // how far right, 1.0 = far edge
    const heightFraction =
        0.05; // vertical anchor within the hand box (0 = top, 1 = bottom)

    final local = Offset(
      size.width * widthFraction,
      size.height * heightFraction,
    );
    return box.localToGlobal(local);
  }

  Future<void> _prepareAnimation(CardFlight flight) async {
    switch (flight.type) {
      case CardAnimationType.drawFromDeck:
        start = _center(controller.deckKey);
        break;

      case CardAnimationType.drawFromOpen:
        start = _center(controller.openCardKey);
        break;

      default:
        return;
    }

    end = _handTarget(controller.handKey);

    // Arc peak should sit at the horizontal MIDPOINT between start and end,
    // not their sum - that's what was throwing the curve off before.
    final double midX = (start!.dx + end!.dx) / 2;
    final double arcHeight = 120;
    control = Offset(
      midX,
      (start!.dy < end!.dy ? start!.dy : end!.dy) - arcHeight,
    );

    _activeFlight = flight;
    setState(() {});

    await animationController.forward();

    animationController.reset();
    _activeFlight = null;
    controller.cardFlight.value = null;
  }

  Offset _bezier(double t) {
    final p0 = start!;
    final p1 = control!;
    final p2 = end!;

    final x =
        (1 - t) * (1 - t) * p0.dx + 2 * (1 - t) * t * p1.dx + t * t * p2.dx;
    final y =
        (1 - t) * (1 - t) * p0.dy + 2 * (1 - t) * t * p1.dy + t * t * p2.dy;

    return Offset(x, y);
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Obx(() {
        final flight = controller.cardFlight.value;

        if (flight == null ||
            start == null ||
            end == null ||
            control == null ||
            _activeFlight == null) {
          return const SizedBox();
        }

        return AnimatedBuilder(
          animation: animation,
          builder: (_, _) {
            final offset = _bezier(animation.value);
            final rotation = lerpDouble(.20, 0, animation.value)!;
            final scale = lerpDouble(.92, 1, animation.value)!;
            // Quick fade-in so the card doesn't pop in abruptly at the start.
            final opacity = Curves.easeOut.transform(
              (animation.value / 0.25).clamp(0.0, 1.0),
            );

            final bool isDeckDraw =
                _activeFlight!.type == CardAnimationType.drawFromDeck;

            return Stack(
              children: [
                Positioned(
                  left: offset.dx,
                  top: offset.dy,
                  child: Opacity(
                    opacity: opacity,
                    child: Transform.rotate(
                      angle: rotation,
                      child: Transform.scale(
                        scale: scale,
                        child: Material(
                          color: Colors.transparent,
                          elevation: 12,
                          child: SizedBox(
                            height: CardDimensions.height(context),
                            width: CardDimensions.width(context),
                            // Deck draws don't know the card face yet, so
                            // fly a card back instead of a blank/null card.
                            // Open-card draws already know the face.
                            child: isDeckDraw
                                ? const CardBack()
                                : OnlinePlayerCardWidget(
                                    data: OnlinePlayerViewData(
                                      card: _activeFlight!.card,
                                      selected: false,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }),
    );
  }

  @override
  void dispose() {
    _flightWorker.dispose();
    animationController.dispose();
    super.dispose();
  }
}
