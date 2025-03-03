import 'package:flutter/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/generated/assets.dart';
import 'package:Cortex/utils/common_base.dart';

import '../../../../utils/app_common.dart';
import '../../../../utils/colors.dart';


class DurationWithTextComponent extends StatelessWidget {
  final String time;
  final String text;
  const DurationWithTextComponent(
      {super.key, required this.time, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
        Assets.iconsIcClock.iconImage(size: 18, color: appColorPrimary),
            10.width,
            Text(
              time,
              style: primaryTextStyle(
                  size: 14,
                  weight: FontWeight.w500,
                  color: isDarkMode.value ? whiteTextColor : canvasColor),
            )
          ],
        ),
        10.height,
        Text(
          text,
          style: secondaryTextStyle(
              size: 14, weight: FontWeight.w400, color: appBodyColor),
        )
      ],
    );
  }
}
