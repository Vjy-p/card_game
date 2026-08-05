import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/core/theme/app_radius.dart';
import 'package:card_game/features/offline/presentation/widgets/cards/card_back.dart';
import 'package:card_game/features/online/room/models/card_model.dart';
import 'package:card_game/features/online/room/models/online_player_view_data.dart';
import 'package:card_game/features/online/room/presentation/widgets/online_player_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OnlineOpenCard extends StatefulWidget {
  const OnlineOpenCard({
    super.key,
    required this.card,
    required this.enabled,
    required this.onTap,
  });

  final CardModel? card;
  final bool enabled;
  final VoidCallback onTap;

  @override
  State<OnlineOpenCard> createState() => _OpenPileState();
}

class _OpenPileState extends State<OnlineOpenCard> {
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
          onTap: widget.enabled ? widget.onTap : null,
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
                        child: OnlinePlayerCardWidget(
                          data: OnlinePlayerViewData(
                            card: widget.card!,
                            selected: false,
                          ),
                        ),
                      )
                      .animate(delay: Duration(milliseconds: 1200))
                      .custom(
                        duration: 1000.ms,
                        builder: (context, value, child) {
                          return value == 1 ? child : CardBack();
                        },
                      )
                      .slide(
                        curve: Curves.easeOut,
                        begin: Offset(-0.1, -1.15),
                        end: Offset(0, 0),
                        duration: Duration(milliseconds: 1000),
                      )
                      .then(delay: (-700).ms)
                      .flipH(),
            ),
          ),
        ),
      ),
    );
  }
}
