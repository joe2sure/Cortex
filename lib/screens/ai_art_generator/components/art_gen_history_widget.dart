import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/components/app_dialog_widget.dart';
import 'package:Cortex/components/cached_image_widget.dart';

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
import '../art_gen_controller.dart';
import 'view_img_widget.dart';

class ArtGenHistoryWidget extends StatelessWidget {
  ArtGenHistoryWidget({super.key});

  final ArtGenController artGenController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
          () =>
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                    () =>
                    SnapHelperWidget(
                      future: artGenController.getHistoryResponseFuture.value,
                      errorBuilder: (error) {
                        return NoDataWidget(
                          title: error,
                          retryText: locale.value.reload,
                          imageWidget: const ErrorStateWidget(),
                          onRetry: () {
                            artGenController.getHistoryList();
                          },
                        ).paddingSymmetric(horizontal: 32);
                      },
                      loadingWidget: artGenController.isLoading.value ? const Offstage() : const LoaderWidget(),
                      onSuccess: (historyRes) {
                        bool isHistoryImageAvailable = false;
                        for (var element in artGenController.historyResponse.value.data) {
                          if (element.histroyImage.isNotEmpty && element.histroyImage.first.isNotEmpty) {
                            isHistoryImageAvailable = true;
                            break;
                          }
                        }

                        return Obx(() =>
                        artGenController.historyResponse.value.data.isEmpty
                            ? const Offstage()
                            : Column(
                          children: [
                            if(isHistoryImageAvailable)
                              ViewAllLabel(
                                label: locale.value.yourGeneratedArts,
                                trailingText: locale.value.clearAll,
                                onTap: () {
                                  showAppDialog(
                                    context,
                                    buttonColor: appColorPrimary,
                                    negativeText: locale.value.cancel,
                                    positiveText: locale.value.delete,
                                    onConfirm: () {
                                      /// Clear History Api
                                      artGenController.clearUserHistory(serviceType: SystemServiceKeys.aiArtGenerator);
                                    },
                                    dialogType: AppDialogType.delete,
                                    dialogText: locale.value.doYouReallyWantToClearAllHistory,
                                    titleText: locale.value.clearHistory,
                                  );
                                },
                              ).paddingOnly(right: 8),
                            GridView.builder(
                              itemCount: artGenController.historyResponse.value.data
                                  .where((element) => element.histroyImage.isNotEmpty)
                                  .length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
                              itemBuilder: (context, index) {
                                HistoryElement historyElementData = artGenController.historyResponse.value.data
                                    .where((element) => element.histroyImage.isNotEmpty)
                                    .toList()[index];
                                return Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            if (historyElementData.histroyImage.isNotEmpty) {
                                              artGenController.selectedHistoryElement(artGenController.historyResponse.value.data[index]);
                                              Get.to(
                                                () => ViewArtImg(),
                                                duration: const Duration(milliseconds: 500),
                                              );
                                            }
                                          },
                                          child: Hero(
                                            tag: "#${historyElementData.histroyImage.isNotEmpty ? historyElementData.histroyImage.first : currentMillisecondsTimeStamp()}",
                                            child: CachedImageWidget(
                                              url: historyElementData.histroyImage.isNotEmpty ? historyElementData.histroyImage.first : "",
                                              radius: 8,
                                              fit: BoxFit.cover,
                                              height: Get.height,
                                              width: Get.width,
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
                                                artGenController.isLoading(true);
                                                if (historyElementData.histroyImage.isNotEmpty) {
                                                  final isShareDone = await downloadAndShareFile(
                                                    fileName: historyElementData.histroyImage.first.toLowerCase().contains(".jpg")
                                                        ? "${currentMillisecondsTimeStamp()}.jpg"
                                                        : historyElementData.histroyImage.first.toLowerCase().contains(".webp")
                                                        ? "${currentMillisecondsTimeStamp()}.webp"
                                                        : "${currentMillisecondsTimeStamp()}.png",
                                                    uri: Uri.parse(historyElementData.histroyImage.first),
                                                  );
                                                  artGenController.isLoading(false);
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
                                                  buttonColor: appColorPrimary,
                                                  context,
                                                  negativeText: locale.value.cancel,
                                                  positiveText: locale.value.delete,
                                                  dialogType: AppDialogType.delete,
                                                  dialogText: locale.value.doYouReallyWantToDeleteThisFromYourHistory,
                                                  titleText: locale.value.clearHistory,
                                                  onConfirm: () {
                                                    /// Clear History Api
                                                    artGenController.clearUserHistory(historyId: historyElementData.id);
                                                  },
                                                );
                                              }),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                        );
                      },
                    ),
              ),
            ],
          ).paddingBottom(32).paddingSymmetric(horizontal: 16).visible(artGenController.historyResponse.value.data.isNotEmpty),
    );
  }
}
