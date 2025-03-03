import 'dart:convert';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../models/base_response_model.dart';
import '../../../models/upload_image_model.dart';
import '../../../network/network_utils.dart';
import '../../../utils/api_end_points.dart';
import '../../../utils/app_common.dart';
import '../../../utils/constants.dart';
import '../model/categories_res.dart';
import '../model/check_daily_limit_model.dart';
import '../model/custom_temp_res.dart';
import '../model/history_data_model.dart';
import '../model/home_detail_res.dart';

class HomeServiceApis {
  ///TO Check limit for free plan based on ip address
  static Future<CheckDailyLimitModel> checkDailyLimitAPi() async {
    return CheckDailyLimitModel.fromJson(await handleResponse(await buildHttpResponse(APIEndPoints.checkDailyLimit, method: HttpMethodType.GET)));
  }

  ///TO Check limit based on current subscription
  static Future<BaseResponseModel> checkUserCurrentSubscriptionLimit({required String systemService, String? category}) async {
    List<String> params = [];
    params.add('${UserKeys.userId}=${loginUserData.value.id}');
    params.add('system_service=$systemService');
    if (category != null) {
      params.add('category=$category');
    }
    return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse(getEndPoint(endPoint: APIEndPoints.checkLimits, params: params), method: HttpMethodType.GET)));
  }

  static Future<Rx<HomeData>> getDashboard() async {
    if (isLoggedIn.value) {
      return HomeDetailRes.fromJson(await handleResponse(await buildHttpResponse("${APIEndPoints.getDashboard}?user_id=${loginUserData.value.id}", method: HttpMethodType.GET))).data.obs;
    } else {
      return HomeDetailRes.fromJson(await handleResponse(await buildHttpResponse(APIEndPoints.getDashboard, method: HttpMethodType.GET))).data.obs;
    }
  }

  static Future<HistoryResponse> getUserHistory({required String type}) async {
    List<String> params = [];

    params.add('${UserKeys.userId}=${loginUserData.value.id}');
    params.add('type=$type');

    return HistoryResponse.fromJson(await handleResponse(await buildHttpResponse(getEndPoint(page: 1, perPages: 50, endPoint: APIEndPoints.getUserHistory, params: params), method: HttpMethodType.GET)));
  }

  static Future<BaseResponseModel> clearUserHistory({required String type, int? historyId}) async {
    List<String> params = [];

    params.add('${UserKeys.userId}=${loginUserData.value.id}');
    params.add('type=$type');
    params.addIf(historyId != null, 'histroy_id=$historyId');

    return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse(getEndPoint(endPoint: APIEndPoints.clearUserHistory, params: params), method: HttpMethodType.GET)));
  }

  static Future<UploadImageModel> uploadImage({required List<String> files, Function()? onSuccess}) async {
    var multiPartRequest = await getMultiPartRequest(APIEndPoints.uploadImages);

    if (files.isNotEmpty) {
      multiPartRequest.files.addAll(await getMultipartFiles(files: files.validate(), name: 'upload_image'));
    }

    log("Multipart Files ${multiPartRequest.files.map((e) => e.filename)}");
    log("Multipart Extension ${multiPartRequest.files.map((e) => e.filename!.split(".").last)}");

    multiPartRequest.headers.addAll(buildHeaderTokens());

    UploadImageModel uploadImageModelRes = UploadImageModel();

    await sendMultiPartRequest(multiPartRequest, onSuccess: (temp) async {
      log("Response: ${jsonDecode(temp)}");
      uploadImageModelRes = UploadImageModel.fromJson(jsonDecode(temp));
      log("message ${uploadImageModelRes.message}");
      try {
        onSuccess?.call();
      } catch (e) {
        log('SaveBookingRes.fromJson E: $e');
      }
    }, onError: (error) {
      toast(error.toString(), print: true);
    });

    return uploadImageModelRes;
  }

  static Future<void> saveHistoryApi({required Map<String, dynamic> data, required String type, int? templateId, int wordCount = 0, int imageCount = 0, List<String>? files, Function()? onSuccess, Function(bool)? loaderOff}) async {
    var multiPartRequest = await getMultiPartRequest(APIEndPoints.saveHistory);

    multiPartRequest.fields.addAll(
      await getMultipartFields(
        val: {
          'user_id': loginUserData.value.id,
          'type': type,
          'word_count': wordCount,
          'image_count': imageCount,
          'template_id': templateId ?? 0,
        },
      ),
    );
    multiPartRequest.fields.putIfAbsent("history_data", () => jsonEncode(data));

    if (files.validate().isNotEmpty) {
      multiPartRequest.files.addAll(await getMultipartFiles(files: files.validate(), name: 'history_image'));
      multiPartRequest.fields['image_count'] = files.validate().length.toString();
    }
    log('MULTIPARTREQUEST.FILES: ${multiPartRequest.files.length}');

    log("Multipart ${jsonEncode(multiPartRequest.fields)}");
    log("Multipart Files ${multiPartRequest.files.map((e) => e.filename)}");
    log("Multipart Extension ${multiPartRequest.files.map((e) => e.filename!.split(".").last)}");

    multiPartRequest.headers.addAll(buildHeaderTokens());
    print("multiPartRequest ========1=================$multiPartRequest");
    loaderOff?.call(true);
    BaseResponseModel baseResponseModel = BaseResponseModel();
    await sendMultiPartRequest(multiPartRequest, onSuccess: (temp) async {
      log("Response: ${jsonDecode(temp)}");
      baseResponseModel = BaseResponseModel.fromJson(jsonDecode(temp));
      log("message ${baseResponseModel.message}");
      try {
        onSuccess?.call();
      } catch (e) {
        log('SaveBookingRes.fromJson E: $e');
      }
      loaderOff?.call(false);
    }, onError: (error) {
      toast(error.toString(), print: true);
      loaderOff?.call(false);
    });
  }

  static Future<RxList<CustomTemplate>> getSearchResponse({
    String searchString = '',
    int page = 1,
    int perPage = Constants.perPageItem,
    required List<CustomTemplate> templateList,
    Function(bool)? lastPageCallBack,
  }) async {
    List<String> params = [];

    if (searchString.isNotEmpty) {
      params.add('search=$searchString');
    }

    params.addIf(!params.contains(UserKeys.userId), '${UserKeys.userId}=${loginUserData.value.id}');

    CustomTemplateRes res = CustomTemplateRes.fromJson(await handleResponse(await buildHttpResponse(getEndPoint(endPoint: APIEndPoints.customTemplateList, params: params))));

    if (page == 1) templateList.clear();
    templateList.addAll(res.data);
    lastPageCallBack?.call(templateList.length != perPage);

    return templateList.obs;
  }

  static Future<RxList<CategoryElement>> getCategoriesApi({String systemService = ""}) async {
    List<String> params = [];

    if (systemService.isNotEmpty) {
      params.add('system_service=$systemService');
    }

    params.addIf(!params.contains(UserKeys.userId), '${UserKeys.userId}=${loginUserData.value.id}');

    final res = CategoriesRes.fromJson(await handleResponse(await buildHttpResponse(getEndPoint(endPoint: APIEndPoints.categoryList, params: params))));
    return res.data.obs;
  }
}
