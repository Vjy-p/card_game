import 'dart:developer';

import 'package:card_game/core/theme/app_colors.dart';
import 'package:card_game/utils/constants/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NativeAdWidget extends StatefulWidget {
  const NativeAdWidget({super.key});

  @override
  State<NativeAdWidget> createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget> {
  NativeAd? nativeAd;
  bool loaded = false;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadAd();
    });
  }

  void loadAd() {
    try {
      nativeAd = NativeAd(
        adUnitId: Constants.nativeBannerAdUnitId,
        // adUnitId: Constants.nativeBannerTestAdUnitId,
        // factoryId: 'nativeFactory',
        request: const AdRequest(),
        nativeAdOptions: NativeAdOptions(
          mediaAspectRatio: MediaAspectRatio.square,
        ),
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            if (!mounted) return;
            setState(() {
              loaded = true;
            });
            log('ad loaded $ad');
          },
          onAdFailedToLoad: (ad, err) {
            ad.dispose();
            loaded = false;
            isError = true;
            setState(() {});
            log('error add $err');
          },
        ),

        nativeTemplateStyle: NativeTemplateStyle(
          // Required: Choose a template.
          templateType: TemplateType.small,
          mainBackgroundColor: AppColors.backgroundPrimary,
          cornerRadius: 10.0,
          callToActionTextStyle: NativeTemplateTextStyle(
            textColor: AppColors.textPrimary,
            backgroundColor: AppColors.surfaceElevated,
            style: NativeTemplateFontStyle.monospace,
            size: 12,
          ),
          primaryTextStyle: NativeTemplateTextStyle(
            textColor: AppColors.textPrimary,
            backgroundColor: Colors.transparent,
            style: NativeTemplateFontStyle.italic,
            size: 12,
          ),
          secondaryTextStyle: NativeTemplateTextStyle(
            textColor: AppColors.textMuted,
            backgroundColor: Colors.black,
            style: NativeTemplateFontStyle.bold,
            size: 12,
          ),
          tertiaryTextStyle: NativeTemplateTextStyle(
            textColor: AppColors.lightTextPrimary,
            backgroundColor: AppColors.gold,
            style: NativeTemplateFontStyle.normal,
            size: 11,
          ),
        ),
      );

      nativeAd?.load();

      setState(() {});
    } catch (e, stackTree) {
      log('error add $e $stackTree');
      loaded = false;
      isError = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return loaded && !isError
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: AspectRatio(
              aspectRatio: Get.width / 90,
              child: AdWidget(
                ad: nativeAd!,
              ).animate().fadeIn().scaleY(begin: -0.2),
            ),
          )
        : const SizedBox.shrink();
  }

  @override
  void dispose() {
    nativeAd?.dispose();
    super.dispose();
  }
}
