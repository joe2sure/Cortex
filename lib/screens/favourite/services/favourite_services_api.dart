import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/screens/ai_writer/ai_writer_controller.dart';
import 'package:Cortex/screens/favourite/fav_controller.dart';
import 'package:Cortex/screens/favourite/models/favourite_res_model.dart';
import 'package:Cortex/utils/app_common.dart';

import '../../../models/base_response_model.dart';
import '../../../network/network_utils.dart';
import '../../../utils/api_end_points.dart';
import '../../../utils/constants.dart';
import '../../home/home_controller.dart';

class FavouriteServices {
  static Future<RxList<FavData>> getFavouritesList({
    int page = 1,
    int perPage = 50,
    required RxList<FavData> templateList,
    Function(bool)? lastPageCallBack,
  }) async {
    List<String> params = [];

    params.add('${UserKeys.userId}=${loginUserData.value.id}');

    FavResponse res = FavResponse.fromJson(await handleResponse(await buildHttpResponse(getEndPoint(endPoint: APIEndPoints.favouriteList, params: params))));
    if (page == 1) templateList.clear();
    templateList.addAll(res.data);
    lastPageCallBack?.call(templateList.length != perPage);

    return templateList;
  }

  static Future<bool> addToWishList({required int templatedId}) async {
    try {
      Map<String, dynamic> request = {'template_id': templatedId, 'user_id': loginUserData.value.id};
      final res = BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse(APIEndPoints.addToFavouriteList, method: HttpMethodType.POST, request: request)));
      return res.status;
    } catch (e) {
      toast(e.toString());
      return false;
    }
  }

  static Future<bool> removeFromWishList({required int templateId}) async {
    try {
      final res = BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoints.removeFromFavouriteList}/$templateId', method: HttpMethodType.GET)));
      return res.status;
    } catch (e) {
      toast(e.toString());
      return false;
    }
  }

  static Future<bool> onTapFavourite({required FavData favData}) async {
    bool isRemoved = false;
    final templateId = favData.templateData.id;
    if (favData.templateData.inWishList.value) {
      favData.templateData.inWishList(false);
      bool success = await removeFromWishList(templateId: templateId);
      if (success) {
        isRemoved = true;
        favData.templateData.inWishList(false);
        await updateFavouriteElementEveryWhere(id: templateId, inWishList: false);
        log("-----remove success--template_id $templateId-----${favData.templateData.inWishList.value}-------");
      }
    } else {
      favData.templateData.inWishList(true);
      bool success = await addToWishList(templatedId: templateId);
      if (success) {
        favData.templateData.inWishList(true);
        await updateFavouriteElementEveryWhere(id: templateId, inWishList: true);
        log("-----add success--template_id $templateId-----${favData.templateData.inWishList.value}-------");
      }
    }
    return isRemoved;
  }

  static Future<void> updateFavouriteElementEveryWhere({required int id, required bool inWishList}) async {
    try {
      FavController wLCont = Get.find();
      final val = wLCont.favourites.firstWhereOrNull((element) => element.id == id);
      val?.templateData.inWishList(inWishList);
    } catch (e) {
      log('wLCont = Get.find() E: $e');
    }
    try {
      HomeController hCont = Get.find();
      final val = hCont.dashboardData.value.customTemplate.firstWhereOrNull((element) => element.id == id);
      val?.inWishList(inWishList);
    } catch (e) {
      log('hCont = Get.find() E: $e');
    }
    try {
      AiWriterController aiWriteCont = Get.find();
      for (var element in aiWriteCont.categoryListResponse) {
        final val = element.customTemplate.firstWhereOrNull((element) => element.id == id);
        val?.inWishList(inWishList);
      }
    } catch (e) {
      log('hCont = Get.find() E: $e');
    }
  }
}
