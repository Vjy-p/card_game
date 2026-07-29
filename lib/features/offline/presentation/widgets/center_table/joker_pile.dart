import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/core/theme/app_radius.dart';
import 'package:card_game/features/offline/models/playing_card.dart';
import 'package:card_game/features/offline/models/playing_card_view_data.dart';
import 'package:card_game/features/offline/presentation/widgets/cards/playing_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class JokerPile extends StatefulWidget {
  const JokerPile({
    super.key,
    required this.card,
    required this.enabled,
    required this.onTap,
  });

  final PlayingCard? card;
  final bool enabled;
  final VoidCallback onTap;

  @override
  State<JokerPile> createState() => _OpenPileState();
}

class _OpenPileState extends State<JokerPile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    if (widget.card == null) {
      return SizedBox(
        width: 72,
        height: 100,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(
              color: AppColors.textMuted.withValues(alpha: 0.3),
              width: 2,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
          ),
          child: Center(
            child: Text(
              'Empty',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textMuted,
                fontSize: 10,
              ),
            ),
          ),
        ),
      );
    }

    return Tooltip(
      message: widget.enabled ? 'Take open card' : 'Cannot take card',
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedOpacity(
            opacity: widget.enabled ? 1 : 0.45,
            duration: const Duration(milliseconds: 200),
            child: AnimatedScale(
              scale: _isHovered && widget.enabled ? 1.08 : 1.0,
              duration: const Duration(milliseconds: 200),
              child:
                  Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppRadius.card),
                          boxShadow: [
                            BoxShadow(
                              color: widget.enabled
                                  ? AppColors.actionPrimary.withValues(
                                      alpha: 0.4,
                                    )
                                  : Colors.black.withValues(alpha: 0.2),
                              blurRadius: _isHovered && widget.enabled ? 12 : 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: PlayingCardWidget(
                          data: PlayingCardViewData(
                            card: widget.card!,
                            selected: false,
                            faceUp: widget.enabled,
                          ),
                        ),
                      )
                      .animate(delay: Duration(milliseconds: 1200))
                      .slide(
                        curve: Curves.easeOut,
                        begin: Offset(0.5, -1.2),
                        end: Offset(0, 0),
                        duration: Duration(milliseconds: 1300),
                      ),
            ),
          ),
        ),
      ),
    );
  }
}
