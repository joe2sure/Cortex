import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/generated/assets.dart';
import 'package:Cortex/main.dart';
import 'package:Cortex/screens/ai_image/component/photo_enhancer_history_widget.dart';
import 'package:Cortex/utils/common_base.dart';

import '../../components/app_scaffold.dart';
import '../../components/title_with_icon_widget.dart';
import '../../utils/app_common.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../home/services/system_service_helper.dart';
import 'ai_image_controller.dart';
import 'component/select_image_enchance.dart';

class AiImageScreen extends StatelessWidget {
  AiImageScreen({super.key});

  final AiImageController aiImageController = Get.put(AiImageController());

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBartitleText: getSystemServicebyKey(type: SystemServiceKeys.aiImage).name.isNotEmpty ? getSystemServicebyKey(type: SystemServiceKeys.aiImage).name : locale.value.aiImage,
      isLoading: aiImageController.isLoading,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(
              () => SelectImageForEnhance(
                imgPath: aiImageController.pickedImage.value.path.obs,
                showSparkleLoader: aiImageController.showSparkleLoader,
                onCameraTap: () {
                  aiImageController.showBottomSheet(context);
                },
              ),
            ),
            16.height,
            Obx(
              () => AppButton(
                height: 32,
                width: Get.width / 3,
                elevation: 0,
                color: appColorPrimary,
                onTap: () {
                  aiImageController.showBottomSheet(context);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.change_circle_outlined,
                      color: white,
                    ),
                    8.width,
                    Text(locale.value.change, style: boldTextStyle(size: 14, weight: FontWeight.w500, color: white)),
                  ],
                ),
              ).visible(aiImageController.pickedImage.value.path.isNotEmpty),
            ),
            Obx(
              () => Column(
                children: [
                  24.height,
                  Divider(
                    indent: 3,
                    height: 1,
                    thickness: 1.5,
                    color: isDarkMode.value ? borderColor.withOpacity(0.1) : borderColor.withOpacity(0.5),
                  ),
                  24.height,
                  SelectImageForEnhance(
                    imgPath: aiImageController.generatedImage,
                    showSparkleLoader: aiImageController.isLoading,
                  ),
                ],
              ).visible(aiImageController.generatedImage.isNotEmpty),
            ),
            Obx(
              () => Column(
                children: [
                  16.height,
                  AppButton(
                    height: 32,
                    width: Get.width / 3,
                    elevation: 0,
                    color: appColorPrimary,
                    onTap: () async {
                      final isShareDone = await downloadAndShareFile(
                        fileName: aiImageController.generatedImage.value.toLowerCase().contains(".jpg")
                            ? "${currentMillisecondsTimeStamp()}.jpg"
                            : aiImageController.generatedImage.value.toLowerCase().contains(".webp")
                                ? "${currentMillisecondsTimeStamp()}.webp"
                                : "${currentMillisecondsTimeStamp()}.png",
                        uri: Uri.parse(aiImageController.generatedImage.value),
                      );
                      log('ISSHAREDONE: $isShareDone');
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.share_outlined, color: white),
                        8.width,
                        Text(locale.value.share, style: boldTextStyle(size: 14, weight: FontWeight.w500, color: white)),
                      ],
                    ),
                  ).visible(aiImageController.generatedImage.isNotEmpty),
                ],
              ),
            ),
            Obx(
              () => Column(
                children: [
                  16.height,
                  AppButton(
                    height: 52,
                    width: Get.width,
                    elevation: 0,
                    color: appColorSecondary,
                    onTap: () {
                      aiImageController.handleFaceEnhancerClick();
                    },
                    child: TitleWithIconWidget(
                      iconPath: isPremiumUser.value ? "" : Assets.iconsIcVideo,
                      title: isPremiumUser.value ? locale.value.enhanceImage : locale.value.watchAnAdToEnhanceImage,
                      iconColor: canvasColor,
                      textColor: canvasColor,
                    ),
                  ).paddingSymmetric(horizontal: 20, vertical: 16),
                ],
              ).visible(aiImageController.pickedImage.value.path.isNotEmpty),
            ),
            PhotoEnhancerHistoryWidget(),
          ],
        ),
      ),
    );
  }
}
