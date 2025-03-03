import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/screens/ai_image2text/ai_img_to_txt_controller.dart';
import 'package:Cortex/utils/app_common.dart';
import 'package:Cortex/utils/common_base.dart';

import '../../../components/app_scaffold.dart';
import '../../../components/cached_image_widget.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../../utils/view_all_label_component.dart';
import '../../../utils/zoom_image_screen.dart';

class ImgToTxtResultScreen extends StatelessWidget {
  ImgToTxtResultScreen({super.key});

  final AiImgToTxtController aiImgToTxtController = Get.find();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBartitleText: aiImgToTxtController.selectedTagsAndDescriptions.value.imageName,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: aiImgToTxtController.selectedTagsAndDescriptions.value.reqImageUrl.isNotEmpty ? aiImgToTxtController.selectedTagsAndDescriptions.value.reqImageUrl : currentMillisecondsTimeStamp().toString(),
              child: GestureDetector(
                onTap: () {
                  Get.to(() => ZoomSingleImg(url: aiImgToTxtController.selectedTagsAndDescriptions.value.reqImageUrl));
                },
                child: CachedImageWidget(
                  url: aiImgToTxtController.selectedTagsAndDescriptions.value.reqImageUrl,
                  height: Get.width * 0.7,
                  width: Get.width,
                  fit: BoxFit.cover,
                ).cornerRadiusWithClipRRect(defaultRadius),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ViewAllLabel(label: locale.value.tags, isShowAll: false),
                Wrap(
                  runSpacing: 8,
                  spacing: 8,
                  children: List.generate(
                    aiImgToTxtController.selectedTagsAndDescriptions.value.tags.length,
                    (index) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: boxDecorationDefault(color: isDarkMode.value ? fullDarkCanvasColor : lightPrimaryColor),
                      child: Text(
                        aiImgToTxtController.selectedTagsAndDescriptions.value.tags[index],
                        style: secondaryTextStyle(),
                      ),
                    ),
                  ),
                )
              ],
            ).paddingTop(16),
            ViewAllLabel(label: locale.value.description, isShowAll: false),
            Hero(
              tag: aiImgToTxtController.selectedTagsAndDescriptions.value.description.formattedHeroTag,
              child: Text(
                aiImgToTxtController.selectedTagsAndDescriptions.value.description,
                style: secondaryTextStyle(size: 14, decoration: TextDecoration.none),
              ),
            ),
          ],
        ).paddingSymmetric(horizontal: 16, vertical: 20),
      ),
    );
  }
}
