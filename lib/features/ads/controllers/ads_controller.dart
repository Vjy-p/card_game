import 'dart:developer';

import 'package:card_game/utils/constants/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsController extends GetxController {
  InterstitialAd? interstitialAd;
  RxBool isLoaded = false.obs;

  @override
  void onInit() {
    loadInterstitialAd();
    super.onInit();
  }

  void loadInterstitialAd() {
    if (kIsWeb) {
      return;
    }
    log(
      'ad id ${Constants.interstitialAdUnitId} ${Constants.interstitialIOSAdUnitId}',
    );
    InterstitialAd.load(
      adUnitId: Constants.interstitialAdUnitId,
      // adUnitId: Constants.interstitialTestAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          log('$ad loaded.');
          interstitialAd = ad;
          isLoaded.value = true;

          // Handle full-screen events
          setAdEvents(ad);
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (LoadAdError error) {
          log('InterstitialAd failed to load: $error');
          isLoaded.value = false;
          interstitialAd?.dispose();
        },
      ),
    );
  }

  void setAdEvents(InterstitialAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      // Called when the ad is shown.
      onAdShowedFullScreenContent: (ad) => log('Ad showed.'),

      // Called when the ad is dismissed.
      onAdDismissedFullScreenContent: (ad) {
        log('Ad dismissed.');
        ad.dispose(); // Always dispose of the ad after it's dismissed
        loadInterstitialAd(); // Load a new one so it's ready for next time
      },

      // Called when the ad failed to show.
      onAdFailedToShowFullScreenContent: (ad, error) {
        log('Ad failed to show: $error');
        ad.dispose();
        loadInterstitialAd();
      },
    );
  }

  void showInterstitialAd() {
    if (isLoaded.value && interstitialAd != null) {
      interstitialAd?.show();
    } else {
      log('Interstitial ad is not ready yet.');
      // Optionally: Proceed to the next screen anyway if the ad isn't ready
    }
  }

  @override
  void dispose() {
    interstitialAd?.dispose();
    super.dispose();
  }
}
