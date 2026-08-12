import 'dart:developer';

import 'package:card_game/utils/constants/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  BannerAdWidgetState createState() => BannerAdWidgetState();
}

class BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? bannerAd;
  bool isLoaded = false;
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
      log('Banner Ad Unit: ${Constants.bannerTestAdUnitId}');
      bannerAd = BannerAd(
        adUnitId: Constants.bannerAdUnitId,
        // adUnitId: Constants.bannerTestAdUnitId,
        request: const AdRequest(),
        size: AdSize.banner,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            log('ad loaded $ad');
            setState(() {
              isLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, err) {
            ad.dispose();
            isLoaded = false;
            isError = true;
            setState(() {});
            log('error Banner Ad $err');
          },
        ),
      );
      bannerAd?.load();
      setState(() {});
    } catch (e, stackTree) {
      log('error Banner Ad catch $e $stackTree');
      isLoaded = false;
      isError = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoaded
        ? Container(
            width: bannerAd!.size.width.toDouble(),
            height: bannerAd!.size.height.toDouble(),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(vertical: 10),
            clipBehavior: Clip.antiAlias,
            child: AdWidget(ad: bannerAd!),
          ).animate().fadeIn().scaleY(begin: -0.2)
        : const SizedBox.shrink();
    //  isError || bannerAd == null ?
    // ? SizedBox.shrink()
  }

  @override
  void dispose() {
    bannerAd?.dispose();
    super.dispose();
  }
}
