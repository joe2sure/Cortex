import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/generated/assets.dart';
import 'package:Cortex/utils/common_base.dart';

import '../../../utils/colors.dart';
import '../../../utils/constants.dart';
import '../../../components/icon_with_text_widget.dart';
import '../services/system_service_helper.dart';

class SysServComp3 extends StatelessWidget {
  const SysServComp3({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          if (getSystemServicebyKey(type: SystemServiceKeys.aiImageToText).status.getBoolInt().obs.value)
            Container(
              decoration: boxDecorationWithRoundedCorners(backgroundColor: appColorPrimary, borderRadius: BorderRadius.circular(10)),
              child: IconWithText(
                icon: Assets.iconsIcAiImageText.iconImage(color: whiteTextColor,size:26),
                title: getSystemServicebyKey(type: SystemServiceKeys.aiImageToText).name.isNotEmpty ? getSystemServicebyKey(type: SystemServiceKeys.aiImageToText).name : 'AI Image To Text',
                textColor: whiteTextColor,
              ).paddingAll(20),
            ).onTap(() {
              /// Navigate to System Service
              navigateToService(serviceType: SystemServiceKeys.aiImageToText);
            }).expand(),
        ],
      ).paddingBottom(16),
    );
  }
}
