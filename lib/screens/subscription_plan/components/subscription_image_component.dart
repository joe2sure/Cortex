import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/utils/app_common.dart';

import '../../../utils/colors.dart';

class SubscriptionImageComponent extends StatelessWidget {
  final String imagePath;
  final String title;

  const SubscriptionImageComponent({super.key, required this.imagePath, required this.title});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        width: Get.width / 3 - 24,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: boxDecorationDefault(color: isDarkMode.value ? lightCanvasColor : context.cardColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 92, width: 92),
            Text(title, style: primaryTextStyle(color: isDarkMode.value ? whiteTextColor : textPrimaryColor), maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

class SubIconWithText extends StatelessWidget {
  final Widget icon;
  final String title;
  final Color? textColor;
  final int? textSize;
  final FontWeight? fontWeight;
  final MainAxisAlignment? mainAxisAlignment;

  const SubIconWithText({super.key, required this.icon, required this.title, this.textColor, this.textSize, this.fontWeight, this.mainAxisAlignment});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        icon,
        10.width,
        Marquee(
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: primaryTextStyle(color: textColor ?? whiteTextColor, size: textSize ?? 14, weight: fontWeight ?? FontWeight.w600),
          ),
        ).expand(),
      ],
    );
  }
}
