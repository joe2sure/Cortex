import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';

class RatioComponent extends StatelessWidget {
  final String ratioTitle;
  final Widget ratioChild;
  final bool isSelected;
  const RatioComponent({super.key, required this.ratioChild, required this.isSelected, required this.ratioTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecorationWithRoundedCorners(
        borderRadius: BorderRadius.circular(8),
        backgroundColor: isSelected
            ? appColorPrimary
            : isDarkMode.value
                ? fullDarkCanvasColorDark
                : appSectionBackground,
        border: Border.all(
          color: isSelected
              ? appColorPrimary
              : isDarkMode.value
                  ? borderColorDark
                  : borderColor,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          ratioChild,
          7.width,
          Text(
            ratioTitle,
            style: primaryTextStyle(
              weight: FontWeight.w400,
              color: isSelected ? whiteTextColor : appBodyColor,
              size: 14,
            ),
          )
        ],
      ).paddingSymmetric(vertical: 12, horizontal: 16),
    );
  }
}
