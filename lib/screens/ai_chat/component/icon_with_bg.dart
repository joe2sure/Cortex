import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/utils/app_common.dart';

import '../../../utils/colors.dart';

class IconWithBGWidget extends StatelessWidget {
  final String iconPath;
  final Color bgColor;
  final Function()? onPressed;

  const IconWithBGWidget({
    super.key,
    required this.iconPath,
    this.onPressed,
    this.bgColor = lightPrimaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: onPressed,
        behavior: HitTestBehavior.translucent,
        child: Container(
          height: 28,
          width: 28,
          decoration: boxDecorationWithRoundedCorners(
            backgroundColor: bgColor,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: isDarkMode.value ? borderColorDark : borderColor, width: 0.3),
          ),
          child: Image.asset(
            iconPath,
            color: appColorPrimary,
          ).paddingAll(7),
        ),
      ),
    );
  }
}
