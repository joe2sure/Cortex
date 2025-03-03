import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/utils/app_common.dart';
import 'package:Cortex/utils/colors.dart';

import '../../components/cached_image_widget.dart';
import '../../utils/common_base.dart';

enum AppDialogType { confirmation, update, delete, add, accept } // Define your enum for different dialog types

class AppDialogWidget extends StatelessWidget {
  final VoidCallback onConfirm;
  final AppDialogType dialogType;

  final EdgeInsets? padding;
  final double? width;
  final String? titleText;
  final String? dialogText;
  final String? positiveText;
  final String? negativeText;

  final String? description;
  final Color? buttonColor;
  final TextStyle? titleTextStyle;
  final TextStyle? dialogTextStyle;
  final Color? confirmTextColor;
  final Color? cancelTextColor;

  final Widget? dialogImageWidget;

  final String? dialogImage;

  const AppDialogWidget({
    super.key,
    required this.onConfirm,
    this.dialogType = AppDialogType.confirmation,
    this.titleText,
    this.padding,
    this.dialogText,
    this.width,
    this.positiveText,
    this.negativeText,
    this.buttonColor,
    this.titleTextStyle,
    this.dialogImageWidget,
    this.confirmTextColor = Colors.white,
    this.cancelTextColor = appColorPrimary,
    this.description,
    this.dialogImage,
    this.dialogTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    String titleText = '';
    String dialogText = '';
    String positiveText = '';

    String? cancelText = negativeText ?? 'Cancel';

    switch (dialogType) {
      case AppDialogType.confirmation:
        titleText = this.titleText ?? 'Confirm';
        dialogText = this.dialogText ?? 'Do you want to perform this action?';
        positiveText = this.positiveText ?? 'Confirm';
        break;
      case AppDialogType.delete:
        titleText = this.titleText ?? 'Delete';
        dialogText = this.dialogText ?? 'Do you want to delete action?';
        positiveText = this.positiveText ?? 'Delete';
        break;
      case AppDialogType.update:
        titleText = this.titleText ?? 'Update';
        dialogText = this.dialogText ?? '';
        positiveText = this.positiveText ?? 'Update';
        break;
      case AppDialogType.add:
        titleText = this.titleText ?? 'Add';
        dialogText = this.dialogText ?? '';
        positiveText = this.positiveText ?? 'Add';
      case AppDialogType.accept:
        titleText = this.titleText ?? 'Accept';
        dialogText = this.dialogText ?? '';
        positiveText = this.positiveText ?? 'Accept';
    }

    return Container(
      width: width ?? Get.width,
      padding: padding ?? const EdgeInsets.symmetric(vertical: 32),
      decoration: boxDecorationDefault(color: context.cardColor),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dialogImageWidget != null)
            dialogImageWidget.validate()
          else
            Container(
              height: 80,
              width: 80,
              alignment: Alignment.center,
              decoration: boxDecorationDefault(shape: BoxShape.circle, color: appColorSecondary),
              child: CachedImageWidget(
                url: dialogImage ?? getDialogImage(dialogType),
                color: Colors.white,
                height: 40,
                width: 40,
                fit: BoxFit.contain,
              ),
            ),
          16.height,
          Text(titleText, style: titleTextStyle ?? primaryTextStyle(color: appColorPrimary)),
          16.height,
          Text(
            dialogText,
            textAlign: TextAlign.center,
            style: dialogTextStyle ?? primaryTextStyle(size: 16),
          ).paddingSymmetric(horizontal: 32),
          if (description.validate().isNotEmpty) 16.height,
          if (description.validate().isNotEmpty)
            ReadMoreText(
              description.validate(),
              textAlign: TextAlign.justify,
              trimLines: 2,
              colorClickableText: appColorPrimary,
              style: secondaryTextStyle(),
            ).paddingSymmetric(horizontal: 16),
          32.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppButton(
                color: isDarkMode.value ? black : white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: confirmTextColor ?? appColorPrimary,
                    )),
                text: cancelText,
                textStyle: secondaryTextStyle(color: cancelTextColor ?? appColorPrimary),
                onTap: () {
                  Get.back();
                },
              ).expand(),
              32.width,
              AppButton(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: confirmTextColor ?? appColorPrimary,
                    )),
                text: positiveText,
                textStyle: appButtonTextStyleWhite,
                color: buttonColor ?? appColorPrimary,
                onTap: () {
                  onConfirm.call();
                },
              ).expand(),
            ],
          ).paddingSymmetric(horizontal: 16),
        ],
      ),
    );
  }
}
