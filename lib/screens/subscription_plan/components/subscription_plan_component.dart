import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:purchases_flutter/models/store_product_wrapper.dart';
import 'package:Cortex/screens/subscription_plan/components/subscription_image_component.dart';
import 'package:Cortex/utils/app_common.dart';
import 'package:Cortex/utils/constants.dart';
import '../../../components/price_widget.dart';
import '../../../generated/assets.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import '../models/subscription_plan_model.dart';

class SubscriptionPlanComponent extends StatelessWidget {
  final SubscriptionModel subscriptionPlanData;
  final bool isPlanSelected;

  final StoreProduct? revenueCatProduct;

  SubscriptionPlanComponent({
    super.key,
    required this.subscriptionPlanData,
    this.isPlanSelected = false,
    this.revenueCatProduct,
  });

  final RxBool hideShow = true.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Container(
          width: Get.width,
          constraints: BoxConstraints(maxHeight: Get.height * 0.60),
          padding: const EdgeInsets.all(16),
          decoration: boxDecorationDefault(
            color: isDarkMode.value
                ? isPlanSelected
                    ? lightCanvasColor
                    : fullDarkCanvasColor
                : isPlanSelected
                    ? canvasColor
                    : lightCanvasColor,
            border: Border.all(color: isPlanSelected ? appSectionBackground : transparentColor),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isInAppPurchaseEnable.value && revenueCatProduct != null ? revenueCatProduct!.title : subscriptionPlanData.name,
                    style: secondaryTextStyle(color: appColorSecondary, size: 14, weight: FontWeight.w600),
                  ).paddingTop(8).flexible(),
                  isPlanSelected
                      ? Lottie.asset(
                          Assets.lottieCheck,
                          fit: BoxFit.cover,
                          height: 20,
                          width: 20,
                          repeat: false,
                        )
                      : const Icon(Icons.circle_outlined, size: 18, color: appColorSecondary),
                ],
              ),
              10.height,
              Marquee(
                child: PriceWidget(
                  price: subscriptionPlanData.amount,
                  color: Colors.white,
                  size: 26,
                  isBoldText: false,
                  formatedPrice: revenueCatProduct != null ? revenueCatProduct!.priceString : "",
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    subscriptionPlanData.type,
                    style: secondaryTextStyle(color: appColorSecondary, size: 12, weight: FontWeight.w500),
                  ),
                  Text(
                    subscriptionPlanData.planLimitation,
                    style: secondaryTextStyle(color: appColorSecondary, size: 12, weight: FontWeight.w500),
                  ),
                ],
              ),
              SingleChildScrollView(
                child: AnimatedWrap(
                  runSpacing: 10,
                  listAnimationType: ListAnimationType.None,
                  itemCount: hideShow.value ? subscriptionPlanData.limits.take(3).length : subscriptionPlanData.limits.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        SubIconWithText(
                          mainAxisAlignment: MainAxisAlignment.start,
                          title: subscriptionPlanData.limits[index].limitationTitle,
                          icon: Image.asset(Assets.iconsIcCheck, width: 14, height: 14),
                          textSize: 12,
                          fontWeight: FontWeight.w400,
                        ).expand(),
                        16.width,
                        Text(
                          "${subscriptionPlanData.limits[index].limit} ${subscriptionPlanData.limits[index].key == LimitKeys.imageCount ? locale.value.images : locale.value.words}",
                          style: secondaryTextStyle(color: appColorSecondary, size: 12, weight: FontWeight.w500),
                        ),
                      ],
                    );
                  },
                ).paddingTop(16).visible(subscriptionPlanData.limits.isNotEmpty),
              ).flexible(),
              Obx(
                () => Center(
                  child: TextButton(
                    onPressed: () {
                      hideShow(!hideShow.value);
                    },
                    child: Icon(
                      hideShow.value ? Icons.keyboard_arrow_down_rounded : Icons.keyboard_arrow_up_rounded,
                      size: 24,
                      color: darkGray.withOpacity(0.5),
                    ),
                  ),
                ).visible(hideAll.value),
              )
            ],
          ),
        );
      },
    );
  }

  RxBool get hideAll => (subscriptionPlanData.limits.length > 3).obs;
}
