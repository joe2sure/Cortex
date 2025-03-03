import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/components/loader_widget.dart';
import 'package:Cortex/screens/ai_image2text/ai_img_to_txt_controller.dart';
import '../../../components/cached_image_widget.dart';
import '../../../generated/assets.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import '../../../utils/view_all_label_component.dart';

class ImagePromptComponent extends StatelessWidget {
  ImagePromptComponent({super.key});
  final AiImgToTxtController tagsAndDescGenController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ViewAllLabel(label: locale.value.uploadImage, isShowAll: false).paddingOnly(right: 8),
        Obx(
          () => tagsAndDescGenController.pickedImage.value.path.isNotEmpty
              ? Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      const SizedBox(
                        width: 110,
                        height: 110,
                        child: LoaderWidget(),
                      ),
                      Hero(
                        tag: tagsAndDescGenController.pickedImage.value.path,
                        child: CachedImageWidget(
                          url: tagsAndDescGenController.pickedImage.value.path,
                          height: 110,
                          width: 110,
                          fit: BoxFit.cover,
                        ).cornerRadiusWithClipRRect(defaultRadius),
                      ),
                      Positioned(
                        top: 110 * 3 / 4 + 4,
                        left: 110 * 3 / 4 + 4,
                        child: GestureDetector(
                          onTap: () {
                            hideKeyboard(context);
                            tagsAndDescGenController.showBottomSheet(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: boxDecorationDefault(shape: BoxShape.circle, color: Colors.white),
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: boxDecorationDefault(shape: BoxShape.circle, color: appColorPrimary),
                              child: const Icon(Icons.edit, size: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ).paddingBottom(16),
                )
              : GestureDetector(
                  onTap: () {
                    hideKeyboard(context);
                    tagsAndDescGenController.showBottomSheet(context);
                  },
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    width: Get.width,
                    decoration: boxDecorationWithRoundedCorners(
                      borderRadius: BorderRadius.circular(8),
                      backgroundColor: isDarkMode.value ? borderColor.withOpacity(0.1) : appScreenBackground,
                    ),
                    child: DottedBorderWidget(
                      color: isDarkMode.value ? borderColorDark : bodyWhite,
                      radius: 8,
                      gap: 6,
                      child: Column(
                        children: [
                          Image.asset(
                            Assets.iconsIcGallery,
                            width: 33,
                            height: 30,
                          ),
                          15.height,
                          Text(
                            locale.value.chooseYourImage,
                            style: primaryTextStyle(size: 14, weight: FontWeight.w400, color: isDarkMode.value ? whiteTextColor : canvasColor),
                          ),
                        ],
                      ).paddingSymmetric(vertical: 25, horizontal: 20),
                    ),
                  ),
                ),
        ),
        10.height,
        FittedBox(
          child: Text(
            locale.value.noteYouCanUploadImageWithJpgPngJpegExtension,
            style: primaryTextStyle(size: 12, weight: FontWeight.w500, fontStyle: FontStyle.italic, color: isDarkMode.value ? deleteTextColor : redTextColor),
          ),
        ),
      ],
    ).paddingSymmetric(horizontal: 16);
  }
}
