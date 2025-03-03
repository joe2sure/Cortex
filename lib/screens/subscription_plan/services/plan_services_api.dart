import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/network/network_utils.dart';
import 'package:Cortex/utils/api_end_points.dart';

import '../../../utils/app_common.dart';
import '../../../utils/constants.dart';
import '../models/subscription_history_response.dart';
import '../models/subscription_plan_model.dart';

class PlanServiceApi {
  static Future<RxList<SubscriptionModel>> getPlanListApi() async {
    SubscriptionResponseModel res = SubscriptionResponseModel.fromJson(await handleResponse(await buildHttpResponse(APIEndPoints.subscriptionPlanList)));
    return res.subscriptionPlanList.obs;
  }

  static Future<Rx<SubscriptionModel>> saveSubscriptionPlanApi(Map request) async {
    SubscriptionModel res = SubscriptionModel.fromJson(await handleResponse(await buildHttpResponse(APIEndPoints.saveSubscriptionDetails, request: request, method: HttpMethodType.POST)));
    return res.obs;
  }

  static Future<List<SubscriptionHistoryData>> getSubscriptionHistoryList({
    int page = 1,
    int perPage = Constants.perPageItem,
    required List<SubscriptionHistoryData> subscriptionHistoryList,
    Function(bool)? lastPageCallBack,
  }) async {
    if (isLoggedIn.value) {
      /*?per_page=$perPage&page=$page*/
      final res = SubscriptionHistoryResponse.fromJson(await handleResponse(await buildHttpResponse(APIEndPoints.userSubscriptionHistory, method: HttpMethodType.GET)));
      if (page == 1) subscriptionHistoryList.clear();
      subscriptionHistoryList.addAll(res.data);
      lastPageCallBack?.call(res.data.length != perPage);
      return subscriptionHistoryList;
    } else {
      return [];
    }
  }

  static Future cancelSubscriptionPlan() async {
    Map<String, dynamic> req = {
      'id': userCurrentSubscription.value.id,
      "user_id": loginUserData.value.id,
      "status": "inactive",
    };

    await handleResponse(
      await buildHttpResponse(
        APIEndPoints.cancleSubscription,
        method: HttpMethodType.POST,
        request: req,
      ),
    ).then(
      (value) {
        userCurrentSubscription = SubscriptionHistoryData().obs;
      },
    );
  }
}
