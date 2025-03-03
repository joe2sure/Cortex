import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';

class StyleComponent extends StatelessWidget {
  final String styleTitle;
  final bool isSelected;
  final String imagePath;
  final double paddingAllValue;
  final bool showBorder;
  final double imageHeight;
  final double imageWidth;
  const StyleComponent({super.key, required this.styleTitle, this.isSelected = false, required this.imagePath, this.showBorder = true, this.paddingAllValue = 4, this.imageHeight = 74, this.imageWidth = 74});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecorationWithRoundedCorners(
          backgroundColor: isDarkMode.value ? fullDarkCanvasColorDark : appSectionBackground, borderRadius: BorderRadius.circular(5), border: showBorder ? Border.all(color: isSelected ? appColorPrimary : borderColor) : null),
      child: Column(
        children: [
          SizedBox(
            height: imageHeight,
            width: imageWidth,
            // decoration: boxDecorationWithRoundedCorners(
            //     borderRadius: BorderRadius.circular(5)),
            child: Image.asset(
              imagePath,
              fit: BoxFit.fill,
            ),
          ),
          Text(
            styleTitle,
            style: primaryTextStyle(
                size: 12,
                weight: FontWeight.w400,
                color: isSelected
                    ? appColorPrimary
                    : isDarkMode.value
                        ? whiteTextColor
                        : canvasColor),
          ).paddingTop(5)
        ],
      ).paddingAll(paddingAllValue),
    );
  }
}
