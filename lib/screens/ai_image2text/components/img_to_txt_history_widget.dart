import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/components/app_dialog_widget.dart';
import 'package:Cortex/screens/ai_image2text/ai_img_to_txt_controller.dart';
import 'package:Cortex/screens/ai_image2text/model/tags_desc_response.dart';

import '../../../components/loader_widget.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants.dart';
import '../../../utils/empty_error_state_widget.dart';
import '../../../utils/view_all_label_component.dart';
import '../../home/model/history_data_model.dart';
import 'img_to_txt_hist_comp.dart';

class ImgToTxtHistoryWidget extends StatelessWidget {
  ImgToTxtHistoryWidget({super.key});

  final AiImgToTxtController aiImgToTxtController = Get.find();

  final RxBool showCopied = false.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => SnapHelperWidget(
              future: aiImgToTxtController.getHistoryResponseFuture.value,
              errorBuilder: (error) {
                return NoDataWidget(
                  title: error,
                  retryText: locale.value.reload,
                  imageWidget: const ErrorStateWidget(),
                  onRetry: () {
                    aiImgToTxtController.getHistoryList();
                  },
                ).paddingSymmetric(horizontal: 32);
              },
              loadingWidget: aiImgToTxtController.isLoading.value ? const Offstage() : const LoaderWidget(),
              onSuccess: (historyRes) {
                bool isHistoryImageAvailable = false;
                for (var element in aiImgToTxtController.historyResponse.value.data) {
                  if(TagsAndDesCustomResponse.fromJson(element.historyData.responseBody).imageName.isNotEmpty)
              {
                    isHistoryImageAvailable = true;
                    break;
                  }
                }
                return Obx(
                  () => aiImgToTxtController.historyResponse.value.data.isEmpty
                      ? const Offstage()
                      : Column(
                          children: [
                            if(isHistoryImageAvailable)
                            ViewAllLabel(
                              label: locale.value.yourGeneratedContent,
                              trailingText: locale.value.clearAll,
                              onTap: () {
                                showAppDialog(
                                  buttonColor: appColorPrimary,
                                  context,
                                  negativeText: locale.value.cancel,
                                  positiveText: locale.value.delete,
                                  onConfirm: () {
                                    /// Clear History Api
                                    aiImgToTxtController.clearUserHistory(serviceType: SystemServiceKeys.aiImageToText);
                                  },
                                  dialogType: AppDialogType.delete,
                                  dialogText: locale.value.doYouReallyWantToClearAllHistory,
                                  titleText: locale.value.clearHistory,
                                );
                              },
                            ).paddingOnly(right: 8),
                            AnimatedListView(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: aiImgToTxtController.historyResponse.value.data.length,
                              itemBuilder: (context, index) {
                                HistoryElement historyElementData = aiImgToTxtController.historyResponse.value.data[index];
                                TagsAndDesCustomResponse res = TagsAndDesCustomResponse.fromJson(historyElementData.historyData.responseBody);

                                return ImgToTxtHistComp(tAndDResponse: res, historyElementData: historyElementData).visible(res.imageName.isNotEmpty);
                              },
                            ),
                          ],
                        ),
                );
              },
            ),
          )
        ],
      ).paddingBottom(32).paddingSymmetric(horizontal: 16).visible(aiImgToTxtController.historyResponse.value.data.isNotEmpty),
    );
  }
}
