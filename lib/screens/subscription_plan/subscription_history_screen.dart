import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/components/app_scaffold.dart';
import 'package:Cortex/screens/subscription_plan/subscription_history_controller.dart';
import 'package:Cortex/utils/colors.dart';
import 'package:Cortex/utils/common_base.dart';

import '../../components/loader_widget.dart';
import '../../components/price_widget.dart';
import '../../main.dart';
import '../../utils/constants.dart';
import '../../utils/empty_error_state_widget.dart';
import 'models/subscription_history_response.dart';

class SubscriptionHistoryScreen extends StatelessWidget {
  SubscriptionHistoryScreen({super.key});

  final SubscriptionHistoryController subscriptionHistoryController = Get.put(SubscriptionHistoryController());

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBartitleText: locale.value.subscriptionHistory,
      isLoading: subscriptionHistoryController.isLoading,
      body: Obx(
        () => SnapHelperWidget<List<SubscriptionHistoryData>>(
          future: subscriptionHistoryController.getSubscriptionHistoryFuture.value,
          errorBuilder: (error) {
            return NoDataWidget(
              title: error,
              retryText: locale.value.reload,
              imageWidget: const ErrorStateWidget(),
              onRetry: () {
                subscriptionHistoryController.page(1);
                subscriptionHistoryController.isLoading(true);
                subscriptionHistoryController.subscriptionHistoryList();
              },
            ).paddingSymmetric(horizontal: 32);
          },
          loadingWidget: subscriptionHistoryController.isLoading.value ? const Offstage() : const LoaderWidget(),
          onSuccess: (subscriptionHistoryList) {
            final reversedList = subscriptionHistoryList.reversed.toList();
            return AnimatedListView(
              shrinkWrap: true,
              itemCount: reversedList.length,
              physics: const AlwaysScrollableScrollPhysics(),
              listAnimationType: ListAnimationType.None,
              emptyWidget: NoDataWidget(
                title: locale.value.noSubscriptionFound,
                subTitle: locale.value.youHaventSubscribeAnySubscription,
                titleTextStyle: primaryTextStyle(),
                imageWidget: const EmptyStateWidget(),
                retryText: locale.value.reload,
                onRetry: () {
                  subscriptionHistoryController.page(1);
                  subscriptionHistoryController.isLoading(true);
                  subscriptionHistoryController.subscriptionHistoryList();
                },
              ).paddingSymmetric(horizontal: 32),
              itemBuilder: (context, index) {
                SubscriptionHistoryData planHistoryData = reversedList[index];

                return Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: context.cardColor,
                    borderRadius: radius(),
                    border: Border.all(width: 1, color: appColorPrimary),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${planHistoryData.startDate.toString().dateInDMMMMyyyyFormat} - ${planHistoryData.endDate.toString().dateInDMMMMyyyyFormat}',
                        style: boldTextStyle(letterSpacing: 1.3),
                      ),
                      16.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(locale.value.plan, style: secondaryTextStyle()),
                          Text(planHistoryData.name.validate().capitalizeFirstLetter(), style: boldTextStyle()),
                        ],
                      ),
                      16.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ///Add language
                          Text("Duration", style: secondaryTextStyle()),
                          Text("${planHistoryData.duration.validate().toString()} ${planHistoryData.type.validate()=="Monthly"?"Month":"Year"}", style: boldTextStyle()),
                        ],
                      ),
                      16.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ///Add language
                          Text("Status", style: secondaryTextStyle()),
                          Text(planHistoryData.status.validate().capitalizeFirstLetter(), style: boldTextStyle()),
                        ],
                      ),
                      16.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ///Add language
                          Text("Plan Type", style: secondaryTextStyle()),
                          Text(planHistoryData.planType.validate().capitalizeFirstLetter(), style: boldTextStyle()),
                        ],
                      ),
                      if (planHistoryData.identifier.toLowerCase() != FREE.toLowerCase())
                        Column(
                          children: [
                            16.height,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(locale.value.amount, style: secondaryTextStyle()),
                                16.width,
                                PriceWidget(
                                  price: planHistoryData.amount.validate(),
                                  color: appColorPrimary,
                                  isBoldText: true,
                                ).flexible(),
                              ],
                            ),
                          ],
                        ),
                    ],
                  ),
                );
              },
              onNextPage: () async {
                if (!subscriptionHistoryController.isLastPage.value) {
                  subscriptionHistoryController.page(subscriptionHistoryController.page.value + 1);
                  subscriptionHistoryController.isLoading(true);
                  subscriptionHistoryController.subscriptionHistoryList();
                }
              },
              onSwipeRefresh: () async {
                subscriptionHistoryController.page(1);
                return await subscriptionHistoryController.subscriptionHistoryList(showLoader: false);
              },
            );
          },
        ),
      ),
    );
  }
}
