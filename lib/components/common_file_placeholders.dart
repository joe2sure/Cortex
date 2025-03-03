import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/utils/colors.dart';

class CommonPdfPlaceHolder extends StatelessWidget {
  final String text;
  final String fileExt;
  final double width;
  final double height;
  final double iconSize;
  final int? textSize;

  const CommonPdfPlaceHolder({super.key, this.height = 90, this.width = 80, this.iconSize = 32, this.textSize, this.text = "file", this.fileExt = ""});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(defaultRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            fileExt.isPdf
                ? Icons.picture_as_pdf_outlined
                : fileExt.isVideo
                    ? Icons.video_file_outlined
                    : fileExt.isAudio
                        ? Icons.audio_file_outlined
                        : Icons.file_copy_rounded,
            color: appColorPrimary,
            size: iconSize,
          ).paddingBottom(iconSize * 0.3),
          Marquee(child: Text(text == "file" ? "File" : text, overflow: TextOverflow.ellipsis, style: primaryTextStyle(size: textSize), maxLines: 1, textAlign: TextAlign.center)),
        ],
      ).center(),
    );
  }
}
