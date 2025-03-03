import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:group_button/group_button.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:Cortex/screens/home/model/home_detail_res.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:Cortex/screens/home/services/history_api_service.dart';
import 'package:Cortex/screens/subscription_plan/models/subscription_history_response.dart';
import 'package:Cortex/services/in_app_purchase.dart';
import '../../Ads/ad_helper.dart';
import '../../utils/app_common.dart';
import '../../utils/constants.dart';
import '../dashboard/dashboard_controller.dart';
import '../subscription_plan/models/subscription_plan_model.dart';
import 'services/home_api_service.dart';
import 'services/system_service_helper.dart';

class HomeController extends GetxController {
  Rx<Future<Rx<HomeData>>> getDashboardDetailFuture = Future(() => HomeData().obs).obs;
  RxBool isLoading = false.obs;
  RxBool isLastPage = false.obs;
  RxInt page = 1.obs;
  Rx<HomeData> dashboardData = HomeData().obs;

  Rx<SubscriptionModel> selectedPlan = SubscriptionModel().obs;

  final groupButtonController = GroupButtonController(selectedIndex: 0);

  Rx<Future<RxList<CustomTemplate>>> getSearchResponseFuture = Future(() => RxList<CustomTemplate>()).obs;

  RxList<CustomTemplate> searchedTemplateListResponse = RxList();
  PageController pageController = PageController(initialPage: 0);

  TextEditingController searchCont = TextEditingController();

  TextEditingController codeInstructionCont = TextEditingController();

  ///Search
  RxBool isSearching = false.obs;
  FocusNode searchFocus = FocusNode();
  StreamController<String> searchStream = StreamController<String>();

  RxInt currentHistoryPage = 0.obs;

  RxInt selectedTabIndex = 0.obs;

  //BannerAd
  BannerAd? bannerAd;
  RxBool isAdShow = false.obs;

  Offerings? revenueCatOfferings;

  List<StoreProduct> storeProductList = [];

  Rx<StoreProduct>? selectedProduct;

  @override
  void onInit() {
    searchStream.stream.debounce(const Duration(seconds: 1)).listen((s) {
      searchTemplate();
    });
    super.onInit();
  }

  @override
  void onReady() {
    getDashboardDetail();

    super.onReady();
  }

  bannerLoad() {
    bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          debugPrint('$BannerAd loaded.');
          isAdShow(true);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          debugPrint('$BannerAd failedToLoad: $error');
        },
        onAdOpened: (Ad ad) {
          debugPrint('$BannerAd onAdOpened.');
        },
        onAdClosed: (Ad ad) {
          debugPrint('$BannerAd onAdClosed.');
        },
        // onApplicationExit: (Ad ad) => debugPrint('$BannerAd onApplicationExit.'),
      ),
    );
    bannerAd?.load();
  }

  Future<void> searchTemplate({
    bool showLoader = true,
  }) async {
    if (showLoader) {
      isLoading(true);
    }
    await getSearchResponseFuture(HomeServiceApis.getSearchResponse(
      searchString: searchCont.text.trim(),
      templateList: searchedTemplateListResponse,
      page: page.value,
      lastPageCallBack: (p0) {
        isLastPage(p0);
      },
    )).whenComplete(() => isLoading(false));
  }

  ///Get ChooseService List
  Future<void> getDashboardDetail({bool showLoader = true, bool forceSync = false}) async {
    if (showLoader) {
      isLoading(true);
    }
    getAppConfigurations(forceSync: forceSync);
    await getDashboardDetailFuture(HomeServiceApis.getDashboard()).then((data) {
      dashboardData(data.value);
      serviceList(data.value.systemService);
      userCurrentSubscription(data.value.currentSubscription);
      log('+++++++USERCURRENTSUBSCRIPTION: ${userCurrentSubscription.value.name}');
      log('+++++++USERCURRENTSUBSCRIPTION.VALUE.IDENTIFIER != FREE: ${userCurrentSubscription.value.identifier != FREE}');
      if (userCurrentSubscription.value.identifier != FREE && userCurrentSubscription.value.identifier.isNotEmpty) {
        /// if current plan is not free then remove the free plan from list
        dashboardData.value.subscriptionPlan.removeWhere((item) => item.identifier == FREE);
        selectedPlan(dashboardData.value.subscriptionPlan.firstWhere((element) => element.identifier == userCurrentSubscription.value.identifier));
        isPremiumUser(true);
      } else {
        isPremiumUser(false);
        SubscriptionModel freeSubscription = dashboardData.value.subscriptionPlan.firstWhere((element) => element.identifier == FREE);
        userCurrentSubscription(
          SubscriptionHistoryData(
            amount: freeSubscription.amount,
            identifier: freeSubscription.identifier,
            id: freeSubscription.id,
            name: dashboardData.value.subscriptionPlan.firstWhere((element) => element.identifier == FREE).name,
            endDate: data.value.currentSubscription!.endDate
          ),
        );
        Future.delayed(const Duration(seconds: 5), () {
          bannerLoad();
        });
      }

      if (isInAppPurchaseEnable.value) {
        initInAppPurchase();
      }
    }).catchError((e) {
      log('E getDashboardDetail: $e');
    }).whenComplete(() => isLoading(false));
  }

  initInAppPurchase() {
    InAppPurchaseService inAppPurchaseService = Get.put(InAppPurchaseService());
    if (!getBoolAsync(SharedPreferenceConst.HAS_IN_APP_SDK_INITIALISE_AT_LEASE_ONCE)) {
      inAppPurchaseService.init().then(
            (value) {
          inAppPurchaseService.checkSubscriptionSync();
        },
      );
    } else {
      syncRevenueCatData(inAppPurchaseService);
    }
  }

  syncRevenueCatData(InAppPurchaseService inAppPurchaseService) {
    if (getBoolAsync(SharedPreferenceConst.IS_RESTORE_PURCHASE)) {
      afterBuildCreated(
            () {
          inAppPurchaseService.showRestoreDialog(getContext);
        },
      );
    }

    if (dashboardData.value.subscriptionPlan.isNotEmpty) {
      getRevenueCatOfferings();
    }
  }

  getRevenueCatOfferings() async {
    InAppPurchaseService inAppPurchaseService = Get.put(InAppPurchaseService());

    await inAppPurchaseService.getStoreSubscriptionPlanList().then(
      (value) {
        revenueCatOfferings = value;

        if (revenueCatOfferings != null && revenueCatOfferings!.current != null && revenueCatOfferings!.current!.availablePackages.isNotEmpty) {
          storeProductList = revenueCatOfferings!.current!.availablePackages.map((e) => e.storeProduct).toList();
          Set<String> revenueCatIdentifiers = revenueCatOfferings!.current!.availablePackages.map((package) => package.storeProduct.identifier).toSet();

          // Filter backend plans to match RevenueCat identifiers
          dashboardData.value.subscriptionPlan = dashboardData.value.subscriptionPlan.where((plan) {
            return (/*(plan.amount == 0 || plan.identifier != FREE) || */(revenueCatIdentifiers.contains(isIOS ? plan.appStoreIdentifier : plan.playStoreIdentifier)));
          }).toList();
        }
      },
    ).catchError((e) {});
    // Extract identifiers from RevenueCat packages
  }

  Future<Package?> getSelectedPlanFromRevenueCat() async {
    if (revenueCatOfferings != null && revenueCatOfferings!.current != null && revenueCatOfferings!.current!.availablePackages.isNotEmpty) {
      int index = revenueCatOfferings!.current!.availablePackages
          .indexWhere((element) => element.storeProduct.identifier == (isIOS ? selectedPlan.value.appStoreIdentifier : selectedPlan.value.playStoreIdentifier));
      if (index > -1) {
        return revenueCatOfferings!.current!.availablePackages[index];
      }
    } else {
      return null;
    }
    return null;
  }

  Future<void> clearUserHistory({String? type}) async {
    isLoading(true);
    await HistoryServiceApis.clearUserHistory(type: SystemServiceKeys.all).then((res) {
      toast(res.message);
      getDashboardDetail();
    }).catchError((e) {
      toast(e.toString());
      log('deleteRecentChats E: $e');
    }).whenComplete(() => isLoading(false));
  }

  @override
  void onClose() {
    bannerAd?.dispose();
    super.onClose();
  }
}
