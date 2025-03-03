import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:group_button/group_button.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:purchases_flutter/models/store_product_wrapper.dart';
import 'package:Cortex/components/app_scaffold.dart';
import 'package:Cortex/screens/subscription_plan/sub_scription_plan_payment_controller.dart';
import 'package:Cortex/screens/subscription_plan/sub_scription_plan_payment_screen.dart';
import 'package:Cortex/utils/auto_scroll_widget.dart';
import '../../generated/assets.dart';
import '../../main.dart';
import '../../utils/app_common.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../dashboard/dashboard_controller.dart';
import '../home/home_controller.dart';
import 'components/subscription_plan_component.dart';
import 'models/subscription_plan_model.dart';
import 'models/subscription_plan_req.dart';

class SubscriptionPlanScreen extends StatelessWidget {
  final HomeController homeController;

  const SubscriptionPlanScreen({super.key, required this.homeController});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppScaffold(
        isCenterTitle: true,
        isLoading: subscriptionPlanPaymentController.isLoading,
        appBartitleText:locale.value.subscriptionPlan,
        appBarbackgroundColor: isDarkMode.value ? fullDarkCanvasColor : appScreenGreyBackground,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                isDarkMode.value ? Assets.imagesSubscriptionBg : Assets.imagesSubscriptionLightBg,
                fit: BoxFit.contain,
                width: Get.width,
                height: Get.height * 0.5,
              ),
            ),
            SizedBox(
              height: Get.height * 0.5,
              width: Get.width,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoScrollInfiniteCustom(
                        list: buySubTopSliderImages,
                        height: Get.height * 0.27,
                      ),
                      16.height,
                      AutoScrollInfiniteCustom(
                        list: buySubBelowSliderImages,
                        height: Get.height * 0.20,
                        animateReverse: true,
                      ),
                    ],
                  ).paddingTop(20),
                ],
              ),
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.7,
              maxChildSize: 0.9,
              minChildSize: 0.5,
              builder: (ctx, controller) {
                return Container(
                  width: Get.width,
                  constraints: BoxConstraints(maxHeight: Get.height * 0.85),
                  padding: const EdgeInsets.only(top: 16),
                  decoration: boxDecorationDefault(
                    color: isDarkMode.value ? fullDarkCanvasColorDark : appColorPrimary,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      10.height,
                      Text(
                        locale.value.unlockingLimitlessAiFeatures,
                        style: primaryTextStyle(size: 26, color: Colors.white),
                        textAlign: TextAlign.center,
                      ).paddingSymmetric(horizontal: 16),
                      SingleChildScrollView(
                        controller: controller,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            24.height,
                            SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: GroupButton<SubscriptionModel>(
                                controller: homeController.groupButtonController,
                                buttons: homeController.dashboardData.value.subscriptionPlan,
                                onSelected: (value, index, isSelected) {},
                                buttonBuilder: (selected, value, context) {
                                  StoreProduct? revenueCatProduct;
                                  if (isInAppPurchaseEnable.value && value.identifier != FREE) {
                                    revenueCatProduct =
                                        homeController.revenueCatOfferings?.current!.availablePackages.firstWhere((element) => element.storeProduct.identifier == (isIOS ? value.appStoreIdentifier : value.playStoreIdentifier)).storeProduct;
                                  }
                                  afterBuildCreated(() async {
                                    value.isPlanSelected.value = selected;
                                    if (!selected && isPremiumUser.value) {
                                      value.isPlanSelected.value = homeController.selectedPlan.value.identifier == userCurrentSubscription.value.identifier;
                                    }
                                    if (selected) {
                                      homeController.selectedPlan(value);
                                      await homeController.getSelectedPlanFromRevenueCat().then(
                                        (value) {
                                          homeController.selectedProduct?.value = value!.storeProduct;
                                        },
                                      );
                                    }
                                  });

                                  return SubscriptionPlanComponent(
                                    subscriptionPlanData: value,
                                    isPlanSelected: selected,
                                    revenueCatProduct: revenueCatProduct,
                                  );
                                },
                              ),
                            ),
                            16.height,
                          ],
                        ).paddingSymmetric(horizontal: 16),
                      ).flexible(),
                      16.height,
                      Obx(
                        () => AppButton(
                          text: locale.value.purchaseNow,
                          textStyle: boldTextStyle(size: 16, weight: FontWeight.w400, color: canvasColor),
                          height: 52,
                          width: Get.width,
                          elevation: 0,
                          color: isDarkMode.value ? appColorSecondary : Colors.white,
                          disabledColor: fullDarkCanvasColor.withOpacity(0.4),
                          onTap: () async {
                            log(homeController.selectedPlan.value.identifier != userCurrentSubscription.value.identifier);
                            subscriptionPlanPaymentController = SubscriptionPlanPaymentController(
                              amount: homeController.selectedPlan.value.amount,
                              planLimits: homeController.selectedPlan.value.limits,
                              subscriptionPlanReq: SubscriptionPlanReq(
                                planId: homeController.selectedPlan.value.id.toString(),
                                userId: loginUserData.value.id.toString(),
                                identifier: homeController.selectedPlan.value.name.toLowerCase(),
                                activeInAppIdentifier: isIOS ? homeController.selectedPlan.value.appStoreIdentifier : homeController.selectedPlan.value.playStoreIdentifier,
                                gateway: isIOS ? "Apple" : "Google",
                              ),
                            );
                            if (homeController.selectedPlan.value.amount > 0) {
                              if (isInAppPurchaseEnable.value) {
                                subscriptionPlanPaymentController.paymentOption(PaymentMethods.PAYMENT_METHOD_INAPPPURCHASE);
                                homeController.getSelectedPlanFromRevenueCat().then(
                                  (value) {
                                    if (value != null) {
                                      subscriptionPlanPaymentController.handlePayNowClick(context, selectedRevenueCatPlan: value);
                                    } else {
                                      toast("${locale.value.cantFindPlan} ${isIOS? 'Appstore' : "PlayStore"}");
                                    }
                                  },
                                );
                              } else {
                                Get.to(() => const SubscriptionPlanPaymentScreen(), binding: BindingsBuilder(() {
                                  getAppConfigurations();
                                }));
                              }
                            }
                          },
                        ).paddingOnly(left: 16, right: 16, bottom: 16).visible(homeController.selectedPlan.value.identifier != FREE && homeController.dashboardData.value.subscriptionPlan.isNotEmpty),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
