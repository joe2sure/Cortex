import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/generated/assets.dart';

import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';

class SuggestionImageComponent extends StatelessWidget {
  const SuggestionImageComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width(),
      decoration: boxDecorationWithRoundedCorners(backgroundColor: isDarkMode.value ? fullDarkCanvasColorDark : appSectionBackground, borderRadius: BorderRadius.circular(4)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            Assets.imagesUploadResult,
          ),
          Text(
            locale.value.xCartoonArt,
            style: primaryTextStyle(color: isDarkMode.value ? whiteTextColor : canvasColor, size: 20, weight: FontWeight.w500, fontFamily: GoogleFonts.instrumentSans().fontFamily),
          ).paddingSymmetric(vertical: 30),
          AppButton(
              height: 52,
              width: context.width(),
              text: locale.value.tryNow,
              textStyle: primaryTextStyle(color: whiteTextColor, size: 14, weight: FontWeight.w500, fontFamily: GoogleFonts.instrumentSans().fontFamily),
              elevation: 0,
              color: appColorPrimary,
              onTap: () {}),
        ],
      ).paddingSymmetric(horizontal: 30, vertical: 30),
    );
  }
}
