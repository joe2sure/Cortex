import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/components/cached_image_widget.dart';
import '../../../components/common_file_placeholders.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import '../../../utils/zoom_image_screen.dart';
import '../../home/model/messages_res.dart';

class QuestionComponent extends StatelessWidget {
  final MessegeElement question;
  const QuestionComponent({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          32.width,
          Container(
            decoration: boxDecorationWithRoundedCorners(
                backgroundColor: isDarkMode.value ? fullDarkCanvasColorDark : appSectionBackground,
                border: Border.all(color: isDarkMode.value ? borderColorDark : borderColor, width: 0.5),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), bottomRight: Radius.circular(8), bottomLeft: Radius.circular(8))),
            child: Column(
              children: [
                ...filesComponent(context),
                SelectableText(
                  question.messageText.trim(),
                  style: primaryTextStyle(size: 14, weight: FontWeight.w400, color: appBodyColor),
                ),
              ],
            ).paddingSymmetric(vertical: 10, horizontal: 12),
          ).flexible(),
          12.width,
          Container(
            decoration: boxDecorationDefault(
                shape: BoxShape.circle,
                border: Border.all(
                  color: whiteTextColor,
                  width: 2,
                )),
            child: CachedImageWidget(
              url: loginUserData.value.profileImage,
              firstName: loginUserData.value.firstName,
              lastName: loginUserData.value.lastName,
              height: 30,
              fit: BoxFit.cover,
              width: 30,
            ).cornerRadiusWithClipRRect(30).center(),
          ),
        ],
      ).paddingSymmetric(horizontal: 16),
    );
  }

  List<Widget> filesComponent(BuildContext context) {
    return question.images.isNotEmpty
        ? [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: question.images.map((file) {
                  debugPrint('FILE: $file');
                  // int index = _eventFiles.indexOf(eventFile);
                  return GestureDetector(
                    onTap: () {
                      if (file.contains(RegExp(r'\.jpeg|\.jpg|\.gif|\.png|\.bmp'))) {
                        Get.to(() => ZoomImageScreen(index: 0, galleryImages: [file]));
                      } else {
                        viewFiles(file);
                      }
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: Loader(),
                        ),
                        file.contains(RegExp(r'\.jpeg|\.jpg|\.gif|\.png|\.bmp'))
                            ? CachedImageWidget(
                                url: file,
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                                radius: 8,
                              )
                            : Container(
                                padding: const EdgeInsets.all(4),
                                decoration: boxDecorationRoundedWithShadow(defaultRadius.toInt(), backgroundColor: context.cardColor),
                                child: CommonPdfPlaceHolder(
                                  text: "${file.getFileExtension.replaceAll(".", "").capitalize} file",
                                  fileExt: file.getFileExtension,
                                ),
                              ),
                      ],
                    ).paddingRight(8),
                  );
                }).toList(),
              ),
            ).paddingBottom(8),
          ]
        : [];
  }
}
