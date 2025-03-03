import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/utils/common_base.dart';


import '../../../../utils/app_common.dart';
import '../../../../utils/colors.dart';

class TextAfterIconWidget extends StatelessWidget {
  final String title;
  final String iconPath;
  final bool isSelected;
  final Function()? onPressed;
  const TextAfterIconWidget(
      {super.key,
      required this.title,
      required this.iconPath,
      required this.isSelected,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecorationWithRoundedCorners(
          backgroundColor: isSelected
              ? appColorPrimary
              : isDarkMode.value
                  ? fullDarkCanvasColorDark
                  : appScreenBackground,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
              color: isSelected
                  ? appColorPrimary
                  : isDarkMode.value
                      ? borderColorDark
                      : borderColor)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: primaryTextStyle(
                size: 12,
                weight: FontWeight.w500,
                color: isSelected ? whiteTextColor : appBodyColor),
          ),
          5.width,
          iconPath.iconImage(
              size: 14,
              color: isSelected ? appSectionBackground : appColorPrimary)
        ],
      ).paddingAll(10),
    ).onTap(onPressed);
  }
}
