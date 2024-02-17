import 'dart:io';
import 'dart:math';
import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/foundation.dart';
import 'package:rakaat_tracker/util/constants.dart';
import 'package:rakaat_tracker/util/constants.dart';

class ApplovinAdSdk {

  ApplovinAdSdk._privateConstructor();

  static final ApplovinAdSdk _instance = ApplovinAdSdk._privateConstructor();

  /// getter
  static ApplovinAdSdk get instance => _instance;

  /// properties
  final String _sdkKey = "uVpwEZJgllM9T89tKeWQkTttN1xGr3xHnK7mJ3JVHtir5gifH8NwXcCpisDKyN8f3Ui74KIWRWz7SmwQF1Ie3K";
  bool _isInitialized = false;
  AdLoadState interstitialLoadState = AdLoadState.notLoaded;
  var _interstitialRetryAttempt = 0;

  final String _interstitialAdUnitId = Platform.isAndroid
      ? "67a46ea95fad8d6d"
      : "IOS_INTER_AD_UNIT_ID";
  final String _bannerAdUnitId = Platform.isAndroid
      ? "8ccbb7578a31bdaa"
      : "IOS_BANNER_AD_UNIT_ID";

  get interstitialAdUnitID => _interstitialAdUnitId;
  get bannerAdUnitID => _bannerAdUnitId;

  get isInitialized => _isInitialized;

  var bannerListener = AdViewAdListener(onAdLoadedCallback: (ad) {
    debugPrint('Banner ad loaded from ${ad.networkName}');
  }, onAdLoadFailedCallback: (adUnitId, error) {
    debugPrint('Banner ad failed to load with error code ${error.code} and message: ${error.message}');
  }, onAdClickedCallback: (ad) {
    debugPrint('Banner ad clicked');
  }, onAdExpandedCallback: (ad) {
    debugPrint('Banner ad expanded');
  }, onAdCollapsedCallback: (ad) {
    debugPrint('Banner ad collapsed');
  }, onAdRevenuePaidCallback: (ad) {
    debugPrint('Banner ad revenue paid: ${ad.revenue}');
  });

  initializeSDK() async {

    /// applovin ads
    Map? sdkConfiguration = await AppLovinMAX.initialize(_sdkKey);
    AppLovinMAX.setCreativeDebuggerEnabled(false);
    if (sdkConfiguration != null) {
      _isInitialized = true;

      debugPrint("SDK initialized: ${sdkConfiguration.toString()}");

      addAdInterstitialListener();
      // addAdBannerListener();
    }
  }

  void addAdInterstitialListener() {
    AppLovinMAX.setInterstitialListener(
      InterstitialListener(
        onAdLoadedCallback: (ad) {
          interstitialLoadState = AdLoadState.loaded;

          // Interstitial ad is ready to be shown. AppLovinMAX.isInterstitialAdReady(_interstitial_ad_unit_id) will now return 'true'
          debugPrint('Interstitial ad loaded from ${ad.networkName}');

          // Reset retry attempt
          _interstitialRetryAttempt = 0;
        },
        onAdLoadFailedCallback: (adUnitId, error) {
          interstitialLoadState = AdLoadState.notLoaded;

          // Interstitial ad failed to load
          // We recommend retrying with exponentially higher delays up to a maximum delay (in this case 64 seconds)
          _interstitialRetryAttempt = _interstitialRetryAttempt + 1;

          int retryDelay = pow(2, min(6, _interstitialRetryAttempt)).toInt();
          debugPrint('Interstitial ad failed to load with code ${error
              .code} - retrying in ${retryDelay}s');

          Future.delayed(Duration(milliseconds: retryDelay * 1000), () {
            AppLovinMAX.loadInterstitial(_interstitialAdUnitId);
          });
        },
        onAdDisplayedCallback: (ad) {
          debugPrint('Interstitial ad displayed');
        },
        onAdDisplayFailedCallback: (ad, error) {
          interstitialLoadState = AdLoadState.notLoaded;
          debugPrint('Interstitial ad failed to display with code ${error
              .code} and message ${error.message}');
        },
        onAdClickedCallback: (ad) {
          debugPrint('Interstitial ad clicked');
        },
        onAdHiddenCallback: (ad) {
          interstitialLoadState = AdLoadState.notLoaded;
          debugPrint('Interstitial ad hidden');
        },
        onAdRevenuePaidCallback: (ad) {
          debugPrint('Interstitial ad revenue paid: ${ad.revenue}');
        },),);
  }
  
  void addAdBannerListener(){
    /// Banner Ad Listeners
    AppLovinMAX.setBannerListener(bannerListener);
  }
}