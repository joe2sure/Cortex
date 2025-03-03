import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../utils/colors.dart';

class IconWithText extends StatelessWidget {
  final Widget icon;
  final String title;
  final Color? textColor;
  final int? textSize;
  final FontWeight? fontWeight;
  final MainAxisAlignment? mainAxisAlignment;
  const IconWithText({super.key, required this.icon, required this.title, this.textColor, this.textSize, this.fontWeight, this.mainAxisAlignment});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        icon,
        10.width,
        Text(
          title,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: primaryTextStyle(color: textColor ?? whiteTextColor, size: textSize ?? 14, weight: fontWeight ?? FontWeight.w600),
        ).flexible(),
      ],
    );
  }
}
