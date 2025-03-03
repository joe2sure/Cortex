import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/generated/assets.dart';
import 'package:Cortex/utils/common_base.dart';

import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants.dart';
import '../../../components/icon_with_text_widget.dart';
import '../services/system_service_helper.dart';

class SysServComp4 extends StatelessWidget {
  const SysServComp4({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          // if (getSystemServicebyKey(type: SystemServiceKeys.aiVoiceToText).status.getBoolInt().obs.value)
          Container(
            decoration: boxDecorationWithRoundedCorners(backgroundColor: isDarkMode.value ? appScreenBackgroundDark : appScreenGreyBackground, borderRadius: BorderRadius.circular(10)),
            child: IconWithText(
              icon: Assets.iconsIcAiSpeechToText.iconImage(color: isDarkMode.value ? appColorSecondary : canvasColor,size:26),
              title: getSystemServicebyKey(type: SystemServiceKeys.aiVoiceToText).name.isNotEmpty ? getSystemServicebyKey(type: SystemServiceKeys.aiVoiceToText).name : 'AI Voice To Text',
              textColor: isDarkMode.value ? whiteTextColor : canvasColor,
            ).paddingAll(20),
          ).onTap(() {
            /// Navigate to System Service
              navigateToService(serviceType: SystemServiceKeys.aiVoiceToText);
          }).expand(),
        ],
      ).paddingBottom(16),
    );
  }
}
