import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import '../configs.dart';
import '../main.dart';
import '../screens/auth/services/auth_service_apis.dart';
import '../utils/api_end_points.dart';
import '../utils/app_common.dart';
import '../utils/common_base.dart';
import '../utils/constants.dart';
import '../utils/local_storage.dart';

Map<String, String> buildHeaderTokens({String? endPoint}) {
  Map<String, String> header = {
    HttpHeaders.cacheControlHeader: 'no-cache',
    'Access-Control-Allow-Headers': '*',
    'Access-Control-Allow-Origin': '*',
    'global-localization': selectedLanguageCode.value,
  };
  if (endPoint == APIEndPoints.register) {
    header.putIfAbsent(HttpHeaders.acceptHeader, () => 'application/json');
  }
  header.putIfAbsent(HttpHeaders.contentTypeHeader, () => 'application/json; charset=utf-8');

  if (isLoggedIn.value) {
    header.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer ${loginUserData.value.apiToken}');
    header.putIfAbsent('ipaddress', () => deviceId.value);
  }

  // log(jsonEncode(header));
  return header;
}

String getEndPoint({required String endPoint, int? perPages, int? page, List<String>? params}) {
  String perPage = "?per_page=${perPages ?? Constants.perPageItem}";
  String pages = "&page=$page";

  if (page != null && params.validate().isEmpty) {
    return "$endPoint$perPage$pages";
  } else if (page != null && params.validate().isNotEmpty) {
    return "$endPoint$perPage$pages&${params.validate().join('&')}";
  } else if (page == null && params != null) {
    return "$endPoint?${params.join('&')}";
  }
  log('-------------$endPoint---------------');
  return endPoint;
}

Uri buildBaseUrl(String endPoint) {
  if (!endPoint.startsWith('http')) {
    return Uri.parse('$BASE_URL$endPoint');
  } else {
    return Uri.parse(endPoint);
  }
}

Future<Response> buildHttpResponse(
  String endPoint, {
  HttpMethodType method = HttpMethodType.GET,
  Map? request,
  Map<String, String>? header,
}) async {
  var headers = header ?? buildHeaderTokens(endPoint: endPoint);
  Uri url = buildBaseUrl(endPoint);

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

    if (isLoggedIn.value && response.statusCode == 401 && !endPoint.startsWith('http')) {
      return await reGenerateToken().then((value) async {
        return await buildHttpResponse(endPoint, method: method, request: request);
      }).catchError((e) {
        throw errorSomethingWentWrong;
      });
    } else {
      return response;
    }
  } on Exception catch (e) {
    log(e);
    if (!await isNetworkAvailable()) {
      throw errorInternetNotAvailable;
    } else {
      throw errorSomethingWentWrong;
    }
  }
}

Future<void> reGenerateToken() async {
  log('Regenerating Token');
  final userPASSWORD = getValueFromLocal(SharedPreferenceConst.USER_PASSWORD);

  Map req = {
    UserKeys.email: loginUserData.value.email,
    UserKeys.userType: LoginTypeConst.LOGIN_TYPE_USER,
  };
  if (loginUserData.value.isSocialLogin) {
    log('LOGINUSERDATA.VALUE.ISSOCIALLOGIN: ${loginUserData.value.isSocialLogin}');
    req[UserKeys.loginType] = loginUserData.value.loginType;
  } else {
    req[UserKeys.password] = userPASSWORD;
  }
  return await AuthServiceApis.loginUser(request: req, isSocialLogin: loginUserData.value.isSocialLogin).then((value) async {
    loginUserData.value.apiToken = value.userData.apiToken;
  }).catchError((e) {
    throw e;
  });
}

Future handleResponse(Response response, {HttpResponseType httpResponseType = HttpResponseType.JSON, bool? avoidTokenError, bool? isFlutterWave}) async {
  if (!await isNetworkAvailable()) {
    throw errorInternetNotAvailable;
  }

  if (response.statusCode.isSuccessful()) {
    if (response.body.trim().isJson()) {
      Map body = jsonDecode(response.body.trim());

      if (body.containsKey('status')) {
        if (isFlutterWave.validate()) {
          if (body['status'] == 'success') {
            return body;
          } else {
            throw body['message'] ?? errorSomethingWentWrong;
          }
        } else {
          if (body['status']) {
            return body;
          } else {
            throw body['message'] ?? errorSomethingWentWrong;
          }
        }
      } else {
        return body;
      }
    } else {
      throw errorSomethingWentWrong;
    }
  } else if (response.statusCode == 400) {
    throw locale.value.badRequest;
  } else if (response.statusCode == 403) {
    throw locale.value.forbidden;
  } else if (response.statusCode == 404) {
    Map body = jsonDecode(response.body.trim());
    if (body.containsKey('message')) {
      throw body['message'];
    }
    throw locale.value.pageNotFound;
  } else if (response.statusCode == 429) {
    throw locale.value.tooManyRequests;
  } else if (response.statusCode == 500) {
    throw locale.value.internalServerError;
  } else if (response.statusCode == 502) {
    throw locale.value.badGateway;
  } else if (response.statusCode == 503) {
    throw locale.value.serviceUnavailable;
  } else if (response.statusCode == 504) {
    throw locale.value.gatewayTimeout;
  } else {
    Map body = jsonDecode(response.body.trim());

    if (body.containsKey('status') && body['status']) {
      return body;
    } else {
      throw body['message'] ?? errorSomethingWentWrong;
    }
  }
}

//region CommonFunctions
Future<Map<String, String>> getMultipartFields({required Map<String, dynamic> val}) async {
  Map<String, String> data = {};

  val.forEach((key, value) {
    data[key] = '$value';
  });

  return data;
}

Future<MultipartRequest> getMultiPartRequest(String endPoint, {String? baseUrl}) async {
  String url = baseUrl ?? buildBaseUrl(endPoint).toString();
  // log(url);
  return MultipartRequest('POST', Uri.parse(url));
}

Future<void> sendMultiPartRequest(MultipartRequest multiPartRequest, {Function(dynamic)? onSuccess, Function(dynamic)? onError}) async {
  http.Response response = await http.Response.fromStream(await multiPartRequest.send());
  apiPrint(
      url: multiPartRequest.url.toString(), headers: jsonEncode(multiPartRequest.headers), request: jsonEncode(multiPartRequest.fields), hasRequest: true, statusCode: response.statusCode, responseBody: response.body.trim(), methodtype: "MultiPart");
  // log("Result: ${response.statusCode} - ${multiPartRequest.fields}");
  // log(response.body.trim());
  if (response.statusCode.isSuccessful()) {
    onSuccess?.call(response.body.trim());
  } else {
    onError?.call(response.reasonPhrase.validate(value: "Error Code ${response.statusCode}"));
  }
}

Future<List<MultipartFile>> getMultipartImages({required List<PlatformFile> files, required String name}) async {
  List<MultipartFile> multiPartRequest = [];

  await Future.forEach<PlatformFile>(files, (element) async {
    int i = files.indexOf(element);

    multiPartRequest.add(await MultipartFile.fromPath('$name[${i.toString()}]', element.path.validate()));
  });

  return multiPartRequest;
}

Future<List<MultipartFile>> getMultipartFiles({required List<String> files, required String name}) async {
  List<MultipartFile> multiPartRequest = [];

  await Future.forEach<String>(files, (element) async {
    int i = files.indexOf(element);

    multiPartRequest.add(await MultipartFile.fromPath('$name[${i.toString()}]', element));
    log('MultipartFile: $name[${i.toString()}]');
  });

  return multiPartRequest;
}

String parseStripeError(String response) {
  try {
    var body = jsonDecode(response);
    return parseHtmlString(body['error']['message']);
  } on Exception catch (e) {
    log(e);
    throw errorSomethingWentWrong;
  }
}

void apiPrint({String url = "", String endPoint = "", String headers = "", String request = "", int statusCode = 0, String responseBody = "", String methodtype = "", bool hasRequest = false, bool fullLog = false, String responseHeader = ''}) {
  // fullLog = statusCode.isSuccessful();
  if (fullLog) {
    debugPrint("┌───────────────────────────────────────────────────────────────────────────────────────────────────────");
    debugPrint("\u001b[93m Url: \u001B[39m $url");
    debugPrint("\u001b[93m endPoint: \u001B[39m \u001B[1m$endPoint\u001B[22m");
    debugPrint("\u001b[93m header: \u001B[39m \u001b[96m$headers\u001B[39m");
    if (hasRequest) {
      debugPrint('\u001b[93m Request: \u001B[39m \u001b[95m$request\u001B[39m');
    }
    debugPrint(statusCode.isSuccessful() ? "\u001b[32m" : "\u001b[31m");
    if (responseHeader.isNotEmpty) debugPrint("\u001b[93m Response header: \u001B[39m \u001b[96m$responseHeader\u001B[39m");
    debugPrint('\u001b[93m MethodType ($methodtype) | StatusCode ($statusCode)\u001B[39m');
    debugPrint('Response : ');
    debugPrint('\x1B[32m${formatJson(responseBody)}\x1B[0m');
    debugPrint("\u001B[0m");
    debugPrint("└───────────────────────────────────────────────────────────────────────────────────────────────────────");
  } else {
    debugPrint("┌───────────────────────────────────────────────────────────────────────────────────────────────────────");
    debugPrint("\u001b[93m Url: \u001B[39m $url");
    debugPrint("\u001b[93m endPoint: \u001B[39m \u001B[1m$endPoint\u001B[22m");
    debugPrint("\u001b[93m header: \u001B[39m \u001b[96m${headers.split(',').join(',\n')}\u001B[39m");
    if (hasRequest) {
      debugPrint('\u001b[93m Request: \u001B[39m \u001b[95m$request\u001B[39m');
    }
    debugPrint(statusCode.isSuccessful() ? "\u001b[32m" : "\u001b[31m");
    debugPrint('\u001b[93m MethodType ($methodtype) | statusCode: ($statusCode)\u001B[39m');
    debugPrint("\u001b[93m Response header: \u001B[39m \u001b[96m$responseHeader\u001B[39m");
    debugPrint('\u001b[93m Response \u001B[39m');
    debugPrint(responseBody);
    debugPrint("\u001B[0m");
    debugPrint("└───────────────────────────────────────────────────────────────────────────────────────────────────────");
  }
}

String formatJson(String jsonStr) {
  try {
    final dynamic parsedJson = jsonDecode(jsonStr);
    const formatter = JsonEncoder.withIndent('  ');
    return formatter.convert(parsedJson);
  } on Exception catch (e) {
    dev.log("\x1b[31m formatJson error ::-> ${e.toString()} \x1b[0m");
    return jsonStr;
  }
}

Map<String, String> buildHeaderForStripe(String stripeKeyPayment) {
  Map<String, String> header = defaultHeaders();

  header.putIfAbsent(HttpHeaders.contentTypeHeader, () => 'application/x-www-form-urlencoded');
  header.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer $stripeKeyPayment');

  return header;
}

Map<String, String> buildHeaderForSadad({String? sadadToken}) {
  Map<String, String> header = defaultHeaders();

  header.putIfAbsent(HttpHeaders.contentTypeHeader, () => 'application/json');
  if (sadadToken != null) {
    header.putIfAbsent(HttpHeaders.authorizationHeader, () => sadadToken);
  }

  return header;
}

Map<String, String> buildHeaderForFlutterWave(String flutterWaveSecretKey) {
  Map<String, String> header = defaultHeaders();

  header.putIfAbsent(HttpHeaders.authorizationHeader, () => "Bearer $flutterWaveSecretKey");

  return header;
}

Map<String, String> buildHeaderForAirtelMoney(String accessToken, String xCountry, String xCurrency) {
  Map<String, String> header = defaultHeaders();

  header.putIfAbsent(HttpHeaders.contentTypeHeader, () => 'application/json; charset=utf-8');
  header.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer $accessToken');
  header.putIfAbsent('X-Country', () => xCountry);
  header.putIfAbsent('X-Currency', () => xCurrency);

  return header;
}

Map<String, String> defaultHeaders() {
  Map<String, String> header = {};

  header.putIfAbsent(HttpHeaders.cacheControlHeader, () => 'no-cache');
  header.putIfAbsent('Access-Control-Allow-Headers', () => '*');
  header.putIfAbsent('Access-Control-Allow-Origin', () => '*');

  return header;
}

Future<Map<String, dynamic>> handleSadadResponse(Response res) async {
  if (res.body.isJson()) {
    var body = jsonDecode(res.body);

    if (res.statusCode.isSuccessful()) {
      return body;
    } else {
      throw parseHtmlString(body['error']['message']);
    }
  } else {
    throw errorSomethingWentWrong;
  }
}
