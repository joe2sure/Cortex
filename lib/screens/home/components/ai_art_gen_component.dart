import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/components/cached_image_widget.dart';
import 'package:Cortex/generated/assets.dart';
import 'package:Cortex/utils/common_base.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants.dart';
import '../services/system_service_helper.dart';

class AiArtGenComponent extends StatelessWidget {
  const AiArtGenComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        /// Navigate to System Service
        navigateToService(serviceType: SystemServiceKeys.aiArtGenerator);
      },
      child: Container(
        width: Get.width,
        decoration: boxDecorationWithRoundedCorners(backgroundColor: isDarkMode.value ? appScreenBackgroundDark : canvasColor, borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: [
            Positioned(
              top: -5,
              right: -10,
              child: CachedImageWidget(
                url: Assets.iconsArtGeneratorBg,
                width: Get.width / 2.1,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Assets.iconsIcAiChart.iconImage(color: appColorSecondary,size: 36),
                Text(
                  getSystemServicebyKey(type: SystemServiceKeys.aiArtGenerator).name,
                  style: primaryTextStyle(color: whiteTextColor, size: 14, weight: FontWeight.w600),
                ),
              ],
            ).paddingAll(20)
          ],
        ),
      ),
    );
  }
}
