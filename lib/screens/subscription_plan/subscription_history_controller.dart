import 'dart:ui';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/screens/subscription_plan/services/plan_services_api.dart';

import '../../main.dart';
import '../../utils/common_base.dart';
import '../../utils/constants.dart';
import 'models/subscription_history_response.dart';

class SubscriptionHistoryController extends GetxController {
  Rx<Future<List<SubscriptionHistoryData>>> getSubscriptionHistoryFuture = Future(() => <SubscriptionHistoryData>[]).obs;

  List<SubscriptionHistoryData> subscriptionHistoryDataList = [];

  RxBool isLastPage = false.obs;
  RxBool isLoading = false.obs;

  RxInt page = 1.obs;

  @override
  void onInit() {
    subscriptionHistoryList(showLoader: false);
    super.onInit();
  }

  Future<void> subscriptionHistoryList({bool showLoader = true}) async {
    if (showLoader) {
      isLoading(true);
    }
    getSubscriptionHistoryFuture(
      PlanServiceApi.getSubscriptionHistoryList(
        subscriptionHistoryList: subscriptionHistoryDataList,
        page: page.value,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).then((value) {
      isLoading(false);
      log('value.length ==> ${value.length}');
    }).catchError((e) {
      isLoading(false);
      log('subscriptionHistoryList E: $e');
    }).whenComplete(() => isLoading(false));
  }

  Future<void> cancelSubscription({required int subscriptionId, VoidCallback? onUpdateSubscription, required SubscriptionHistoryData subscriptionHistoryData}) async {
    isLoading(true);
    hideKeyBoardWithoutContext();

    await PlanServiceApi.cancelSubscriptionPlan().then((value) {
      if (onUpdateSubscription != null) {
        subscriptionHistoryData.status = SUBSCRIPTION_STATUS_INACTIVE;
        onUpdateSubscription.call();

        toast(locale.value.searchTemplates);
      }

      isLoading(false);
    }).catchError((e) {
      isLoading(false);
      toast(e.toString(), print: true);
    });
  }

}
