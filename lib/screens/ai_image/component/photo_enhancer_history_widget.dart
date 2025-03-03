import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/components/app_dialog_widget.dart';
import 'package:Cortex/screens/ai_image/ai_image_controller.dart';

import '../../../components/cached_image_widget.dart';
import '../../../components/loader_widget.dart';
import '../../../generated/assets.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import '../../../utils/constants.dart';
import '../../../utils/empty_error_state_widget.dart';
import '../../../utils/view_all_label_component.dart';
import '../../home/model/history_data_model.dart';
import 'view_enhanced_img_component.dart';

class PhotoEnhancerHistoryWidget extends StatelessWidget {
  PhotoEnhancerHistoryWidget({super.key});

  final AiImageController photoEnhancerController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => SnapHelperWidget(
              future: photoEnhancerController.getHistoryResponseFuture.value,
              errorBuilder: (error) {
                return NoDataWidget(
                  title: error,
                  retryText: locale.value.reload,
                  imageWidget: const ErrorStateWidget(),
                  onRetry: () {
                    photoEnhancerController.getHistoryList();
                  },
                ).paddingSymmetric(horizontal: 32);
              },
              loadingWidget: photoEnhancerController.isLoading.value ? const Offstage() : const LoaderWidget(),
              onSuccess: (data) {
                bool isHistoryImageAvailable = false;
                for (var element in photoEnhancerController.historyResponse.value.data) {
                  if (element.histroyImage.isNotEmpty && element.histroyImage.first.isNotEmpty) {
                    isHistoryImageAvailable = true;
                    break;
                  }
                }

                return Obx(
                  () => photoEnhancerController.historyResponse.value.data.isEmpty
                      ? const Offstage()
                      : Column(
                          children: [
                            if(isHistoryImageAvailable)
                            ViewAllLabel(
                              label: locale.value.yourGeneratedEnhancedPhotos,
                              trailingText: locale.value.clearAll,
                              onTap: () {
                                showAppDialog(
                                  context,
                                  buttonColor: appColorPrimary,
                                  negativeText: locale.value.cancel,
                                  positiveText: locale.value.delete,
                                  onConfirm: () {
                                    /// Clear History Api
                                    photoEnhancerController.clearUserHistory(serviceType: SystemServiceKeys.aiImage);
                                  },
                                  dialogType: AppDialogType.delete,
                                  dialogText: locale.value.doYouReallyWantToClearAllHistory,
                                  titleText: locale.value.clearHistory,
                                );
                              },
                            ).paddingOnly(right: 8),
                            GridView.builder(
                              itemCount: photoEnhancerController.historyResponse.value.data.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
                              itemBuilder: (context, index) {
                                HistoryElement historyElementData = photoEnhancerController.historyResponse.value.data[index];

                                return Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    SpinKitFadingCircle(
                                      size: 50,
                                      itemBuilder: (BuildContext context, int index) {
                                        return const DecoratedBox(decoration: BoxDecoration(shape: BoxShape.circle, color: appColorPrimary));
                                      },
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (historyElementData.histroyImage.isNotEmpty) {
                                          photoEnhancerController.sliderPosition.value = 0.5;
                                          Get.to(
                                            () => ViewEnhancedImgComponent(historyElement: historyElementData),
                                            duration: const Duration(milliseconds: 500),
                                          );
                                        }
                                      },
                                      child: Hero(
                                        tag: "#${historyElementData.histroyImage.isNotEmpty ? historyElementData.histroyImage.first : currentMillisecondsTimeStamp()}",
                                        child: CachedImageWidget(
                                          url: historyElementData.histroyImage.isNotEmpty ? historyElementData.histroyImage.first : "",
                                          usePlaceholderIfUrlEmpty: false,
                                          radius: 8,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: boxDecorationDefault(color: borderColor.withOpacity(0.8), borderRadius: const BorderRadius.all(Radius.circular(16))),
                                            child: commonLeadingWid(imgPath: Assets.iconsIcShare, color: appColorPrimary, size: 24),
                                          ).onTap(() async {
                                            if (historyElementData.histroyImage.isNotEmpty) {
                                              final isShareDone = await downloadAndShareFile(
                                                fileName: historyElementData.histroyImage.first.toLowerCase().contains(".jpg")
                                                    ? "${currentMillisecondsTimeStamp()}.jpg"
                                                    : historyElementData.histroyImage.first.toLowerCase().contains(".webp")
                                                        ? "${currentMillisecondsTimeStamp()}.webp"
                                                        : "${currentMillisecondsTimeStamp()}.png",
                                                uri: Uri.parse(historyElementData.histroyImage.first),
                                              );
                                              log('ISSHAREDONE: $isShareDone');
                                            }
                                          }),
                                          6.width,
                                          Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: boxDecorationDefault(color: borderColor.withOpacity(0.8), borderRadius: const BorderRadius.all(Radius.circular(16))),
                                            child: commonLeadingWid(imgPath: Assets.iconsIcDelete, color: deleteTextColor, size: 24),
                                          ).onTap(() {
                                            showAppDialog(
                                              context,
                                              buttonColor: appColorPrimary,
                                              negativeText: locale.value.cancel,
                                              positiveText: locale.value.delete,
                                              onConfirm: () {
                                                /// Clear History Api
                                                photoEnhancerController.clearUserHistory(historyId: historyElementData.id);
                                              },
                                              dialogType: AppDialogType.delete,
                                              dialogText: locale.value.doYouReallyWantToDeleteThisFromYourHistory,
                                              titleText: locale.value.clearHistory,
                                            );
                                          }),
                                        ],
                                      ),
                                    ),
                                  ],
                                ).visible(historyElementData.histroyImage.isNotEmpty);
                              },
                            ),
                          ],
                        ),
                );
              },
            ),
          )
        ],
      ).paddingBottom(32).paddingSymmetric(horizontal: 16).visible(photoEnhancerController.historyResponse.value.data.isNotEmpty),
    );
  }
}
