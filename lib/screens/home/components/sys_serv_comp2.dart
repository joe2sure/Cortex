import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/generated/assets.dart';
import 'package:Cortex/utils/common_base.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants.dart';
import '../../../components/icon_with_text_widget.dart';
import '../home_controller.dart';
import '../services/system_service_helper.dart';

class SysServComp2 extends StatelessWidget {
  SysServComp2({super.key});
  final HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          if (getSystemServicebyKey(type: SystemServiceKeys.aiChat).status.getBoolInt().obs.value)
            Container(
              height: 60,
              decoration: boxDecorationWithRoundedCorners(backgroundColor: isDarkMode.value ? appScreenBackgroundDark : appScreenGreyBackground, borderRadius: BorderRadius.circular(10)),
              child: IconWithText(
                icon: Assets.iconsIcAiChatbot.iconImage(color: isDarkMode.value ? appColorSecondary : canvasColor,size:26),
                title: getSystemServicebyKey(type: SystemServiceKeys.aiChat).name.isNotEmpty ? getSystemServicebyKey(type: SystemServiceKeys.aiChat).name : locale.value.aiChat,
                textColor: isDarkMode.value ? whiteTextColor : canvasColor,
              ).paddingAll(20),
            ).onTap(() {
              /// Navigate to System Service
              navigateToService(serviceType: SystemServiceKeys.aiChat);
            }).expand(),
          16.width.visible(getSystemServicebyKey(type: SystemServiceKeys.aiWriter).status.getBoolInt().obs.value && getSystemServicebyKey(type: SystemServiceKeys.aiChat).status.getBoolInt().obs.value),
          if (getSystemServicebyKey(type: SystemServiceKeys.aiWriter).status.getBoolInt().obs.value)
            Container(
              height: 60,
              decoration: boxDecorationWithRoundedCorners(backgroundColor: isDarkMode.value ? appScreenBackgroundDark : appScreenGreyBackground, borderRadius: BorderRadius.circular(10)),
              child: IconWithText(
                icon: Assets.iconsIcAiWriter.iconImage(color: isDarkMode.value ? appColorSecondary : canvasColor,size:26),
                title: getSystemServicebyKey(type: SystemServiceKeys.aiWriter).name.isNotEmpty ? getSystemServicebyKey(type: SystemServiceKeys.aiWriter).name : 'AI Writer',
                textColor: isDarkMode.value ? whiteTextColor : canvasColor,
              ).paddingAll(20),
            ).onTap(() {
              /// Navigate to System Service
              navigateToService(serviceType: SystemServiceKeys.aiWriter);
            }).expand(),
        ],
      ).paddingOnly(
        bottom: getSystemServicebyKey(type: SystemServiceKeys.aiChat).status.getBoolInt().obs.value || getSystemServicebyKey(type: SystemServiceKeys.aiWriter).status.getBoolInt().obs.value ? 16 : 0,
      ),
    );
  }
}
