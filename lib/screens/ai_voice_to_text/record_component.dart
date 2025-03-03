import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/generated/assets.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';

class RecordComponent extends StatelessWidget {
  final String recordTitle;
  final String format;
  final String size;
  final String time;
  const RecordComponent({super.key, required this.recordTitle, required this.time, required this.format, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecorationWithRoundedCorners(
        backgroundColor: isDarkMode.value ? fullDarkCanvasColorDark : appSectionBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle, backgroundColor: appColorPrimary),
                child: const Icon(
                  Icons.play_arrow_outlined,
                  color: appSectionBackground,
                ),
              ),
              15.width,
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recordTitle,
                    style: primaryTextStyle(size: 16, weight: FontWeight.w500, color: isDarkMode.value ? whiteTextColor : canvasColor),
                  ),
                  3.height,
                  RichTextWidget(list: [
                    TextSpan(
                      text: format,
                      style: primaryTextStyle(size: 12, weight: FontWeight.w600, color: appBodyColor, fontFamily: GoogleFonts.instrumentSans().fontFamily),
                    ),
                    TextSpan(
                      text: " - $size",
                      style: primaryTextStyle(size: 12, weight: FontWeight.w600, color: appBodyColor, fontFamily: GoogleFonts.instrumentSans().fontFamily),
                    )
                  ]),
                  15.height,
                  Container(
                    decoration: boxDecorationWithRoundedCorners(backgroundColor: isDarkMode.value ? fullDarkCanvasColorDark : appSectionBackground, borderRadius: BorderRadius.circular(20), border: Border.all(color: appBodyColor)),
                    child: Text(
                      time,
                      style: primaryTextStyle(color: appBodyColor, size: 12, weight: FontWeight.w600),
                    ).paddingSymmetric(horizontal: 10, vertical: 6),
                  )
                ],
              ).flexible(),
              20.width,
            ],
          ).paddingAll(20),
          Positioned(
            right: 10,
            top: 10,
            child: Align(
                alignment: Alignment.topRight,
                child: Image.asset(
                  Assets.iconsIcVertical3Dot,
                  height: 20,
                  width: 20,
                )).onTap(() {}),
          )
        ],
      ),
    );
  }
}
