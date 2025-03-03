import 'package:before_after/before_after.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/components/loader_widget.dart';
import 'package:Cortex/screens/ai_image/ai_image_controller.dart';

import '../../../components/cached_image_widget.dart';
import '../../../generated/assets.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import '../../../utils/zoom_image_screen.dart';

class SelectImageForEnhance extends StatelessWidget {
  final RxString imgPath;
  final RxBool showSparkleLoader;
  final void Function()? onCameraTap;

  SelectImageForEnhance({super.key, this.onCameraTap, required this.showSparkleLoader, required this.imgPath});

  final AiImageController photoEnhancerController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        8.height,
        Obx(
          () => imgPath.value.isNotEmpty
              ? Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: Get.height * 0.28,
                        height: Get.height * 0.28,
                        child: const LoaderWidget(),
                      ),
                      Stack(
                        children: [
                          Hero(
                            tag: imgPath.value,
                            child: GestureDetector(
                              onTap: () {
                                Get.to(
                                  () => ZoomSingleImg(url: imgPath.value),
                                  duration: const Duration(milliseconds: 500),
                                );
                              },
                              child: CachedImageWidget(
                                url: imgPath.value,
                                height: Get.height * 0.28,
                                width: Get.height * 0.28,
                                fit: BoxFit.cover,
                              ).cornerRadiusWithClipRRect(defaultRadius),
                            ),
                          ),
                          Positioned(
                            child: Obx(
                              () => Container(
                                color: Colors.black.withOpacity(0.4),
                                alignment: Alignment.center,
                                height: Get.height * 0.28,
                                width: Get.height * 0.28,
                                child: const SparkleLoderWidget(),
                              ).cornerRadiusWithClipRRect(defaultRadius).visible(showSparkleLoader.value),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : Container(
                  width: Get.width,
                  padding: const EdgeInsets.only(bottom: 8),
                  decoration: boxDecorationWithRoundedCorners(
                    backgroundColor: isDarkMode.value ? fullDarkCanvasColorDark : appSectionBackground,
                    borderRadius: radius(8),
                  ),
                  child: Column(
                    children: [
                      BeforeAfter(
                        value: photoEnhancerController.sliderPosition.value,
                        trackColor: Colors.white,
                        trackWidth: 2.5,
                        width: Get.width - 32,
                        onValueChanged: (value) {
                          photoEnhancerController.sliderPosition(value);
                        },
                        thumbDecoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: radius(defaultRadius),
                          image: const DecorationImage(image: AssetImage(Assets.iconsIcLeftRightArrow)),
                        ),
                        before: Stack(
                          children: [
                            Image.asset(Assets.imagesBeforePortraitImg),
                            Positioned(
                              top: 16,
                              right: 16,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                                decoration: boxDecorationDefault(color: Colors.white, borderRadius: radius(8)),
                                child: Text(locale.value.before, style: primaryTextStyle(color: Colors.black)),
                              ),
                            ),
                          ],
                        ),
                        after: Stack(
                          children: [
                            Image.asset(Assets.imagesAfterPortraitImg),
                            Positioned(
                              top: 16,
                              left: 16,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                                decoration: boxDecorationDefault(color: appColorSecondary, borderRadius: radius(8)),
                                child: Text(locale.value.after, style: primaryTextStyle(color: black)),
                              ),
                            ),
                          ],
                        ),
                      ).cornerRadiusWithClipRRectOnly(topLeft: 8, topRight: 8),
                      ListTile(
                        title: Text(locale.value.enhance, style: primaryTextStyle()),
                        subtitle: Text(locale.value.improveYourPictureQuality, style: secondaryTextStyle()),
                        dense: true,
                        trailing: GestureDetector(
                          onTap: () {
                            hideKeyboard(context);
                            onCameraTap?.call();
                          },
                          behavior: HitTestBehavior.translucent,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(shape: BoxShape.circle, color: appColorPrimary),
                            child: const Icon(Icons.double_arrow_sharp, color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
        10.height,
        Obx(() => FittedBox(
              child: Text(
                locale.value.noteYouCanUploadImageWithJpgPngWebpExtension,
                style: primaryTextStyle(size: 12, weight: FontWeight.w500, fontStyle: FontStyle.italic, color: isDarkMode.value ? deleteTextColor : redTextColor),
              ),
            ).visible(imgPath.value.isEmpty)),
      ],
    ).paddingSymmetric(horizontal: 16);
  }
}
