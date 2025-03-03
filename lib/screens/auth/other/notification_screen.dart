import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/components/loader_widget.dart';

import '../../../components/app_scaffold.dart';
import '../../../components/cached_image_widget.dart';
import '../../../generated/assets.dart';
import '../../../utils/colors.dart';
import '../model/notification_model.dart';
import 'notification_screen_controller.dart';
import '../../../main.dart';
import '../../../utils/common_base.dart';
import '../../../utils/empty_error_state_widget.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});
  final NotificationScreenController notificationScreenController = Get.put(NotificationScreenController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppScaffold(
        appBartitleText: locale.value.notifications,
        isLoading: notificationScreenController.isLoading,
        hasLeadingWidget: false,
        actions: notificationScreenController.notificationDetail.isNotEmpty
            ? [
                TextButton(
                  onPressed: () {
                    notificationScreenController.clearAllNotification(context: context);
                  },
                  child: Text(locale.value.clearAll, style: secondaryTextStyle(color: appColorPrimary, decorationColor: appColorPrimary)).paddingSymmetric(horizontal: 8),
                ),
              ]
            : null,
        body: Obx(
          () => SnapHelperWidget(
            future: notificationScreenController.getNotifications.value,
            errorBuilder: (error) {
              return NoDataWidget(
                title: error,
                retryText: locale.value.reload,
                imageWidget: const ErrorStateWidget(),
                onRetry: () {
                  notificationScreenController.page(1);
                  notificationScreenController.isLoading(true);
                  notificationScreenController.init();
                },
              ).paddingSymmetric(horizontal: 32);
            },
            loadingWidget: notificationScreenController.isLoading.value ? const Offstage() : const LoaderWidget(),
            onSuccess: (notifications) {
              return AnimatedListView(
                shrinkWrap: true,
                itemCount: notifications.length,
                listAnimationType: ListAnimationType.None,
                physics: const AlwaysScrollableScrollPhysics(),
                emptyWidget: NoDataWidget(
                  title: locale.value.stayTunedNoNew,
                  subTitle: locale.value.noNewNotificationsAt,
                  titleTextStyle: primaryTextStyle(),
                  imageWidget: const EmptyStateWidget(),
                  retryText: locale.value.reload,
                  onRetry: () {
                    notificationScreenController.page(1);
                    notificationScreenController.isLoading(true);
                    notificationScreenController.init();
                  },
                ).paddingSymmetric(horizontal: 32).paddingBottom(84),
                itemBuilder: (context, index) {
                  NotificationData notification = notificationScreenController.notificationDetail[index];
                  return GestureDetector(
                    onTap: () {
                      /* if (notification.data.notificationDetail.id > 0) {
                        if (notification.data.notificationDetail.notificationGroup == "shop") {
                          Get.to(() => OrderDetailScreen(), arguments: OrderListData(id: notification.data.notificationDetail.id, orderCode: notification.data.notificationDetail.orderCode));
                        } else {
                          Get.to(() => BookingDetailScreen(),
                              arguments: BookingDataModel(id: notification.data.notificationDetail.id, service: SystemService(name: notification.data.notificationDetail.bookingServicesNames), payment: PaymentDetails(), training: Training()));
                        }
                      } */
                    },
                    behavior: HitTestBehavior.translucent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        8.height,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: boxDecorationDefault(color: Colors.white, shape: BoxShape.circle),
                              padding: const EdgeInsets.all(10),
                              alignment: Alignment.center,
                              child: const CachedImageWidget(
                                url: Assets.assetsAppLogo,
                                height: 20,
                                fit: BoxFit.cover,
                                color: appColorPrimary,
                                circle: true,
                              ),
                            ),
                            16.width,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '#${notification.data.notificationDetail.id}',
                                      style: primaryTextStyle(decoration: TextDecoration.none),
                                    ),
                                    4.width,
                                    Text('- ${notification.data.notificationDetail.bookingServicesNames}', style: primaryTextStyle()).visible(notification.data.notificationDetail.bookingServicesNames.isNotEmpty),
                                  ],
                                ),
                                4.height,
                                Text(notification.data.notificationDetail.type, style: primaryTextStyle(size: 14)).visible(notification.data.notificationDetail.type.isNotEmpty),
                                4.height,
                                Text(notification.updatedAt.dateInddMMMyyyyHHmmAmPmFormat, style: secondaryTextStyle()),
                              ],
                            ),
                            const Spacer(),
                            Container(
                              padding: EdgeInsets.zero,
                              height: 20,
                              width: 20,
                              decoration: boxDecorationDefault(shape: BoxShape.circle, border: Border.all(color: textSecondaryColorGlobal), color: context.cardColor),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(Icons.close_rounded, color: textSecondaryColorGlobal, size: 18),
                                onPressed: () async {
                                  notificationScreenController.removeNotification(context: context, notificationId: notificationScreenController.notificationDetail[index].id);
                                },
                              ),
                            ),
                          ],
                        ),
                        commonDivider.paddingSymmetric(vertical: 16),
                      ],
                    ).paddingSymmetric(horizontal: 16),
                  );
                },
                onNextPage: () async {
                  if (!notificationScreenController.isLastPage.value) {
                    notificationScreenController.page(notificationScreenController.page.value + 1);
                    notificationScreenController.isLoading(true);
                    notificationScreenController.init();
                  }
                },
                onSwipeRefresh: () async {
                  notificationScreenController.page(1);
                  return await notificationScreenController.init();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
