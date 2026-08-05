import 'package:card_game/core/responsive/responsive_value.dart';
import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/core/theme/app_motion.dart';
import 'package:card_game/core/theme/app_spacing.dart';
import 'package:card_game/features/splash/controllers/splash_controller.dart';
import 'package:card_game/features/splash/presentation/widgets/splash_brand_mark.dart';
import 'package:card_game/utils/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final SplashController _controller = Get.put(SplashController());

  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: AppMotion.emphasized,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: AppMotion.standardCurve,
    );

    _scaleAnimation = Tween<double>(begin: 0.94, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: AppMotion.emphasizedCurve,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _start();
    });
  }

  Future<void> _start() async {
    final mediaQuery = MediaQuery.of(context);

    if (mediaQuery.disableAnimations) {
      _animationController.value = 1;
    } else {
      await _animationController.forward();
    }

    if (!mounted) return;

    await _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.backgroundSecondary,
              AppColors.backgroundPrimary,
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final markSize = responsiveValue<double>(
                width: constraints.maxWidth,
                smallPhone: 104,
                phone: 124,
                largePhone: 136,
                tablet: 156,
                desktop: 168,
              );

              final titleSize = responsiveValue<double>(
                width: constraints.maxWidth,
                smallPhone: 34,
                phone: 40,
                largePhone: 44,
                tablet: 48,
                desktop: 52,
              );

              return Semantics(
                container: true,
                label: 'Card Game',
                value: 'Starting game',
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SplashBrandMark(size: markSize),
                            const SizedBox(height: AppSpacing.xl),
                            Text(
                              'CARD GAME',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.displayMedium
                                  ?.copyWith(
                                    fontSize: titleSize,
                                    letterSpacing: 1.2,
                                  ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'Match ranks. Unlock the joker. Win the table.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: AppSpacing.xxl),
                            const CustomLoading(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
