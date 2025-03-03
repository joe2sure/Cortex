import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:Cortex/utils/app_common.dart';
import 'package:Cortex/utils/local_storage.dart';
import '../utils/constants.dart';

class AppOpenAdManager {
  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;
  static bool isLoaded = false;

  /// Load an AppOpenAd.
  void loadAd({Function()? adLoadedEvent}) {
    adsUniqueKey = getRandomString();
    appOpenApiCall(1);
    AppOpenAd.load(
      adUnitId: getValueFromLocal(AdConstantsKeys.appOpenId),
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          isLoaded = true;
          if (adLoadedEvent != null) {
            adLoadedEvent();
          }
          appOpenApiCall(2);
        },
        onAdFailedToLoad: (error) {
          // Handle the error.
          appOpenApiCall(3);
        },
      ),
    );
  }

  // Whether an ad is available to be shown.
  bool get isAdAvailable {
    return _appOpenAd != null;
  }

  Future<void> showAdIfAvailable({Function()? adDismissEvent}) async {
    if (getValueFromLocal(AdConstantsKeys.appOpenId) == null) {
      return;
    }
    if (_appOpenAd == null) {
      loadAd();
      return;
    }
    if (_isShowingAd) {
      return;
    }
    // Set the fullScreenContentCallback and show the ad.
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(onAdShowedFullScreenContent: (ad) {
      _isShowingAd = true;
      appOpenApiCall(4);
    }, onAdFailedToShowFullScreenContent: (ad, error) {
      _isShowingAd = false;
      ad.dispose();
      _appOpenAd = null;
    }, onAdDismissedFullScreenContent: (ad) {
      _isShowingAd = false;
      ad.dispose();
      _appOpenAd = null;
      if (adDismissEvent != null) {
        adDismissEvent();
      }
      loadAd();
    }, onAdClicked: (ad) {
      appOpenApiCall(5);
    });
    bool premiumUser = await getValueFromLocal(AdConstantsKeys.isPremiumUser);
    if (premiumUser) {
      if (adDismissEvent != null) {
        adDismissEvent();
      }
    } else {
      _appOpenAd!.show();
    }
  }

  String adsUniqueKey = "";
  final _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  String getRandomString() {
    return String.fromCharCodes(Iterable.generate(10, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  appOpenApiCall(int adStatus) async {
    Map<String, dynamic> param = {
      "userId": loginUserData.value.id,
      "adType": "2",
      "adCurrentStatus": adStatus.toString(),
      "adKey": adsUniqueKey,
    };

    debugPrint('param ==> $param');
    try {
      //TODO api call
      /* AppClientResponse response = await baseCall.sendRequest(url: url, queryParameters: param);
      debugPrint('api call result : code - ${response.code}  &  response - ${response.rawResponse}'); */
    } catch (e) {
      debugPrint('e ==> $e');
    }
  }
}
