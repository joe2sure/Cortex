import 'dart:io';
import '../configs.dart';
import '../utils/app_common.dart';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return appConfigs.value.bannerAdId.isNotEmpty ? appConfigs.value.bannerAdId : BANNER_AD_ID;
    } else if (Platform.isIOS) {
      return appConfigs.value.iosBannerAdId.isNotEmpty ? appConfigs.value.iosBannerAdId : IOS_BANNER_AD_ID;
    }
    throw UnsupportedError("Unsupported platform");
  }

  static String get interstitialUnitId {
    if (Platform.isAndroid) {
      return appConfigs.value.interstitialAdId.isNotEmpty ? appConfigs.value.interstitialAdId : INTERSTITIAL_AD_ID;
    } else if (Platform.isIOS) {
      return appConfigs.value.iosInterstitialAdId.isNotEmpty ? appConfigs.value.iosInterstitialAdId : IOS_INTERSTITIAL_AD_ID;
    }
    throw UnsupportedError("Unsupported platform");
  }

  static String get rewardInterstitialUnitId {
    if (Platform.isAndroid) {
      return appConfigs.value.rewardinterstitialAdId.isNotEmpty ? appConfigs.value.rewardinterstitialAdId : REWARDINTERSTITIAL_AD_ID;
    } else if (Platform.isIOS) {
      return appConfigs.value.iosRewardinterstitialAdId.isNotEmpty ? appConfigs.value.iosRewardinterstitialAdId : IOS_REWARDINTERSTITIAL_AD_ID;
    }
    throw UnsupportedError("Unsupported platform");
  }

  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      return appConfigs.value.nativeAdId.isNotEmpty ? appConfigs.value.nativeAdId : NATIVE_AD_ID;
    } else if (Platform.isIOS) {
      return appConfigs.value.iosNativeAdId.isNotEmpty ? appConfigs.value.iosNativeAdId : IOS_NATIVE_AD_ID;
    }
    throw UnsupportedError("Unsupported platform");
  }

  static String get appOpenAdUnitId {
    if (Platform.isAndroid) {
      return appConfigs.value.openAdId.isNotEmpty ? appConfigs.value.openAdId : OPEN_AD_ID;
    } else if (Platform.isIOS) {
      return appConfigs.value.iosOpenAdId.isNotEmpty ? appConfigs.value.iosOpenAdId : IOS_OPEN_AD_ID;
    }
    throw UnsupportedError("Unsupported platform");
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return appConfigs.value.rewardedAdId.isNotEmpty ? appConfigs.value.rewardedAdId : REWARDED_AD_ID;
    } else if (Platform.isIOS) {
      return appConfigs.value.iosRewardedAdId.isNotEmpty ? appConfigs.value.iosRewardedAdId : IOS_REWARDED_AD_ID;
    }
    throw UnsupportedError("Unsupported platform");
  }
}
