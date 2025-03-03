import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:Cortex/components/subscription_restore_component.dart';
import 'package:Cortex/screens/home/home_controller.dart';
import 'package:Cortex/screens/subscription_plan/models/subscription_plan_req.dart';
import 'package:Cortex/screens/subscription_plan/services/plan_services_api.dart';

import '../../../utils/app_common.dart';
import '../../../utils/constants.dart';

import '../main.dart';

class InAppPurchaseService extends GetxController {
  Future<void> init() async {
    try {
      await Purchases.setLogLevel(LogLevel.error);
      String apiKey = isIOS ? appConfigs.value.appleAPIKey : appConfigs.value.googleAPIKey;

      if (apiKey.isNotEmpty) {
        PurchasesConfiguration configuration = PurchasesConfiguration(apiKey)
          ..appUserID = loginUserData.value.email
          ..observerMode = false;
        await Purchases.configure(configuration).then(
          (value) {
            log('In App Purchase Configuration Successful');
            setValue(SharedPreferenceConst.HAS_IN_APP_SDK_INITIALISE_AT_LEASE_ONCE, true);
          },
        ).catchError((e) {
          setValue(SharedPreferenceConst.HAS_IN_APP_SDK_INITIALISE_AT_LEASE_ONCE, false);
          if (e is PlatformException) {
            toast(e.message, print: true);
          } else if (e is PurchasesError) {
            toast(e.message, print: true);
          } else {
            toast(e.toString());
          }
        });
      } else {
        log('In App Purchase Configuration is still remaining');
      }
    } catch (e) {
      log('In App Purchase Configuration Failed: ${e.toString()}');
    }
//
  }

  Future<void> loginToRevenueCate() async {
    try {
      await Purchases.logIn(loginUserData.value.email);
      log('In App Purchase User Login Successful');
      setValue(SharedPreferenceConst.HAS_IN_REVENUE_CAT_LOGIN_DONE_LEASE_ONCE, true);
    } catch (e) {
      log('In App Purchase User Login Failed: ${e.toString()}');
    }
  }

  Future<CustomerInfo> getCustomerInfo() async {
    Purchases.invalidateCustomerInfoCache();
    return await Purchases.getCustomerInfo().then(
      (customerData) {
        return customerData;
      },
    ).catchError((e) {
      log('Error while fetching customer information');
    });
  }

  Future<Offerings?> getStoreSubscriptionPlanList() async {
    if (!getBoolAsync(SharedPreferenceConst.HAS_IN_APP_SDK_INITIALISE_AT_LEASE_ONCE)) {
      await init();
    } else {
      try {
        return await Purchases.getOfferings();
      } catch (e) {
        if (e is PlatformException) {
          toast(e.message, print: true);
        } else if (e is PurchasesError) {
          toast(e.message, print: true);
        } else {
          toast(e.toString());
        }
      }
    }
    return null;
  }

  Future<void> startPurchase({
    SubscriptionPlanReq? subscriptionPlanReq,
    required Package selectedRevenueCatPackage,
    required Function(SubscriptionPlanReq? subscriptionPlanReq) onComplete,
  }) async {
    if (!getBoolAsync(SharedPreferenceConst.HAS_IN_APP_SDK_INITIALISE_AT_LEASE_ONCE)) {
      await init();
    } else {
      await Purchases.purchasePackage(selectedRevenueCatPackage, googleProductChangeInfo: userCurrentSubscription.value.activeRevenueCatIdentifier.isNotEmpty ? GoogleProductChangeInfo(userCurrentSubscription.value.identifier) : null).then(
        (value) {
          subscriptionPlanReq?.transactionId = '';

          onComplete.call(subscriptionPlanReq);
        },
      ).catchError((e) {
        if (e is PlatformException) {
          toast(e.message);
        } else {
          if (e is PurchasesError) {
            toast(e.message);
          } else {
            toast(e.toString());
          }
        }
      });
    }
  }

  Future<void> checkSubscriptionSync() async {
    //Case check current subscription on AppStore/ PlayStore
    await getCustomerInfo().then(
      (customerData) {
        if (customerData.activeSubscriptions.isNotEmpty) {
          if (!customerData.activeSubscriptions.first.contains(userCurrentSubscription.value.activeRevenueCatIdentifier)) {
            setValue(SharedPreferenceConst.IS_RESTORE_PURCHASE, true);
          } else {
            setValue(SharedPreferenceConst.IS_RESTORE_PURCHASE, false);
          }
        } else {
          if (isPremiumUser.value && userCurrentSubscription.value.identifier != FREE) {
            setValue(SharedPreferenceConst.IS_RESTORE_PURCHASE, true);
          }
        }
      },
    );
  }

  void showRestoreDialog(BuildContext context) {
    showInDialog(context, builder: (context) {
      return SubscriptionRestoreComponent();
    });
  }

  restorePurchase() async {
    final customerData = await getCustomerInfo();
    if (customerData.activeSubscriptions.isNotEmpty) {
      if (userCurrentSubscription.value.activeRevenueCatIdentifier != customerData.activeSubscriptions.first) {
        saveSubscription();
      }
    } else {
      //Case when subscription cancelled from AppStore/ PlayStore directly
      if (isPremiumUser.value && userCurrentSubscription.value.identifier != FREE) {
        cancelSubscription(subscriptionId: userCurrentSubscription.value.planId);
      }
    }
  }

  saveSubscription() async {
    HomeController homeController = Get.find<HomeController>();
    SubscriptionPlanReq subscriptionPlanReq = SubscriptionPlanReq();
    final customerData = await getCustomerInfo();
    if (homeController.dashboardData.value.subscriptionPlan.validate().any((element) => element.appStoreIdentifier == customerData.activeSubscriptions.validate().first || element.playStoreIdentifier == customerData.activeSubscriptions.validate().first)) {
      homeController.selectedPlan(homeController.dashboardData.value.subscriptionPlan.validate().firstWhere((element) => element.appStoreIdentifier == customerData.activeSubscriptions.validate().first || element.playStoreIdentifier == customerData.activeSubscriptions.validate().first));
    }

    if (homeController.selectedPlan.value.identifier.isNotEmpty) {
      subscriptionPlanReq.activeInAppIdentifier = customerData.activeSubscriptions.first;

      subscriptionPlanReq.planId = homeController.selectedPlan.value.toString();

      PlanServiceApi.saveSubscriptionPlanApi(subscriptionPlanReq.toJson()).then((value) {
        toast("Restore data successfully");
      });
    }
  }

  Future<void> cancelSubscription({
    required int subscriptionId,
    VoidCallback? onUpdateSubscription,
  }) async {
    await PlanServiceApi.cancelSubscriptionPlan().then((value) {
      if (onUpdateSubscription != null) {
        onUpdateSubscription.call();

        toast(locale.value.searchTemplates);
      }
    }).catchError((e) {
      toast(e.toString(), print: true);
    });
  }
}
