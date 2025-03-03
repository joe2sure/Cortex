import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/utils/common_base.dart';

import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import '../model/explore_more_model.dart';

class ExploreMoreComponent extends StatelessWidget {
  final void Function()? onTapCard;
  final ExploreMoreModel exploreMoreItem;

  const ExploreMoreComponent({super.key, this.onTapCard, required this.exploreMoreItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.5,
      padding: const EdgeInsets.all(16),
      decoration: boxDecoration(color: isDarkMode.value ? fullDarkCanvasColorDark : lightPrimaryColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: boxDecorationWithRoundedCorners(backgroundColor: context.cardColor, boxShape: BoxShape.circle),
            child: exploreMoreItem.icon.iconImage(size: 25, color: appColorPrimary).center(),
          ),
          16.height,
          Text(exploreMoreItem.title, style: primaryTextStyle(), maxLines: 2, overflow: TextOverflow.ellipsis),
          16.height,
          AppButton(
            text: locale.value.exploreNow,
            textStyle: primaryTextStyle(color: Colors.white),
            width: Get.width,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: canvasColor,
            onTap: onTapCard,
          ),
        ],
      ),
    );
  }
}
