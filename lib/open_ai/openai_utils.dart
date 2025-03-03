import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/main.dart';
import 'package:Cortex/utils/constants.dart';
import '../network/network_utils.dart';
import '../utils/api_end_points.dart';

Uri buildOpenAiUrl(String endPoint) {
  return Uri.parse('https://api.openai.com/$endPoint');
}

Future<Response> buildOpenAiHttpResponse(String endPoint, {HttpMethodType method = HttpMethodType.GET, Map? request}) async {
  Map<String, String> headers = {};

  headers.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer $chatGPTAPIkey');
  headers.putIfAbsent(HttpHeaders.contentTypeHeader, () => 'application/json');
  Uri url = buildOpenAiUrl(endPoint);

  Response response;
  log('URL (${method.name}): $url');

  try {
    if (method == HttpMethodType.POST) {
      log('Request: ${jsonEncode(request)}');
      response = await http.post(url, body: jsonEncode(request), headers: headers);
    } else if (method == HttpMethodType.DELETE) {
      response = await delete(url, headers: headers);
    } else if (method == HttpMethodType.PUT) {
      response = await put(url, body: jsonEncode(request), headers: headers);
    } else {
      response = await get(url, headers: headers);
    }

    apiPrint(
      url: url.toString(),
      endPoint: endPoint,
      headers: jsonEncode(headers),
      hasRequest: method == HttpMethodType.POST || method == HttpMethodType.PUT,
      request: jsonEncode(request),
      statusCode: response.statusCode,
      responseBody: response.body.trim(),
      methodtype: method.name,
    );

    // log('Response (${method.name}) ${response.statusCode}: ${response.body.trim().trim()}');

    return response;
  } on Exception catch (e) {
    log(e);
    if (!await isNetworkAvailable()) {
      throw errorInternetNotAvailable;
    } else {
      rethrow;
    }
  }
}

Future handleOpenAiResponse(Response response, {HttpResponseType httpResponseType = HttpResponseType.JSON, bool? avoidTokenError, bool? isFlutterWave}) async {
  if (!await isNetworkAvailable()) {
    throw errorInternetNotAvailable;
  }

  if (response.statusCode.isSuccessful()) {
    if (response.body.trim().isJson()) {
      Map body = jsonDecode(response.body.trim());
      return body;
    } else {
      return response.body;
    }
  } else {
    Map body = jsonDecode(response.body.trim());
    final msg = (body['message'] ?? body['error']['message'] ?? response.reasonPhrase.validate(value: "Error Code ${response.statusCode}")).toString();
    if (msg.contains("billing_hard_limit_reached") || msg.contains("exceeded") || msg.contains("insufficient")) {
      try {
        await handleResponse(await buildHttpResponse("${APIEndPoints.rechargeReminder}?type=${AdminNotifyKeys.openAi}", method: HttpMethodType.GET));
      } catch (e) {
        log('${AdminNotifyKeys.openAi} Err ==> $e');
      }
    }
    if (kDebugMode) {
      toast(msg);
    }
    throw locale.value.apologiesForTheInconveniencePleaseTryAgainAft;
  }
}
