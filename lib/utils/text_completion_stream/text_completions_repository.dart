// Dart imports:
import 'dart:async';
import 'dart:convert';

// Package imports:

import 'package:flutter/foundation.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:rxdart/rxdart.dart';
import 'package:Cortex/utils/api_end_points.dart';
import '../../main.dart';
import '../../network/network_utils.dart';
import '../constants.dart';
import 'decoder_queue.dart';
import 'package:dio/dio.dart';
// import 'package:rxdart/rxdart.dart';

class TextCompletionsRepository {
  final String matchResultString = '"text":';
  final String matchResultTurboString = '"content":';
  final Dio _openAIClient = Dio(
    BaseOptions(
      baseUrl: "https://api.openai.com/",
      connectTimeout: const Duration(milliseconds: TextCompletionConst.connectTimeOut),
      receiveTimeout: const Duration(milliseconds: TextCompletionConst.receiveTimeOut),
      sendTimeout: const Duration(milliseconds: TextCompletionConst.receiveTimeOut),
    ),
  );

  Map<String, String> _getHeaders(String apiKey) {
    return {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json; charset=UTF-8',
      'Connection': 'keep-alive',
      'Accept': '*/*',
      'Accept-Encoding': 'gzip, deflate, br',
    };
  }

  Options _getOptions(String apiKey, {ResponseType? responseType}) {
    return Options(
      validateStatus: (status) {
        return true;
      },
      headers: _getHeaders(apiKey),
      responseType: responseType,
    );
  }

  Future<String?> textCompletions({
    required Map<String, dynamic> request,
    Function(String p1)? onStreamValue,
    Function(bool)? onComplete,
    Function(StreamSubscription? p1)? onStreamCreated,
    Duration debounce = Duration.zero,
  }) async {
    String responseText = '';
    request["stream"] = true;
    final Response<ResponseBody> response = await _openAIClient.post(
      APIEndPoints.chatCompletions,
      data: request,
      options: _getOptions(chatGPTAPIkey, responseType: ResponseType.stream),
    );

    DecoderQueueService.instance.initialize();

    StreamController<String> responseDebounceStream = StreamController<String>();
    responseDebounceStream.stream.debounceTime(const Duration(seconds: 3)).listen((s) {
      if (responseText.trim().isEmpty || !response.statusCode.isSuccessful()) {
        onComplete?.call(false);
      } else {
        onComplete?.call(true);
      }
    });

    final StreamSubscription<Uint8List>? responseStream = response.data?.stream.asyncExpand((event) => Rx.timer(event, debounce)).doOnData((event) {}).listen(
      (bodyBytes) async {
        if (response.statusCode.isSuccessful()) {
          DecoderQueueService.instance.addQueue(() {
            responseText += _getContentFromJson(utf8.decode(bodyBytes));
            onStreamValue?.call(responseText);
            responseDebounceStream.add(responseText);
          });
        } else {
          Map body = jsonDecode(utf8.decode(bodyBytes));
          final msg = (body['message'] ?? body['error']['message'] ?? response.statusMessage.validate(value: "Error Code ${response.statusCode}")).toString();
          if (msg.contains("billing_hard_limit_reached") || msg.contains("exceeded") || msg.contains("insufficient")) {
            try {
              await handleResponse(await buildHttpResponse("${APIEndPoints.rechargeReminder}?type=${AdminNotifyKeys.openAi}", method: HttpMethodType.GET));
            } catch (e) {
              log('${AdminNotifyKeys.openAi} Err ==> $e');
            }
          }
          if (kDebugMode) {
            toast(msg);
          } else {
            toast(locale.value.apologiesForTheInconveniencePleaseTryAgainAft);
          }
        }
      },
    );

    onStreamCreated?.call(responseStream);

    await responseStream?.asFuture();
    responseStream?.cancel();
    responseDebounceStream.close();
    return responseText;
  }

  String _getContentFromJson(String jsonString) {
    List<String> contents = [];
    RegExp regex = RegExp(r'"content"\s*:\s*"([^"]+)"');
    Iterable<Match> matches = regex.allMatches(jsonString);

    for (Match match in matches) {
      if (match.groupCount > 0) {
        contents.add(match.group(1)!);
      }
    }

    return contents.join(""); // Joining all content values with a comma and space
  }
}
