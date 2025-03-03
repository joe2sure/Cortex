import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/components/app_dialog_widget.dart';
import 'package:Cortex/screens/ai_voice_to_text/v2t_gen_controller.dart';

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
import '../model/v2t_hist_element.dart';
import '../v2t_result_screen.dart';

class V2THistoryWidget extends StatelessWidget {
  V2THistoryWidget({super.key});

  final V2TController v2TController = Get.find();

  final RxBool showCopied = false.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SnapHelperWidget(
        future: v2TController.getHistoryResponseFuture.value,
        errorBuilder: (error) {
          return NoDataWidget(
            title: error,
            retryText: locale.value.reload,
            imageWidget: const ErrorStateWidget(),
            onRetry: () {
              v2TController.getHistoryList();
            },
          ).paddingSymmetric(horizontal: 32);
        },
        loadingWidget: v2TController.isLoading.value ? const Offstage() : const LoaderWidget(),
        onSuccess: (historyRes) {
          return Obx(
            () => v2TController.historyResponse.value.data.isEmpty
                ? const Offstage()
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        16.height,
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
                                v2TController.clearUserHistory(serviceType: SystemServiceKeys.aiCode);
                              },
                            );
                          },
                        ).paddingOnly(right: 8),
                        AnimatedListView(
                          shrinkWrap: true,
                          listAnimationType: ListAnimationType.None,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: v2TController.historyResponse.value.data.length,
                          itemBuilder: (context, index) {
                            HistoryElement historyElementData = v2TController.historyResponse.value.data[index];
                            V2THistElement v2THistElement = historyElementData.historyData.responseBody is Map
                                ? V2THistElement.fromJson(historyElementData.historyData.responseBody)
                                : V2THistElement(content: historyElementData.historyData.responseBody.toString().obs, title: "".obs);

                            return GestureDetector(
                              onTap: () {
                                v2TController.currentContent(v2THistElement);
                                Get.to(() => V2TResultScreen(), duration: const Duration(milliseconds: 500));
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
                                          if (v2THistElement.title.value.isNotEmpty.obs.value) ...[
                                            Text(
                                              v2THistElement.title.value,
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
                                            tag: v2THistElement.content.value.formattedHeroTag,
                                            child: Text(
                                              v2THistElement.content.value,
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
                                            v2THistElement.content.value.copyToClipboard().then((value) {
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
                                                v2TController.clearUserHistory(historyId: historyElementData.id);
                                              },
                                              dialogType: AppDialogType.delete,
                                              dialogText: locale.value.doYouReallyWantToDeleteThisFromYourHistory,
                                              titleText: locale.value.clearHistory,
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
                          },
                        ),
                      ],
                    ),
                  ),
          );
        },
      ).paddingBottom(32).paddingSymmetric(horizontal: 16).visible(v2TController.historyResponse.value.data.isNotEmpty),
    );
  }
}
