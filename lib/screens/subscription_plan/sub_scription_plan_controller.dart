import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:group_button/group_button.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/screens/subscription_plan/models/subscription_plan_model.dart';
import 'package:Cortex/screens/subscription_plan/services/plan_services_api.dart';

class PlanController extends GetxController {
  final groupButtonController = GroupButtonController(selectedIndex: 0);

  Rx<Future<RxList<SubscriptionModel>>> getSubscriptionPlanFuture = Future(() => RxList<SubscriptionModel>()).obs;

  Rx<SubscriptionModel> selectedPlan = SubscriptionModel().obs;

  RxBool isLoading = false.obs;

  RxString selectName = ''.obs;

  RxInt selectedPlanIndex = 0.obs;

  final ScrollController upperRowScrollCont = ScrollController();
  final ScrollController lowerRowScrollCont = ScrollController();

  Future<void> getPlanList({bool showLoader = true}) async {
    if (showLoader) {
      isLoading(true);
    }
    await getSubscriptionPlanFuture(PlanServiceApi.getPlanListApi().then((value) {
      return value;
    })).then((value) {}).catchError((e) {
      log('SubscriptionPlan List E: $e');
    }).whenComplete(() => isLoading(false));
  }
}
