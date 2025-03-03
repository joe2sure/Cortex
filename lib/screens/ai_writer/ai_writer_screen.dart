import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/components/app_scaffold.dart';
import 'package:Cortex/components/loader_widget.dart';
import 'package:Cortex/screens/ai_writer/components/search_result_screen.dart';

import '../../main.dart';
import '../../utils/app_common.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/empty_error_state_widget.dart';
import '../home/components/template_component.dart';
import '../home/services/system_service_helper.dart';
import 'ai_writer_controller.dart';
import 'components/ai_writer_serach_bar.dart';
import 'content_generator.dart';

class AiWriterScreen extends StatelessWidget {
  final bool isFromBottomTab;

  AiWriterScreen({super.key, this.isFromBottomTab = false});
  final AiWriterController aiWriterController = Get.put(AiWriterController());

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBartitleText: getSystemServicebyKey(type: SystemServiceKeys.aiWriter).name.isNotEmpty ? getSystemServicebyKey(type: SystemServiceKeys.aiWriter).name : locale.value.aiWriter,
      hasLeadingWidget: !isFromBottomTab,
      isLoading: aiWriterController.isLoading,
      body: RefreshIndicator(
        color: appColorPrimary,
        onRefresh: () async {
          return await aiWriterController.getCategories(showLoader: false);
        },
        child: Obx(
          () => SnapHelperWidget(
            future: aiWriterController.getCategoryListFuture.value,
            initialData: aiWriterController.categoryListResponse.isEmpty ? null : aiWriterController.categoryListResponse,
            errorBuilder: (error) {
              return NoDataWidget(
                title: error,
                retryText: locale.value.reload,
                imageWidget: const ErrorStateWidget(),
                onRetry: () {
                  aiWriterController.getCategories();
                },
              ).paddingSymmetric(horizontal: 16);
            },
            loadingWidget: const Center(child: LoaderWidget()),
            onSuccess: (dashboardData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AiWriterSearchBarComponent(
                    aiWriterController: aiWriterController,
                    onClearButton: () {
                      aiWriterController.searchTemplate(showLoader: false);
                    },
                    onFieldSubmitted: (p0) {
                      hideKeyboard(context);
                    },
                  ).paddingSymmetric(horizontal: 16),
                  16.height,
                  Obx(
                    () => !aiWriterController.isSearching.value
                        ? aiWriterController.categoryListResponse.isEmpty
                            ? const Offstage()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Obx(
                                    () => Container(
                                      alignment: Alignment.center,
                                      width: Get.width,
                                      decoration: boxDecoration(
                                        borderRadius: radius(0),
                                        color: isDarkMode.value ? fullDarkCanvasColorDark : context.cardColor,
                                      ),
                                      child: SingleChildScrollView(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        controller: ScrollController(),
                                        clipBehavior: Clip.antiAlias,
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: List.generate(aiWriterController.categoryListResponse.length, (index) {
                                            return Container(
                                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                              decoration: boxDecoration(
                                                borderRadius: radius(defaultRadius - 4),
                                                color: aiWriterController.selectedCategory.value.id == aiWriterController.categoryListResponse[index].id
                                                    ? appColorPrimary
                                                    : isDarkMode.value
                                                        ? fullDarkCanvasColorDark
                                                        : context.cardColor,
                                              ),
                                              child: Text(
                                                aiWriterController.categoryListResponse[index].name,
                                                style: aiWriterController.selectedCategory.value.id == aiWriterController.categoryListResponse[index].id
                                                    ? primaryTextStyle(color: Colors.white)
                                                    : primaryTextStyle(color: isDarkMode.value ? Colors.white : primaryTextColor),
                                              ),
                                            ).onTap(() {
                                              aiWriterController.selectedCategory(aiWriterController.categoryListResponse[index]);
                                            });
                                          }),
                                        ),
                                      ),
                                    ).visible(aiWriterController.categoryListResponse.length > 1),
                                  ),
                                  12.height,
                                  Obx(
                                    () => aiWriterController.categoryListResponse.isEmpty
                                        ? const Offstage()
                                        : Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              aiWriterController.selectedCategory.value.type == "all"
                                                  ? aiWriterController.categoryListResponse.every((element) => element.customTemplate.isEmpty)
                                                      ? SizedBox(
                                                          height: Get.height * 0.5,
                                                          child: NoDataWidget(
                                                            title: locale.value.noTemplateFound,
                                                            subTitle: locale.value.noTemplateAtTheMoment,
                                                            titleTextStyle: primaryTextStyle(),
                                                            imageWidget: const EmptyStateWidget(),
                                                            retryText: locale.value.reload,
                                                            onRetry: () {
                                                              aiWriterController.getCategories();
                                                            },
                                                          ).paddingSymmetric(horizontal: 16),
                                                        )
                                                      : ListView.separated(
                                                          shrinkWrap: true,
                                                          padding: const EdgeInsets.only(bottom: 80),
                                                          separatorBuilder: (context, i) => aiWriterController.categoryListResponse[i].customTemplate.isEmpty ? const Offstage() : 16.height,
                                                          itemCount: aiWriterController.categoryListResponse.length,
                                                          itemBuilder: (BuildContext context, int i) {
                                                            return aiWriterController.categoryListResponse[i].customTemplate.isEmpty
                                                                ? const Offstage()
                                                                : Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Text(
                                                                        aiWriterController.categoryListResponse[i].name,
                                                                        style: primaryTextStyle(size: 18, color: isDarkMode.value ? Colors.white : primaryTextColor),
                                                                      ).paddingSymmetric(horizontal: 16),
                                                                      16.height,
                                                                      HorizontalList(
                                                                        itemCount: aiWriterController.categoryListResponse[i].customTemplate.length,
                                                                        padding: EdgeInsets.zero,
                                                                        itemBuilder: (context, j) {
                                                                          return TemplateComponent(
                                                                            isLoading: aiWriterController.isLoading,
                                                                            customTemplate: aiWriterController.categoryListResponse[i].customTemplate[j].obs,
                                                                            onTapCard: () {
                                                                              Get.to(() => ContentGenScreen(), arguments: aiWriterController.categoryListResponse[i].customTemplate[j]);
                                                                            },
                                                                          ).paddingOnly(
                                                                              right: j == aiWriterController.categoryListResponse[i].customTemplate.length - 1 ? 16 : 0, left: j == 0 ? 16 : 0);
                                                                        },
                                                                      ),
                                                                    ],
                                                                  );
                                                          },
                                                        ).expand()
                                                  : Obx(
                                                      () => aiWriterController.selectedCategory.value.customTemplate.isEmpty
                                                          ? SizedBox(
                                                              height: Get.height * 0.5,
                                                              child: NoDataWidget(
                                                                title: locale.value.noTemplateFound,
                                                                subTitle: locale.value.noTemplateAtTheMoment,
                                                                titleTextStyle: primaryTextStyle(),
                                                                imageWidget: const EmptyStateWidget(),
                                                                retryText: locale.value.reload,
                                                                onRetry: () {
                                                                  aiWriterController.getCategories();
                                                                },
                                                              ).paddingSymmetric(horizontal: 16),
                                                            )
                                                          : GridView.builder(
                                                              shrinkWrap: true,
                                                              padding: const EdgeInsets.only(bottom: 80),
                                                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                                crossAxisCount: 2,
                                                                mainAxisSpacing: 12,
                                                                crossAxisSpacing: 12,
                                                                childAspectRatio: 1,
                                                              ),
                                                              itemCount: aiWriterController.selectedCategory.value.customTemplate.length,
                                                              itemBuilder: (BuildContext context, int index) {
                                                                return TemplateComponent(
                                                                  isLoading: aiWriterController.isLoading,
                                                                  customTemplate: aiWriterController.selectedCategory.value.customTemplate[index].obs,
                                                                  onTapCard: () {
                                                                    Get.to(() => ContentGenScreen(), arguments: aiWriterController.selectedCategory.value.customTemplate[index]);
                                                                  },
                                                                );
                                                              },
                                                            ).paddingSymmetric(horizontal: 16).expand(),
                                                    ),
                                            ],
                                          ),
                                  ).expand()
                                ],
                              )
                        : SnapHelperWidget(
                            future: aiWriterController.getSearchResponseFuture.value,
                            onSuccess: (data) {
                              return SingleChildScrollView(child: SearchResultComponent(aiWriterController: aiWriterController).paddingBottom(20));
                            },
                          ),
                  ).expand(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
