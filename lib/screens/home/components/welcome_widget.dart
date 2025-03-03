import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/generated/assets.dart';
import 'package:Cortex/main.dart';
import 'package:Cortex/utils/app_common.dart';

import '../../../utils/colors.dart';
import '../../subscription_plan/sub_scription_plan_screen.dart';
import '../home_controller.dart';

class WelcomeWidget extends StatelessWidget {
  final bool isFromAvtarCreation;
  final int? textSize;
  final HomeController homeController;
  const WelcomeWidget({super.key, this.isFromAvtarCreation = false, this.textSize, required this.homeController});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            16.width,
            Text(
              isLoggedIn.value ? "${locale.value.hey}, ${loginUserData.value.firstName}" : locale.value.hiThere,
              style: primaryTextStyle(color: isDarkMode.value ? whiteTextColor : canvasColor, size: textSize ?? 18, weight: FontWeight.w500),
            )
          ],
        ),
        Obx(
          () => Container(
            height: 36,
            decoration: boxDecorationWithRoundedCorners(backgroundColor: appColorPrimary, borderRadius: const BorderRadius.only(topLeft: Radius.circular(40), bottomLeft: Radius.circular(40))),
            child: Row(
              children: [
                Image.asset(
                  Assets.iconsIcPro,
                  height: 16,
                  width: 16,
                ),
                6.width,
                Text(
                  "Pro",
                  style: secondaryTextStyle(size: 12, color: whiteTextColor),
                )
              ],
            ).paddingSymmetric(horizontal: 14).center(),
          ).onTap(() {
            Get.to(() => SubscriptionPlanScreen(homeController: homeController));
          }).visible(isLoggedIn.value && (!isPremiumUser.value || userCurrentSubscription.value.identifier.isEmpty) && !hasInAppStoreReview.value),
        )
      ],
    ).paddingOnly(top: 24);
  }
}
