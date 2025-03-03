import 'package:before_after/before_after.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/components/app_scaffold.dart';
import 'package:Cortex/components/cached_image_widget.dart';

import '../../../components/report_flag_bottom_sheet.dart';
import '../../../generated/assets.dart';
import '../../../main.dart';
import '../../../models/upload_image_model.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import '../../../utils/constants.dart';
import '../../home/model/history_data_model.dart';
import '../ai_image_controller.dart';

class ViewEnhancedImgComponent extends StatelessWidget {
  final HistoryElement historyElement;

  ViewEnhancedImgComponent({super.key, required this.historyElement});

  final AiImageController photoEnhancerController = Get.find();

  final RxBool showDetailsAndBtns = true.obs;
  final RxBool showCopied = false.obs;

  UploadImageModel get imgGenDetail => UploadImageModel.fromJson(historyElement.historyData.requestBody is Map ? historyElement.historyData.requestBody : {});

  String get uploadImgUrl => imgGenDetail.uploadImage.isNotEmpty ? imgGenDetail.uploadImage.first : "";

  RxString get imgUrl => (historyElement.histroyImage.isNotEmpty ? historyElement.histroyImage.first : "").obs;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBartitleText: locale.value.enhancePhoto,
      isCenterTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            doIfLoggedIn(() {
              Get.bottomSheet(
                ReportAndFlagListBottomSheet(
                  reasons: reportReasons,
                  historyId: historyElement.id.toString(),
                  systemService: SystemServiceKeys.aiImage,
                ),
                isScrollControlled: true,
              );
            });
          },
          icon: const Icon(
            Icons.flag_outlined,
            color: bodyWhite,
            size: 28,
          ),
        ),
      ],
      body: Column(
        children: [
          Obx(
            () => BeforeAfter(
              value: photoEnhancerController.sliderPosition.value,
              trackColor: Colors.white,
              trackWidth: 2.5,
              width: Get.width - 32,
              thumbDecoration: BoxDecoration(
                color: Colors.white,
                borderRadius: radius(defaultRadius),
                image: const DecorationImage(image: AssetImage(Assets.iconsIcLeftRightArrow)),
              ),
              before: Stack(
                fit: StackFit.expand,
                children: [
                  CachedImageWidget(url: uploadImgUrl, fit: BoxFit.cover),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: boxDecorationDefault(color: appColorSecondary, borderRadius: radius(8)),
                      child: Text(locale.value.before, style: primaryTextStyle(color: black)),
                    ),
                  ),
                ],
              ),
              after: Stack(
                fit: StackFit.expand,
                children: [
                  CachedImageWidget(url: imgUrl.value, fit: BoxFit.cover),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: boxDecorationDefault(color: Colors.white, borderRadius: radius(8)),
                      child: Text(locale.value.after, style: primaryTextStyle(color: black)),
                    ),
                  ),
                ],
              ),
              onValueChanged: (value) {
                photoEnhancerController.sliderPosition(value);
              },
            ).cornerRadiusWithClipRRect(defaultRadius),
          ).paddingSymmetric(horizontal: 16).expand(),
          16.height,
          Obx(
            () => Row(
              children: [
                AppButton(
                  height: 32,
                  width: Get.width / 3,
                  elevation: 0,
                  color: appColorPrimary,
                  onTap: () async {
                    final isShareDone = await downloadAndShareFile(
                      fileName: imgUrl.toLowerCase().contains(".jpg")
                          ? "${currentMillisecondsTimeStamp()}.jpg"
                          : imgUrl.toLowerCase().contains(".webp")
                              ? "${currentMillisecondsTimeStamp()}.webp"
                              : "${currentMillisecondsTimeStamp()}.png",
                      uri: Uri.parse(imgUrl.value),
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
                ).expand(),
              ],
            ).paddingSymmetric(horizontal: 16).visible(showDetailsAndBtns.value),
          ),
          16.height,
        ],
      ),
    );
  }
}
