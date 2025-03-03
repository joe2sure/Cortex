import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/generated/assets.dart';
import 'package:Cortex/utils/common_base.dart';
import '../utils/colors.dart';

class BackWidget extends StatelessWidget {
  final Function()? onPressed;
  final Color? iconColor;
  final double backIconSize;

  const BackWidget({super.key, this.onPressed, this.iconColor, this.backIconSize = 15});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ??
          () {
            finish(context);
          },
      icon: Assets.iconsIcBack.iconImage(color: iconColor ?? dividerColor, size: backIconSize, fit: BoxFit.fitHeight),
    );
  }
}
