import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/components/loader_widget.dart';
import 'package:Cortex/utils/app_common.dart';
import '../main.dart';
import '../models/report_flag_model.dart';
import '../screens/home/services/history_api_service.dart';
import '../utils/colors.dart';
import '../utils/common_base.dart';
import '../utils/view_all_label_component.dart';

class ReportAndFlagListBottomSheet extends StatelessWidget {
  final List<ReportFlagElement> reasons;
  final String systemService;
  final String historyId;

  ReportAndFlagListBottomSheet({
    super.key,
    required this.reasons,
    required this.systemService,
    required this.historyId,
  });
  final TextEditingController moreDetailCont = TextEditingController();
  final Rx<ReportFlagElement> selectedReason = ReportFlagElement().obs; // Track the selected reason
  final RxBool isLoading = false.obs; // Track the selected reason

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.94,
      width: Get.width,
      decoration: boxDecorationDefault(color: context.cardColor),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ViewAllLabel(label: "Report", isShowAll: false).paddingOnly(left: 16, right: 8).flexible(),
                    appCloseIconButton(context, onPressed: () {
                      Get.back();
                    }),
                  ],
                ),
                commonDivider,
                8.height,
                AnimatedListView(
                  itemCount: reasons.length,
                  padding: const EdgeInsets.all(8),
                  shrinkWrap: true,
                  listAnimationType: ListAnimationType.FadeIn,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (_, index) {
                    ReportFlagElement data = reasons[index];

                    return Obx(
                      () => RadioListTile<ReportFlagElement>(
                        contentPadding: EdgeInsets.zero,
                        value: data,
                        groupValue: selectedReason.value,
                        title: Text(
                          data.reason,
                          style: secondaryTextStyle(color: textPrimaryColorGlobal),
                        ),
                        onChanged: (ReportFlagElement? value) {
                          if (value != null) {
                            selectedReason(value);
                          }
                        },
                      ),
                    );
                  },
                ),
                ViewAllLabel(label: "Want to tell us more? It's optional", isShowAll: false).paddingOnly(left: 16, right: 8),
                Text(
                  "Sharing a few details can help us understand the issue. Please don't include personal info or questions.",
                  style: secondaryTextStyle(size: 11),
                ).paddingSymmetric(horizontal: 16),
                16.height,
                AppTextField(
                  textFieldType: TextFieldType.MULTILINE,
                  controller: moreDetailCont,
                  minLines: 6,
                  cursorColor: appColorPrimary,
                  decoration: inputDecoration(
                    context,
                    labelText: "Add details...",
                    borderRadius: 4,
                    fillColor: isDarkMode.value ? fullDarkCanvasColorDark : Colors.grey.shade100,
                    filled: true,
                  ),
                ).paddingSymmetric(horizontal: 16),
                Obx(
                  () => selectedReason.value.id.isNegative
                      ? 64.height
                      : AppButton(
                          width: Get.width,
                          text: locale.value.submit,
                          textStyle: appButtonTextStyleWhite,
                          onTap: () async {
                            final req = {
                              "user_id": loginUserData.value.id,
                              "history_id": historyId,
                              "tool_type": systemService,
                              "reason": selectedReason.value.reason,
                              "more_detail": moreDetailCont.text.trim(),
                            };
                            await HistoryServiceApis.saveReportOrFlag(request: req).then((res) {
                              log("saveReportOrFlag res ${res.message}");
                            }).catchError((e) {
                              log("saveReportOrFlag err $e");
                            }).whenComplete(() {
                              Get.back();
                              isLoading(false);
                            });
                          },
                        ).paddingSymmetric(horizontal: 16, vertical: 32),
                ),
              ],
            ),
            Obx(() => isLoading.isTrue ? LoaderWidget(isBlurBackground: true) : Offstage())
          ],
        ),
      ),
    );
  }
}
