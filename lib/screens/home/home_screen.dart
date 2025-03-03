import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/components/app_scaffold.dart';
import 'package:Cortex/components/loader_widget.dart';
import 'package:Cortex/screens/home/components/home_templates_component.dart';

import '../../main.dart';
import '../../utils/app_common.dart';
import '../../utils/colors.dart';
import '../../utils/empty_error_state_widget.dart';
import 'components/recent_history_component.dart';
import 'components/system_service_component.dart';
import 'components/welcome_widget.dart';
import 'home_controller.dart';
import 'model/home_detail_res.dart';
import 'services/system_service_helper.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppScaffold(
        hideAppBar: true,
        isLoading: homeController.isLoading,
        body: RefreshIndicator(
          color: appColorPrimary,
          onRefresh: () async {
            return await homeController.getDashboardDetail(showLoader: false, forceSync: true);
          },
          child: Obx(
            () => SnapHelperWidget(
              future: homeController.getDashboardDetailFuture.value,
              initialData: homeController.dashboardData.value.systemService.isEmpty ? null : HomeData().obs,
              errorBuilder: (error) {
                return NoDataWidget(
                  title: error,
                  retryText: locale.value.reload,
                  imageWidget: const ErrorStateWidget(),
                  onRetry: () {
                    homeController.getDashboardDetail();
                  },
                ).paddingSymmetric(horizontal: 16).visible(!homeController.isLoading.value);
              },
              loadingWidget: const Center(child: LoaderWidget()),
              onSuccess: (dashboardData) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 16),
                  physics: const AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WelcomeWidget(homeController: homeController, textSize: 22),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          32.height,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() => SystemServicesComponent(homeController: homeController).visible(serviceList.isNotEmpty)),
                              16.height,
                              Align(
                                alignment: Alignment.center,
                                child: Obx(
                                  () => homeController.isAdShow.value && !isPremiumUser.value
                                      ? Container(
                                          margin: const EdgeInsets.symmetric(vertical: 16),
                                          width: homeController.bannerAd!.size.width.toDouble(),
                                          height: homeController.bannerAd!.size.height.toDouble(),
                                          child: AdWidget(ad: homeController.bannerAd!),
                                        )
                                      : Container(),
                                ),
                              ),
                              HomeTemplatesComponent(homeController: homeController),
                              RecentHistoryComponent(homeController: homeController),
                            ],
                          ).paddingOnly(bottom: 80),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
