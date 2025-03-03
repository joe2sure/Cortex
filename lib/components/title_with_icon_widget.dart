import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/utils/common_base.dart';
import '../utils/colors.dart';

class TitleWithIconWidget extends StatelessWidget {
  final String iconPath;
  final String title;
  final Color? iconColor;
  final Color? textColor;
  final double iconSize;
  const TitleWithIconWidget({super.key, required this.iconPath, required this.title, this.iconColor, this.textColor, this.iconSize = 16});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (iconPath.isNotEmpty) ...[iconPath.iconImage(size: iconSize, color: iconColor ?? appSectionBackground), 10.width],
        Text(title, style: boldTextStyle(size: 14, weight: FontWeight.w500, color: textColor ?? whiteTextColor)),
      ],
    );
  }
}
