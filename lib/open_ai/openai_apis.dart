import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:nb_utils/nb_utils.dart';
import '../network/network_utils.dart';
import '../utils/api_end_points.dart';
import 'models/v1_chat_completions_res.dart';
import 'models/v1_images_generation_res.dart';
import 'openai_utils.dart';
import 'package:http/http.dart' as http;

class OpenAiApis {
  /// For more details, check the OpenAI Chat API documentation
  /// at https://platform.openai.com/docs/api-reference/chat/create
  static Future<V1ChatCompletionResponse> chatCompletions({required Map request}) async {
    final res = V1ChatCompletionResponse.fromJson(await handleOpenAiResponse(await buildOpenAiHttpResponse(APIEndPoints.chatCompletions, request: request, method: HttpMethodType.POST)));
    return res;
  }

  /// For more details, check the OpenAI Chat API documentation
  /// at https://platform.openai.com/docs/api-reference/images/create
  static Future<V1ImageGenerationResponse> imagesGenerations({required Map request, required String type, int? templateId}) async {
    /* final res = V1ImageGenerationResponse.fromJson({
      "created": currentMillisecondsTimeStamp(),
      "data": [
        {"revised_prompt": "where every twist and turn uncovers a new mystery.", "url": "https://i.postimg.cc/3R23Ykmh/img-i-DIfy-C5-Ion1svk-XSIGqgoj-QH.png"}
      ]
    }); */
    final res = V1ImageGenerationResponse.fromJson(await handleOpenAiResponse(await buildOpenAiHttpResponse(APIEndPoints.imagesGenerations, request: request, method: HttpMethodType.POST)));
    return res;
  }

  /// For more details, check the OpenAI Chat API documentation
  /// at https://platform.openai.com/docs/api-reference/audio/createTranscription
  static Future<void> audioTranscriptions({required String type, required Map<String, dynamic> req, int? templateId, required String filePath, required Function(String) onSuccess, required VoidCallback loaderOff}) async {
    var multiPartRequest = await getMultiPartRequest("", baseUrl: "https://api.openai.com/${APIEndPoints.audioTranscriptions}");
    multiPartRequest.fields.addAll(await getMultipartFields(val: req));

    if (filePath.isNotEmpty) {
      multiPartRequest.files.add(await http.MultipartFile.fromPath('file', filePath));
    }

    log("Multipart ${jsonEncode(multiPartRequest.fields)}");
    log("Multipart Files ${multiPartRequest.files.map((e) => e.filename)}");
    log("Multipart Extension ${multiPartRequest.files.map((e) => e.filename!.split(".").last)}");
    Map<String, String> headers = {};

    headers.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer $chatGPTAPIkey');
    headers.putIfAbsent(HttpHeaders.contentTypeHeader, () => 'application/json');
    multiPartRequest.headers.addAll(headers);

    await sendMultiPartRequest(multiPartRequest, onSuccess: (temp) async {
      log("Response: ${jsonDecode(temp)}");
      // toast(baseResponseModel.message, print: true);
      try {
        onSuccess.call(jsonDecode(temp)["text"] is String ? jsonDecode(temp)["text"] : "");
      } catch (e) {
        log('SaveBookingRes.fromJson E: $e');
      }
    }, onError: (error) {
      toast(error.toString(), print: true);
      loaderOff.call();
    });
    return;
  }
}
