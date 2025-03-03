// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/utils/api_end_points.dart';
import 'package:path_provider/path_provider.dart';
import 'package:Cortex/utils/app_common.dart';
import '../../../main.dart';
import '../../../network/network_utils.dart';
import '../../../utils/constants.dart';

enum APIProvider {
  picsArtFaceEnhanceApi,
  cutoutProPhotoEnhanceApi,
}

class Image2ImageApis {
  static Future<String> processImage({APIProvider provider = APIProvider.cutoutProPhotoEnhanceApi, required List<String> paths}) async {
    if (paths.isEmpty) {
      throw Exception('You haven\'t set any image. Please set an image first.');
    }
    switch (provider) {
      case APIProvider.picsArtFaceEnhanceApi:
        if (paths.length > 1) {
          throw Exception('You can upload only a single image for face enhancement feature.');
        }
        return await enhanceFace(path: paths.first);
      case APIProvider.cutoutProPhotoEnhanceApi:
        return await photoEnhance(paths: paths);
      }
  }

  static Future<String> enhanceFace({required String path}) async {
    var url = Uri.parse(APIEndPoints.faceEnhance);
    var request = http.MultipartRequest('POST', url)
      ..headers['X-Picsart-API-Key'] = appConfigs.value.picsartKey
      ..headers['accept'] = 'application/json'
      ..files.add(await http.MultipartFile.fromPath('image', path))
      ..fields['format'] = path.isNotEmpty ? path.split('.').last.toUpperCase() : 'PNG';

    log("Multipart ${jsonEncode(request.fields)}");
    log("Multipart Files ${request.files.map((e) => e.filename)}");
    log("Multipart Extension ${request.files.map((e) => e.filename!.split(".").last)}");

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    apiPrint(
      url: response.request!.url.toString(),
      endPoint: response.request!.url.path,
      headers: jsonEncode(response.headers),
      statusCode: response.statusCode,
      responseBody: response.body.trim(),
      methodtype: 'MultiPart',
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      var imagePath = responseData['data']['enhanced_image_url'];
      return imagePath;
    } else {
      throw Exception('Failed to enhance face: ${response.statusCode}');
    }
  }

  static Future<String> photoEnhance({required List<String> paths}) async {
    var url = Uri.parse(APIEndPoints.photoEnhance);
    var request = http.MultipartRequest('POST', url)..headers['APIKEY'] = appConfigs.value.cutoutproKey;

    for (var path in paths) {
      request.files.add(await http.MultipartFile.fromPath('file', path));
    }

    log("Multipart ${jsonEncode(request.fields)}");
    log("Multipart Files ${request.files.map((e) => e.filename)}");
    log("Multipart Extension ${request.files.map((e) => e.filename!.split(".").last)}");

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    apiPrint(
      url: response.request!.url.toString(),
      endPoint: response.request!.url.path,
      headers: jsonEncode(response.headers),
      statusCode: response.statusCode,
      responseBody: response.bodyBytes.length.toString(),
      methodtype: 'MultiPart',
    );

    if (response.statusCode == 200) {
      if (response.body.contains('msg')) {
        try {
          await handleResponse(await buildHttpResponse("${APIEndPoints.rechargeReminder}?type=${AdminNotifyKeys.cutoutPro}", method: HttpMethodType.GET));
        } catch (e) {
          log('${AdminNotifyKeys.openAi} Err ==> $e');
        }
        throw locale.value.apologiesForTheInconveniencePleaseTryAgainAft;
      } else {
        var cacheDir = await getTemporaryDirectory();
        var filePath = '${cacheDir.path}/${DateTime.now().millisecondsSinceEpoch}.png';
        var file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        return filePath;
      }
    } else {
      throw Exception('Failed to enhance photo: ${response.statusCode}');
    }
  }
}
