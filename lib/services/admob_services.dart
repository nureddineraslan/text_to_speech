import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:speech_text/providers/my_provider.dart';

class AdmobService extends ChangeNotifier{
MyProvider myProvider=MyProvider();
InterstitialAd? _interstitialAd;
NativeAd? nativeAd=NativeAd(
    adUnitId: 'ca-app-pub-3940256099942544/2247696110',
    listener: NativeAdListener(
      onAdLoaded: (ad) {
        debugPrint('$NativeAd loaded.');

      },
      onAdFailedToLoad: (ad, error) {
        // Dispose the ad here to free resources.
        debugPrint('$NativeAd failed to load: $error');

      },
    ),
    request: const AdRequest(),
    // Styling
    nativeTemplateStyle: NativeTemplateStyle(
      // Required: Choose a template.
        templateType: TemplateType.medium,
        // Optional: Customize the ad's style.
        mainBackgroundColor: Colors.purple,
        cornerRadius: 10.0,
        callToActionTextStyle: NativeTemplateTextStyle(
            textColor: Colors.cyan,
            backgroundColor: Colors.red,
            style: NativeTemplateFontStyle.monospace,
            size: 16.0),
        primaryTextStyle: NativeTemplateTextStyle(
            textColor: Colors.red,
            backgroundColor: Colors.cyan,
            style: NativeTemplateFontStyle.italic,
            size: 16.0),
        secondaryTextStyle: NativeTemplateTextStyle(
            textColor: Colors.green,
            backgroundColor: Colors.black,
            style: NativeTemplateFontStyle.bold,
            size: 16.0),
        tertiaryTextStyle: NativeTemplateTextStyle(
            textColor: Colors.brown,
            backgroundColor: Colors.amber,
            style: NativeTemplateFontStyle.normal,
            size: 16.0)))..load();

NativeAd? knativeAd;

bool nativeAdIsLoaded = false;

// TODO: replace this test ad unit with your own ad unit.
final String _adUnitId = Platform.isAndroid
    ? 'ca-app-pub-3940256099942544/2247696110'
    : 'ca-app-pub-3940256099942544/3986624511';

/// Loads a native ad.
void loadAd() {
  knativeAd = NativeAd(
      adUnitId: _adUnitId,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          debugPrint('$NativeAd loaded.');

            nativeAdIsLoaded = true;

        },
        onAdFailedToLoad: (ad, error) {
          // Dispose the ad here to free resources.
          debugPrint('$NativeAd failed to load: $error');
          ad.dispose();
        },
      ),
      request: const AdRequest(),
      // Styling
      nativeTemplateStyle: NativeTemplateStyle(
        // Required: Choose a template.
        templateType: TemplateType.medium,
        // Optional: Customize the ad's style.
        mainBackgroundColor: Colors.white,

        cornerRadius: 10.0,
      ))
    ..load();
  notifyListeners();
}

static String get testRewardedAdUnitId =>
    kDebugMode? 'ca-app-pub-3940256099942544/5224354917':'ca-app-pub-8033034794605722/6990525855';
  RewardedAd? _rewardedAd;
  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: testRewardedAdUnitId,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
_rewardedAd=ad;
        },
        onAdFailedToLoad: (error) {
          print('Rewarded ad failed to load: $error');
        },
      ),
    );
  }

  void showRewardedAd(BuildContext context) {
    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {

        },
        onAdDismissedFullScreenContent: (ad) {
          // Rewarded ad tam ekran kapatıldığında yapılacak işlemler
          ad.dispose();
          loadRewardedAd(); // Yeni bir rewarded ad yükle
        },
      );
      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {

         Provider.of<MyProvider>(context,listen: false).incrementPuan();

        },
      );
      _rewardedAd = null;
    } else {
      showInterstitialAd(context);

    }
  }
static String get testInterstitialAdUnitId =>
    kDebugMode? 'ca-app-pub-3940256099942544/1033173712':'ca-app-pub-8033034794605722/7182097545';
void loadInterstitialAd() {
  InterstitialAd.load(
    adUnitId: testInterstitialAdUnitId, // Reklam birimi kimliği
    request: AdRequest(),
    adLoadCallback: InterstitialAdLoadCallback(
      onAdLoaded: (ad) {
        _interstitialAd = ad;
      },
      onAdFailedToLoad: (error) {
        print('Interstitial ad failed to load: $error');
      },
    ),
  );
}

void showInterstitialAd(BuildContext context) {
  if (_interstitialAd != null) {
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        // Reklam tam ekran olarak gösterildiğinde yapılacak işlemler
      },
      onAdDismissedFullScreenContent: (ad) {
        Provider.of<MyProvider>(context,listen: false).incrementPuan();
        ad.dispose();
        loadInterstitialAd(); // Yeni bir ara reklam yükle
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  } else {
    print('Interstitial ad is not ready yet.');
  }
}
static String get testBannerAdUnitId =>
   kDebugMode? 'ca-app-pub-3940256099942544/6300978111':'ca-app-pub-8033034794605722/2121342555'; // Test ad unit ID

late BannerAd _bannerAd;
bool _isAdLoaded = false;

BannerAd createBannerAd() {
  return BannerAd(
    adUnitId: testBannerAdUnitId,
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(
      onAdLoaded: (Ad ad) {
        _isAdLoaded = true;
      },
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        ad.dispose();
        _isAdLoaded = false;
        print('Banner ad failed to load: $error');
      },
    ),
  );
}

void loadBannerAd() {
  _bannerAd = createBannerAd()
    ..load();
}

Widget showBannerAd() {
  if (_isAdLoaded) {
    return Container(
      alignment: Alignment.center,
      child: AdWidget(ad: _bannerAd),
      width: _bannerAd.size.width.toDouble(),
      height: _bannerAd.size.height.toDouble(),
    );
  } else {
    return Container();
  }
}

void disposeBannerAd() {
  _bannerAd.dispose();
}
}