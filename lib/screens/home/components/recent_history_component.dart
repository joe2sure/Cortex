import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/components/app_dialog_widget.dart';
import 'package:Cortex/utils/common_base.dart';

import '../../../components/cached_image_widget.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants.dart';
import '../../../utils/view_all_label_component.dart';
import '../home_controller.dart';
import '../model/home_detail_res.dart';
import '../services/system_service_helper.dart';

class RecentHistoryComponent extends StatelessWidget {
  const RecentHistoryComponent({super.key, required this.homeController});

  final HomeController homeController;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => homeController.dashboardData.value.recentHistory.isEmpty
          ? const Offstage()
          : Container(
              width: Get.width,
              decoration: boxDecorationWithRoundedCorners(
                backgroundColor: isDarkMode.value ? fullDarkCanvasColorDark : appSectionBackground,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  24.height,
                  ViewAllLabel(
                    label: locale.value.yourRecentHistory,
                    trailingText: locale.value.clearAll,
                    labelSize: 18,
                    onTap: () {
                      showAppDialog(
                        context,
                        negativeText: locale.value.cancel,
                        positiveText: locale.value.delete,
                        onConfirm: () {
                          /// Clear History Api
                          homeController.clearUserHistory(type: SystemServiceKeys.all);
                        },
                        dialogType: AppDialogType.delete,
                        dialogText: locale.value.doYouReallyWantToClearAllHistory,
                        titleText: locale.value.clearHistory,
                      );
                    },
                  ).paddingOnly(left: 16, right: 8, bottom: 4),
                  SizedBox(
                    height: Get.height * 0.12,
                    width: Get.width,
                    child: PageView(
                      controller: homeController.pageController,
                      onPageChanged: (page) {
                        homeController.currentHistoryPage(page);
                      },
                      children: List.generate(homeController.dashboardData.value.recentHistory.length, (index) {
                        RecentHistory recentHistoryData = homeController.dashboardData.value.recentHistory[index];

                        return GestureDetector(
                          onTap: () {
                            /// Navigate to System Service
                            navigateToService(serviceType: recentHistoryData.systemService.type);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            margin: const EdgeInsets.only(left: 16, right: 16),
                            decoration: boxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: isDarkMode.value ? appScreenBackgroundDark : appScreenGreyBackground,
                            ),
                            child: Stack(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle, backgroundColor: appColorPrimary),
                                      child: CachedImageWidget(
                                        url: recentHistoryData.systemService.serviceImage.isNotEmpty ? recentHistoryData.systemService.serviceImage : "",
                                        circle: true,
                                        radius: 26,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    18.width,
                                    Text(
                                      recentHistoryData.systemService.name,
                                      style: primaryTextStyle(color: isDarkMode.value ? whiteTextColor : canvasColor, size: 18, weight: FontWeight.w500),
                                    ),
                                  ],
                                ).paddingAll(20),
                                Positioned(
                                  top: 10,
                                  right: 16,
                                  child: Marquee(
                                    child: Text(recentHistoryData.createdAt.dateInddMMMyyyyHHmmAmPmFormat, style: secondaryTextStyle()),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ).paddingBottom(30),
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        homeController.dashboardData.value.recentHistory.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          height: 6,
                          width: homeController.currentHistoryPage.value == index ? 22 : 6,
                          decoration: boxDecorationWithRoundedCorners(backgroundColor: homeController.currentHistoryPage.value == index ? appColorPrimary : appColorPrimary.withOpacity(0.5)),
                        ).paddingAll(2),
                      ),
                    ).center(),
                  ),
                  30.height,
                ],
              ),
            ).paddingOnly(left: 16, right: 16),
    );
  }
}
