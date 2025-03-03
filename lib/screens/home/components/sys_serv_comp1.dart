import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/generated/assets.dart';
import 'package:Cortex/utils/common_base.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants.dart';
import '../model/home_detail_res.dart';
import '../services/system_service_helper.dart';
import 'ai_art_gen_component.dart';

class SysServComp1 extends StatelessWidget {
  const SysServComp1({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
          () =>
          SizedBox(
            height: Get.height * 0.26,
            width: Get.width,
            child: Row(
              children: [
                if (getSystemServicebyKey(type: SystemServiceKeys.aiArtGenerator).status
                    .getBoolInt()
                    .obs
                    .value) const AiArtGenComponent().expand(),
                16.width.visible(getSystemServicebyKey(type: SystemServiceKeys.aiArtGenerator).status
                    .getBoolInt()
                    .obs
                    .value &&
                    (getSystemServicebyKey(type: SystemServiceKeys.aiImage).status
                        .getBoolInt()
                        .obs
                        .value || getSystemServicebyKey(type: SystemServiceKeys.aiCode).status
                        .getBoolInt()
                        .obs
                        .value)),
                Column(
                  children: [
                    if (getSystemServicebyKey(type: SystemServiceKeys.aiImage).status
                        .getBoolInt()
                        .obs
                        .value)
                      Container(
                        width: Get.width,
                        padding: const EdgeInsets.only(left: 8, top: 2, bottom: 2), decoration: boxDecorationWithRoundedCorners(backgroundColor: isDarkMode.value ? appScreenBackgroundDark : appScreenBackground, borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                                Assets.iconsIcAiAvtar.iconImage(color: isDarkMode.value ? appColorSecondary : canvasColor,size: 32),
                            Text(
                              getSystemServicebyKey(type: SystemServiceKeys.aiImage).name.isNotEmpty ? getSystemServicebyKey(type: SystemServiceKeys.aiImage).name : locale.value.aiImage,
                              overflow: TextOverflow.ellipsis,
                              style: primaryTextStyle(color: isDarkMode.value ? whiteTextColor : canvasColor, size: 14, weight: FontWeight.w600),
                            ).expand(),
                          ],
                        ),
                      ).onTap(() {
                        /// Navigate to System Service
                        navigateToService(serviceType: SystemServiceKeys.aiImage);
                      }).expand(),
                    16.height.visible(getSystemServicebyKey(type: SystemServiceKeys.aiImage).status
                        .getBoolInt()
                        .obs
                        .value && getSystemServicebyKey(type: SystemServiceKeys.aiCode).status
                        .getBoolInt()
                        .obs
                        .value),
                    if (getSystemServicebyKey(type: SystemServiceKeys.aiCode).status
                        .getBoolInt()
                        .obs
                        .value)
                      Container(
                        width: Get.width,
                        padding: const EdgeInsets.only(left: 8, top: 2, bottom: 2),
                        decoration: boxDecorationWithRoundedCorners(backgroundColor: appColorSecondary, borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Assets.iconsIcAiPhotoEnhancer.iconImage(color: canvasColor, size: 32),
                            Text(
                              getSystemServicebyKey(type: SystemServiceKeys.aiCode).name,
                              overflow: TextOverflow.ellipsis,
                              style: primaryTextStyle(color: canvasColor, size: 14, weight: FontWeight.w600),
                            ).expand(),
                          ],
                        ),
                      ).onTap(() {
                        /// Navigate to System Service
                        navigateToService(serviceType: SystemServiceKeys.aiCode, arguments: CustomTemplate.fromJson(aiCodeTemplate));
                      }).expand(),
                  ],
                ).expand(),
              ],
            ),
          ).paddingBottom(16),
    );
  }
}
