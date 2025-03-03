import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/utils/app_common.dart';
import 'package:Cortex/utils/colors.dart';

import '../../components/cached_image_widget.dart';
import '../../generated/assets.dart';
import '../../main.dart';
import '../../utils/common_base.dart';

class PlanConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final String? titleText;
  final String? subTitleText;
  final String? confirmText;

  const PlanConfirmationDialog({
    super.key,
    required this.onConfirm,
    this.titleText,
    this.subTitleText,
    this.confirmText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: boxDecorationDefault(color: context.cardColor),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 100,
            width: 100,
            alignment: Alignment.center,
            decoration: boxDecorationDefault(shape: BoxShape.circle, color: appColorSecondary),
            child: const CachedImageWidget(url: Assets.iconsIcConfirm, height: 50, width: 50, fit: BoxFit.contain),
          ),
          16.height,
          Text(titleText ?? locale.value.confirm, style: primaryTextStyle()),
          16.height,
          Text(subTitleText ?? locale.value.doYouConfirmThisPlan, textAlign: TextAlign.center, style: primaryTextStyle(color: secondaryTextColor)).paddingSymmetric(horizontal: 32),
          32.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppButton(
                color: isDarkMode.value ? black : white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shapeBorder: RoundedRectangleBorder(side: BorderSide(color: isDarkMode.value ?appColorPrimary : context.primaryColor),borderRadius: BorderRadius.circular(10)),
                text: locale.value.cancel,
                textStyle: TextStyle(color: isDarkMode.value ? appColorPrimary : context.primaryColor),
                onTap: () {
                  Get.back();
                },
              ).expand(),
              32.width,
              AppButton(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                text: locale.value.confirm,
                textStyle: appButtonTextStyleWhite,
                onTap: () {
                  onConfirm.call();
                },
              ).expand(),
            ],
          ).paddingSymmetric(horizontal: 32),
        ],
      ),
    );
  }
}
