import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/components/app_dialog_widget.dart';

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
import '../content_gen_controller.dart';
import '../content_gen_result_screen.dart';
import '../model/content_hist_element.dart';

class ContentHistoryWidget extends StatelessWidget {
  ContentHistoryWidget({super.key});

  final ContentGenController contentGenController = Get.find();

  final RxBool showCopied = false.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SnapHelperWidget(
        future: contentGenController.getHistoryResponseFuture.value,
        errorBuilder: (error) {
          return NoDataWidget(
            title: error,
            retryText: locale.value.reload,
            imageWidget: const ErrorStateWidget(),
            onRetry: () {
              contentGenController.getHistoryList();
            },
          ).paddingSymmetric(horizontal: 32);
        },
        loadingWidget: contentGenController.isLoading.value ? const Offstage() : const LoaderWidget(),
        onSuccess: (historyRes) {


          return Obx(
            () => contentGenController.historyResponse.value.data.isEmpty
                ? const Offstage()
                : Column(
                    children: [
                      ViewAllLabel(
                        label: locale.value.yourGeneratedContent,
                        trailingText: locale.value.clearAll,
                        onTap: () {
                          showAppDialog(
                            buttonColor: appColorPrimary,
                            context,
                            negativeText: locale.value.cancel,
                            positiveText: locale.value.delete,
                            dialogType: AppDialogType.delete,
                            dialogText: locale.value.doYouReallyWantToClearAllHistory,
                            titleText: locale.value.clearHistory,
                            onConfirm: () {
                              /// Clear History Api
                              contentGenController.clearUserHistory(serviceType: SystemServiceKeys.aiWriter);
                            },
                          );
                        },
                      ).paddingOnly(right: 8),
                      AnimatedListView(
                        shrinkWrap: true,
                        listAnimationType: ListAnimationType.None,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: contentGenController.historyResponse.value.data.length,
                        itemBuilder: (context, index) {
                          HistoryElement historyElementData = contentGenController.historyResponse.value.data[index];
                          ContentHistElement contentHistElement = historyElementData.historyData.responseBody is Map
                              ? ContentHistElement.fromJson(historyElementData.historyData.responseBody)
                              : ContentHistElement(content: historyElementData.historyData.responseBody.toString().obs, title: "".obs);

                          var gestureDetector = GestureDetector(
                            onTap: () {
                              contentGenController.currentContent(contentHistElement);
                              Get.to(() => GenerateResultScreen(), duration: const Duration(milliseconds: 500));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: boxDecorationWithRoundedCorners(backgroundColor: isDarkMode.value ? fullDarkCanvasColorDark : appSectionBackground, borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Obx(
                                    () => Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (contentHistElement.title.value.isNotEmpty.obs.value) ...[
                                          Text(
                                            contentHistElement.title.value,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: secondaryTextStyle(
                                              color: appColorPrimary,
                                              fontStyle: FontStyle.italic,
                                              fontFamily: GoogleFonts.instrumentSans(fontWeight: FontWeight.w600).fontFamily,
                                            ),
                                          ),
                                          4.height
                                        ],
                                        Hero(
                                          tag: contentHistElement.content.value.formattedHeroTag,
                                          child: Text(
                                            contentHistElement.content.value,
                                            style: primaryTextStyle(decoration: TextDecoration.none),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ).expand(),
                                  ),
                                  8.width,
                                  Row(
                                    children: [
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        visualDensity: VisualDensity.compact,
                                        onPressed: () {
                                          contentHistElement.content.value.copyToClipboard().then((value) {
                                            showCopied(true);
                                            Future.delayed(const Duration(milliseconds: 800), () {
                                              showCopied(false);
                                            });
                                          });
                                        },
                                        icon: Obx(
                                          () => showCopied.value
                                              ? Text(
                                                  locale.value.copied,
                                                  style: secondaryTextStyle(size: 10, color: appColorPrimary),
                                                )
                                              : commonLeadingWid(imgPath: Assets.iconsIcCopy, size: 20),
                                        ),
                                      ),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        visualDensity: VisualDensity.compact,
                                        onPressed: () {
                                          showAppDialog(
                                            context,
                                            buttonColor: appColorPrimary,
                                            negativeText: locale.value.cancel,
                                            positiveText: locale.value.delete,
                                            onConfirm: () {
                                              /// Clear History Api
                                              contentGenController.clearUserHistory(historyId: historyElementData.id);
                                            },
                                            dialogType: AppDialogType.delete,
                                            dialogText: locale.value.doYouReallyWantToDeleteThisFromYourHistory,
                                            titleText: locale.value.deleteHistory,
                                          );
                                        },
                                        icon: commonLeadingWid(imgPath: Assets.iconsIcDelete, color: deleteTextColor, size: 20),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ).paddingSymmetric(vertical: 8),
                          );
                          return gestureDetector.visible(contentHistElement.content.isNotEmpty);
                        },
                      ),
                    ],
                  ),
          );
        },
      ).paddingBottom(32).paddingSymmetric(horizontal: 16),
    );
  }
}
