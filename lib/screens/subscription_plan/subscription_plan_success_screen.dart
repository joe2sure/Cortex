// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/components/app_scaffold.dart';
import 'package:Cortex/utils/common_base.dart';

import '../../generated/assets.dart';
import '../../main.dart';
import '../../utils/app_common.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import 'components/subscription_image_component.dart';

class SubscriptionPlanSuccessScreen extends StatelessWidget {
  SubscriptionPlanSuccessScreen({super.key});

  RxBool isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      hideAppBar: true,
      isLoading: isLoading,
      body: Container(
        alignment: Alignment.center,
        height: Get.height,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.center,
                decoration: boxDecorationDefault(color: context.scaffoldBackgroundColor),
                child: Lottie.asset(Assets.lottiePlanSuccessfull, fit: BoxFit.cover, repeat: false),
              ),
              32.height,
              SizedBox(
                width: Get.width * 0.8,
                child: Text(
                  locale.value.thankYouForYourSubscription,
                  textAlign: TextAlign.center,
                  style: primaryTextStyle(size: 18, color: appColorPrimary),
                ),
              ),
              16.height,
              SizedBox(
                width: Get.width * 0.8,
                child: Text(
                  locale.value.youllBeUseAllTheMentionFeaturesOfOurVizionAi,
                  textAlign: TextAlign.center,
                  style: secondaryTextStyle(color: secondaryTextColor),
                ),
              ),
              Obx(() => 32.height.visible(planSuccessLimits.isNotEmpty)),
              Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: boxDecorationDefault(color: primaryTextColor, shape: BoxShape.rectangle),
                  child: AnimatedWrap(
                    runSpacing: 10,
                    listAnimationType: ListAnimationType.None,
                    itemCount: planSuccessLimits.length,
                    itemBuilder: (context, index) => Row(
                      children: [
                        SubIconWithText(
                          mainAxisAlignment: MainAxisAlignment.start,
                          title: planSuccessLimits[index].limitationTitle,
                          icon: Image.asset(Assets.iconsIcCheck, width: 14, height: 14),
                          textSize: 12,
                          fontWeight: FontWeight.w400,
                        ).expand(),
                        16.width,
                        Text(
                          "${planSuccessLimits[index].limit} ${planSuccessLimits[index].key == LimitKeys.imageCount ? locale.value.images : locale.value.words}",
                          style: secondaryTextStyle(color: appColorSecondary, size: 12, weight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ).visible(planSuccessLimits.isNotEmpty),
              ),
              58.height,
              AppButton(
                width: Get.width,
                text: locale.value.goToHome,
                textStyle: appButtonTextStyleWhite,
                onTap: () {
                  /// To Clear Value
                  planSuccessLimits([]);
                  Get.back();
                },
              ),
              16.height,
            ],
          ),
        ),
      ),
    );
  }
}
