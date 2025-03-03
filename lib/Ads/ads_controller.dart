import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:Cortex/utils/local_storage.dart';
import 'ad_helper.dart';
import 'reward_and_subscribe_dialog.dart';
import '../utils/app_common.dart';
import '../utils/constants.dart';

class AdsController extends GetxController {
  InterstitialAd? _interstitialAd;
  RewardedInterstitialAd? _rewardedInterstitialAd;
  RewardedAd? _rewardedAd;
  NativeAd? nativeAd;
  String adsUniqueKey = "";
  String nativeAdsUniqueKey = "";
  final _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  String getRandomString() {
    return String.fromCharCodes(Iterable.generate(10, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  loadRewardedInterstitialAd(Function(RewardedInterstitialAd? interstitialAd, bool isLoad) rewardedInterstitialAdAdCallBack) {
    adsUniqueKey = getRandomString();
    rewardedInterestialApiCall(1);
    RewardedInterstitialAd.load(
        adUnitId: AdHelper.rewardInterstitialUnitId,
        request: const AdRequest(),
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            rewardedInterestialApiCall(2);
            _rewardedInterstitialAd = ad;
            rewardedInterstitialAdAdCallBack(_rewardedInterstitialAd!, true);
          },
          onAdFailedToLoad: (error) {
            rewardedInterestialApiCall(3);
            rewardedInterstitialAdAdCallBack(_rewardedInterstitialAd, false);
          },
        ));
  }

  loadShowAdsManagerRewarded({required Function() dismissCallBack}) {
    loadRewardedAd(
      (rewardedAd, isLoad) {
        if (isLoad) {
          rewardedAd!.show(
            onUserEarnedReward: (ad, reward) {
              dev.log('reward.amount: ${reward.amount}');
              dev.log('reward.type: ${reward.type}');
            },
          );

          rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (RewardedAd ad) {
              dev.log('$ad onAdShowedFullScreenContent.');
              rewardedApiCall(4);
            },
            onAdClicked: (RewardedAd ad) {
              rewardedApiCall(5);
            },
            onAdDismissedFullScreenContent: (RewardedAd ad) {
              dismissCallBack();
              dev.log('$ad onAdDismissedFullScreenContent.');
            },
            onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
              dev.log('$ad onAdFailedToShowFullScreenContent: $error');
            },
            onAdImpression: (RewardedAd ad) => dev.log('$ad impression occurred.'),
          );
          /*dismissEvent: (){
            dismissCallBack();
          });*/
        } else {
          rewardedAdFailDialog();
          dismissCallBack();
        }
      },
    );
  }

  loadNative({required Function(NativeAd nativeId) callBack}) {
    nativeAdsUniqueKey = getRandomString();
    nativeApiCall(1);
    nativeAd = NativeAd(
      adUnitId: AdHelper.nativeAdUnitId,
      factoryId: 'listTile',
      request: const AdRequest(),
      listener: NativeAdListener(onAdLoaded: (_) {
        callBack(nativeAd!);
        nativeApiCall(2);
        nativeApiCall(4);
      }, onAdFailedToLoad: (ad, error) {
        // Releases an ad resource when it fails to load
        ad.dispose();
        nativeApiCall(3);
      }, onAdClicked: (ad) {
        nativeApiCall(5);
      }),
    );
    nativeAd!.load();
  }

  loadInterstitialAd(Function(InterstitialAd? interstitialAd, bool isLoad) interstitialAdCallBack) {
    adsUniqueKey = getRandomString();
    interestialApiCall(1);
    InterstitialAd.load(
        adUnitId: AdHelper.interstitialUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            interestialApiCall(2);
            _interstitialAd = ad;
            interstitialAdCallBack(_interstitialAd!, true);
          },
          onAdFailedToLoad: (error) {
            interestialApiCall(3);
            interstitialAdCallBack(_interstitialAd, false);
          },
        ));
  }

  loadRewardedAd(Function(RewardedAd? rewardedAd, bool isLoad) rewardedAdCallBack) {
    adsUniqueKey = getRandomString();
    rewardedApiCall(1);
    RewardedAd.load(
        adUnitId: AdHelper.rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            rewardedApiCall(2);
            _rewardedAd = ad;
            rewardedAdCallBack(_rewardedAd!, true);
          },
          onAdFailedToLoad: (error) {
            rewardedApiCall(3);
            rewardedAdCallBack(_rewardedAd, false);
          },
        ));
  }

  showInterstialAd(Function() dismissEvent) {
    if (_interstitialAd == null) {
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        interestialApiCall(4);
      },
      onAdClicked: (value) {
        interestialApiCall(5);
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        _interstitialAd = null;
        dismissEvent();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        //api call here
        ad.dispose();
      },
    );
    _interstitialAd!.show();
  }

  loadShowAdsManagerRewardedInterstial({required Function() dismissCallBack}) {
    adsLoader(true);
    loadRewardedInterstitialAd(
      (rewardedInterstitialAd, isLoad) {
        if (isLoad) {
          rewardedInterstitialAd!.show(
            onUserEarnedReward: (ad, reward) {
              dev.log('reward.amount: ${reward.amount}');
              dev.log('reward.type: ${reward.type}');
              dismissCallBack();
              adsLoader(false);
            },
          );

          rewardedInterstitialAd.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (RewardedInterstitialAd ad) {
              rewardedInterestialApiCall(4);
            },
            onAdClicked: (value) {
              rewardedInterestialApiCall(5);
            },
            onAdDismissedFullScreenContent: (RewardedInterstitialAd ad) {
              ad.dispose();
              _rewardedInterstitialAd = null;
            },
            onAdFailedToShowFullScreenContent: (RewardedInterstitialAd ad, AdError error) {
              //api call here

              ad.dispose();
            },
          );

          /*dismissEvent: (){
            dismissCallBack();
          });*/
        } else {
          dismissCallBack();
          adsLoader(false);
        }
      },
    );
  }

  interestialApiCall(int adStatus) async {
    Map<String, dynamic> param = {
      "userId": loginUserData.value.id,
      "adType": "1",
      "adCurrentStatus": adStatus.toString(),
      "adKey": adsUniqueKey,
    };

    debugPrint('param ==> $param');
    try {
      //TODO
      /* AppClientResponse response = await baseCall.sendRequest(url: url, queryParameters: param);
      debugPrint('api call result : code - ${response.code}  &  response - ${response.rawResponse}'); */
    } catch (e) {
      debugPrint('e ==> $e');
    }
  }

  rewardedInterestialApiCall(int adStatus) async {
    Map<String, dynamic> param = {
      "userId": loginUserData.value.id,
      "adType": "6",
      "adCurrentStatus": adStatus.toString(),
      "adKey": adsUniqueKey,
    };

    debugPrint('param ==> $param');
    try {
      //TODO
      /*  AppClientResponse response = await baseCall.sendRequest(url: url, queryParameters: param);
      debugPrint('api call result : code - ${response.code}  &  response - ${response.rawResponse}'); */
    } catch (e) {
      debugPrint('e ==> $e');
    }
  }

  rewardedApiCall(int adStatus) async {
    Map<String, dynamic> param = {
      "userId": loginUserData.value.id,
      "adType": "5",
      "adCurrentStatus": adStatus.toString(),
      "adKey": adsUniqueKey,
    };

    debugPrint('param ==> $param');
    try {
      //TODO
      /*  AppClientResponse response = await baseCall.sendRequest(url: url, queryParameters: param);
      debugPrint('api call result : code - ${response.code}  &  response - ${response.rawResponse}'); */
    } catch (e) {
      debugPrint('e ==> $e');
    }
  }

  nativeApiCall(int adStatus) async {
    Map<String, dynamic> param = {
      "userId": loginUserData.value.id,
      "adType": "3",
      "adCurrentStatus": adStatus.toString(),
      "adKey": nativeAdsUniqueKey,
    };

    debugPrint('param ==> $param');
    try {
      //TODO
      /*  AppClientResponse response = await baseCall.sendRequest(url: url, queryParameters: param);
      debugPrint('api call result : code - ${response.code}  &  response - ${response.rawResponse}'); */
    } catch (e) {
      debugPrint('e ==> $e');
    }
  }
}

class NativeAdsLoad extends StatefulWidget {
  const NativeAdsLoad({super.key});

  @override
  State<NativeAdsLoad> createState() => _NativeAdsLoadState();
}

class _NativeAdsLoadState extends State<NativeAdsLoad> {
  RxBool isAdLoaded = false.obs;
  NativeAd? nativeAd;
  late Size size;
  @override
  void initState() {
    // TODO: implement initState
    if (getValueFromLocal(AdConstantsKeys.nativeId) != null) {
      nativeAd = NativeAd(
        adUnitId: getValueFromLocal(AdConstantsKeys.nativeId),
        factoryId: 'listTile',
        request: const AdRequest(),
        listener: NativeAdListener(
          onAdLoaded: (_) {
            isAdLoaded(true);
            setState(() {});
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
          },
        ),
      );
      nativeAd!.load();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return isAdLoaded.value && nativeAd != null
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
            child: Container(
              height: size.height * 0.25,
              width: size.width * 0.95,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 7,
                    color: Colors.grey,
                  ),
                ],
              ),
              child: AdWidget(ad: nativeAd!),
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: Container(
              height: size.height * 0.27,
              width: size.width * 0.95,
              color: Colors.red,
              child: const Center(
                  child: Text(
                "Ads Loading..",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              )),
            ));
  }
}
