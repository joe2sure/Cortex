import 'dart:convert';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../models/base_response_model.dart';
import '../../../network/network_utils.dart';
import '../../../utils/api_end_points.dart';
import '../../../utils/app_common.dart';
import '../../../utils/constants.dart';
import '../model/history_data_model.dart';
import '../model/messages_res.dart';
import '../model/recent_chat_res.dart';

class HistoryServiceApis {
  static Future<HistoryResponse> getUserHistory({String? type, int? templateId}) async {
    List<String> params = [];

    params.add('${UserKeys.userId}=${loginUserData.value.id}');
    params.addIf(type != null, 'type=$type');
    params.addIf(templateId != null, 'template_id=$templateId');

    return HistoryResponse.fromJson(await handleResponse(await buildHttpResponse(getEndPoint(page: 1, perPages: 50, endPoint: APIEndPoints.getUserHistory, params: params), method: HttpMethodType.GET)));
  }

  static Future<BaseResponseModel> clearUserHistory({String? type, String? serviceType, int? historyId}) async {
    List<String> params = [];

    params.add('${UserKeys.userId}=${loginUserData.value.id}');
    params.addIf(type != null, 'type=$type');
    params.addIf(serviceType != null, 'service=$serviceType');
    params.addIf(historyId != null, 'histroy_id=$historyId');

    return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse(getEndPoint(endPoint: APIEndPoints.clearUserHistory, params: params), method: HttpMethodType.GET)));
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

    loaderOff?.call(true);
    BaseResponseModel baseResponseModel = BaseResponseModel();
    await sendMultiPartRequest(multiPartRequest, onSuccess: (temp) async {
      log("Response: ${jsonDecode(temp)}");
      baseResponseModel = BaseResponseModel.fromJson(jsonDecode(temp));
      toast(baseResponseModel.message, print: true);
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

  static Future<RecentChatRes> addEditRecentChats({required Map request, bool isEdit = false}) async {
    return RecentChatRes.fromJson(await handleResponse(await buildHttpResponse(isEdit ? APIEndPoints.editRecentChat : APIEndPoints.saveRecentChat, request: request, method: HttpMethodType.POST)));
  }

  static Future<BaseResponseModel> deleteRecentChats({required int chatId}) async {
    List<String> params = [];
    params.add('chat_id=$chatId');
    return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse(getEndPoint(endPoint: APIEndPoints.deleteRecentChat, params: params))));
  }

  static Future<BaseResponseModel> saveMessage({required Map request}) async {
    return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse(APIEndPoints.saveMessage, request: request, method: HttpMethodType.POST)));
  }

  static Future<BaseResponseModel> saveReportOrFlag({required Map request}) async {
    return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse(APIEndPoints.saveReportOrFlag, request: request, method: HttpMethodType.POST)));
  }

  static Future<RxList<RecentChatElement>> getRecentChats({
    int page = 1,
    int perPage = 20,
    required RxList<RecentChatElement> recentChats,
    Function(bool)? lastPageCallBack,
  }) async {
    List<String> params = [];

    params.add('${UserKeys.userId}=${loginUserData.value.id}');

    RecentChatRes res = RecentChatRes.fromJson(await handleResponse(await buildHttpResponse(getEndPoint(endPoint: APIEndPoints.recentChatList, page: page, perPages: perPage, params: params))));
    if (page == 1) recentChats.clear();
    recentChats.addAll(res.recentChats);
    lastPageCallBack?.call(recentChats.length != perPage);

    return recentChats;
  }

  static Future<RxList<MessegeElement>> getMessageList({
    int page = 1,
    int perPage = 10,
    required int chatId,
    required RxList<MessegeElement> messageList,
    Function(bool)? lastPageCallBack,
  }) async {
    List<String> params = [];

    params.add('${UserKeys.userId}=${loginUserData.value.id}');
    params.add('chat_id=$chatId');

    MessegesRes res = MessegesRes.fromJson(await handleResponse(await buildHttpResponse(getEndPoint(endPoint: APIEndPoints.messageList, page: page, perPages: perPage, params: params))));
    if (page == 1) messageList.clear();
    log('MESSAGELIST before: ${messageList.map((e) => e.id).toList()}');
    messageList.insertAll(0, res.data.reversed);
    log('MESSAGELIST after addAll: ${messageList.map((e) => e.id).toList()}');
    lastPageCallBack?.call(messageList.length != perPage);

    return messageList;
  }
}
