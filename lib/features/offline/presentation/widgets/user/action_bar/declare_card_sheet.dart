import 'dart:developer';

import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/core/theme/app_spacing.dart';
import 'package:card_game/features/offline/controllers/game_controller.dart';
import 'package:card_game/features/offline/models/playing_card.dart';
import 'package:card_game/features/offline/presentation/widgets/cards/card_face.dart';
import 'package:card_game/features/offline/presentation/widgets/user/action_bar/action_button.dart';
import 'package:card_game/utils/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeclareCardSheet extends StatefulWidget {
  const DeclareCardSheet({
    super.key,
    required this.cards,
    required this.fourthCard,
  });
  final List<PlayingCard> cards;
  final List<PlayingCard> fourthCard;

  @override
  State<DeclareCardSheet> createState() => _DeclareCardSheetState();
}

class _DeclareCardSheetState extends State<DeclareCardSheet> {
  late List<PlayingCard> availableCards;
  // Updated to hold PlayingCard objects instead of ints
  List<List<PlayingCard>> cardSets = List.generate(4, (_) => []);

  bool _isShowing = false;

  @override
  void initState() {
    super.initState();
    availableCards = List.from(widget.cards);
    if (widget.fourthCard.length == 4) {
      for (PlayingCard card in widget.fourthCard) {
        availableCards.removeWhere((e) => e.id == card.id);
      }
    }
    cardSets[0] = List.from(widget.fourthCard);
    // Trigger staggered entrance
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) setState(() => _isShowing = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GameController>(
      builder: (controller) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: AppColors.backgroundSecondary,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            // spacing: AppSpacing.xs,
            children: [
              // Drag Handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                height: 5,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: const Text(
                        'Declare Sets',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    MaterialButton(
                      minWidth: 30,
                      height: 30,
                      shape: CircleBorder(),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                      color: AppColors.textMuted,
                      child: const Icon(Icons.close, size: 16),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              // TOP AREA: The 4 Sets
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemCount: 4,
                    itemBuilder: (context, index) => _buildDragTarget(index),
                  ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'DRAG CARDS TO SETS',
                  style: TextStyle(
                    letterSpacing: 1.2,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
              ),

              // BOTTOM AREA: The Available Pile
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfacePrimary,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Wrap(
                      spacing: -26,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: List.generate(availableCards.length, (index) {
                        return _buildDraggableCard(
                          availableCards[index],
                          index,
                        );
                      }),
                    ),
                  ),
                ),
              ),
              // Action Button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  spacing: AppSpacing.xs,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ActionButton(
                        onPressed: () {
                          Get.back();
                        },
                        label: 'Back',
                        icon: Icon(Icons.arrow_back_ios, size: 18),
                      ),
                    ),
                    Expanded(
                      child: ActionButton(
                        onPressed: () {
                          final bool resp = controller.validateEndGame(
                            sets: cardSets,
                          );
                          if (resp) {
                            log('you won the game');
                            Get.back();
                          } else {
                            customToast(message: 'Wrong sets');
                          }
                        },
                        label: 'Declare',
                        icon: Icon(Icons.check_circle, size: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDragTarget(int setIndex) {
    final bool isLocked =
        setIndex == 0 &&
        cardSets.isNotEmpty &&
        widget.fourthCard.isNotEmpty &&
        cardSets.first.length == 4;
    return IgnorePointer(
      ignoring: isLocked,
      child: DragTarget<PlayingCard>(
        onWillAcceptWithDetails: (data) => true,
        onAcceptWithDetails: (details) {
          if (cardSets[setIndex].length < 3) {
            cardSets[setIndex].add(details.data);
            availableCards.remove(details.data);
          } else if (!cardSets.any((e) => e.length == 4)) {
            cardSets[setIndex].add(details.data);
            availableCards.remove(details.data);
          } else {
            customToast(message: 'Set is Full');
          }

          setState(() {});
        },
        builder: (context, candidateData, rejectedData) {
          final bool isHovering = candidateData.isNotEmpty;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: isHovering
                  ? AppColors.surfaceElevated
                  : AppColors.surfacePrimary,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isHovering
                    ? AppColors.surfaceElevated
                    : AppColors.surfacePrimary,
                width: isHovering ? 2 : 1,
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(
                    'SET ${setIndex + 1}',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Stack(
                      alignment: AlignmentGeometry.center,
                      children: [
                        Wrap(
                          spacing: -24, // Overlap cards visually
                          runSpacing: 4,
                          alignment: WrapAlignment.center,
                          children: cardSets[setIndex].map((card) {
                            return GestureDetector(
                              onTap: () {
                                // Tap to return card to pile
                                setState(() {
                                  cardSets[setIndex].remove(card);
                                  availableCards.add(card);
                                });
                              },
                              child: _buildMiniCard(card),
                            );
                          }).toList(),
                        ),
                        if (isLocked)
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.darkBlue.withValues(alpha: 0.3),
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.lock,
                              color: AppColors.backgroundSecondary.withValues(
                                alpha: 0.7,
                              ),
                              size: 24,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDraggableCard(PlayingCard card, int index) {
    return AnimatedScale(
      duration: Duration(milliseconds: 300 + (index * 40)),
      scale: _isShowing ? 1.0 : 0.0,
      curve: Curves.easeOutBack,
      child: Draggable<PlayingCard>(
        data: card,
        feedback: _CardWidget(card: card, isDragging: true),
        childWhenDragging: Opacity(
          opacity: 0.3,
          child: _CardWidget(card: card),
        ),
        child: _CardWidget(card: card),
      ),
    );
  }

  Widget _buildMiniCard(PlayingCard card) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 300),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double scale, child) {
        return Transform.scale(
          scale: scale,
          child: Container(
            width: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 2),
              ],
            ),
            child: AspectRatio(
              aspectRatio: 5 / 7,
              child: CardFace(card: card),
            ),
          ),
        );
      },
    );
  }
}

class _CardWidget extends StatelessWidget {
  final PlayingCard card;
  final bool isDragging;
  const _CardWidget({required this.card, this.isDragging = false});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Transform.rotate(
        angle: isDragging ? 0.05 : 0,
        child: Container(
          width: 55,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: isDragging ? Colors.black26 : Colors.black12,
                blurRadius: isDragging ? 12 : 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          // Using your CardFace widget inside the container
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CardFace(card: card),
          ),
        ),
      ),
    );
  }
}
