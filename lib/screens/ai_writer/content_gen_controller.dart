import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart' hide ResponseMessage;
import 'package:Cortex/utils/constants.dart';

import '../../open_ai/openai_apis.dart';
import '../../utils/text_completion_stream/text_completions_repository.dart';
import '../home/home_controller.dart';
import '../home/model/history_data_model.dart';
import '../home/model/home_detail_res.dart';
import '../home/services/history_api_service.dart';
import '../home/services/home_api_service.dart';
import '../home/services/system_service_helper.dart';
import 'content_gen_result_screen.dart';
import 'model/content_hist_element.dart';
import 'model/template_res_model.dart';

class ContentGenController extends GetxController {
  RxBool isLoading = false.obs;
  final GlobalKey<FormState> contentFormKey = GlobalKey();

  //Get History
  Rx<Future<HistoryResponse>> getHistoryResponseFuture = Future(() => HistoryResponse()).obs;
  Rx<HistoryResponse> historyResponse = HistoryResponse().obs;

  //Template
  Rx<CustomTemplate> templateData = CustomTemplate(inWishList: false.obs).obs;

  Rx<ContentHistElement> currentContent = ContentHistElement(content: "".obs, title: "".obs).obs;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    if (Get.arguments is CustomTemplate) {
      templateData(Get.arguments as CustomTemplate);
      for (var element in templateData.value.userinputList) {
        if (element.inputType == "single_select") {
          element.selectedChoice(element.optionData.firstWhere((p0) => p0.value.trim() == element.defaultValue.trim(), orElse: () => element.selectedChoice.value));
          element.nameCont.text = element.selectedChoice.value.title;
        } else {
          element.nameCont.text = element.defaultValue.trim();
        }
      }
    }
    getHistoryList();
    super.onInit();
  }

  void clearTextField() {
  for (var element in templateData.value.userinputList) {
    if (element.inputType == "single_select") {
      element.selectedChoice(element.optionData.firstWhere((p0) => p0.value.trim() == element.defaultValue.trim(), orElse: () => element.selectedChoice.value));
      element.nameCont.text = element.selectedChoice.value.title;
    }
    else
      {
        element.nameCont.text= element.defaultValue.trim();
      }
}

  }

  /// Get History APi
  Future<void> getHistoryList({bool showLoader = true}) async {
    if (showLoader) {
      isLoading(true);
    }
    await getHistoryResponseFuture(HistoryServiceApis.getUserHistory(templateId: templateData.value.id)).then((value) {
      historyResponse(value);
    }).catchError((e) {
      isLoading(false);
      log('getHistoryList E: $e');
    }).whenComplete(() => isLoading(false));
  }

  String replaceInputTags(String prompt, DynamicInputModel input) {
    var replacement = input.inputType == "single_select" && input.selectedChoice.value.value.isNotEmpty
        ? input.selectedChoice.value.value
        : input.nameCont.text.trim().isNotEmpty
            ? input.nameCont.text.trim()
            : input.defaultValue;

    dev.log('${input.fieldTitle} : $replacement', name: input.inputTag);
    return prompt.replaceAll(input.inputTag, replacement);
  }

  Future<void> generateContent(String title) async {
    loginPremiumTesterHandler(
      () async {
        String prompt = templateData.value.customPrompt;
        dev.log(prompt, name: "prompt=>");

        prompt = templateData.value.userinputList.fold(prompt, replaceInputTags);

        dev.log(prompt, name: "Final prompt=>");

        Map<String, dynamic> req = {
          "model": gpt4oMiniModel.value.slug,
          "messages": [
            {"role": "system", "content": "You are a helpful assistant."},
            {"role": "user", "content": prompt},
          ],
          "max_tokens": 1600,
          "stream": false
        };

        TextCompletionsRepository().textCompletions(
          request: req,
          onStreamValue: (characters) {
            dev.log('CHARACTERS: $characters');
            currentContent.value.content(characters);
            try {
              scrollController.jumpToBottom();
            } catch (e) {
              log('E: $e');
            }
          },
          onStreamCreated: (subscription) {
            Get.to(
              () => GenerateResultScreen(title: title),
            );
            isLoading(false);
          },
          onComplete: (p0) async {
            clearTextField();
            dev.log('ONCOMPLETE: $p0');
            generateTitle(prompt);
          },
          // Debounce 100ms for receive next value
          debounce: const Duration(milliseconds: 100),
        );
      },
      checkPremium: true,
      systemService: templateData.value.id == aiCodeTemplateId ? SystemServiceKeys.aiCode : SystemServiceKeys.aiWriter,
      category: templateData.value.id == aiCodeTemplateId ? null : templateData.value.categorySlug,
    );
  }

  Future<void> clearUserHistory({int? historyId, String? serviceType}) async {
    isLoading(true);
    await HistoryServiceApis.clearUserHistory(historyId: historyId, serviceType: serviceType).then((res) {
      toast(res.message);
      if (historyId != null) {
        historyResponse.value.data.removeWhere((element) => element.id == historyId);
      } else if (serviceType != null) {
        getHistoryList();
        try {
          HomeController hCont = Get.find<HomeController>();
          hCont.getDashboardDetail();
        } catch (e) {
          log('hCon E: $e');
        }
      }
    }).catchError((e) {
      toast(e.toString());
      log('deleteRecentChats E: $e');
    }).whenComplete(() => isLoading(false));
  }

  Future<void> generateTitle(String prompt) async {
    try {
      // Extracting relevant messages from the chat history
      List messages = [
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": prompt},
        {"role": "system", "content": currentContent.value.content.value}
      ];

      // Initialize chatTitle with a default value
      String chatTitle = currentContent.value.content.value.isNotEmpty ? currentContent.value.content.value : "";
      try {
        // Truncate chatTitle to a maximum length of 70 characters
        chatTitle = chatTitle.substring(0, min(70, chatTitle.length));
      } catch (e) {
        log('chatTitle.substring E: $e');
      }

      // Constructing the request object for the OpenAI API
      Map<String, dynamic> req = {
        "model": gpt4oMiniModel.value.slug,
        "messages": [
          {
            "role": "system",
            "content": '''
          Analyze the provided chat history it is a chat between user and gpt-model and generate suitable title.title length must be between 60-70 chars.And in the following JSON format:
          {
            "chat_title": "",
          }
        ''',
          },
          ...messages,
        ],
        "max_tokens": 1600,
        "stream": false
      };

      // Making the request to OpenAI's chat completion API
      final response = await OpenAiApis.chatCompletions(request: req);

      if (response.choices.isNotEmpty) {
        dev.log('Response : ${response.choices.first.message.content}');
        final convertToJsonRes = response.choices.first.message.content.replaceFirst("```json", "").replaceFirst("```", "");
        final res = jsonDecode(convertToJsonRes);
        if (res['chat_title'] is String) {
          chatTitle = res['chat_title'];
          currentContent.value.title(chatTitle);
        }
      }
      //Custom Api for handling History & Usage Calculation
      await HomeServiceApis.saveHistoryApi(
        data: {
          "request_body": req,
          "response_body": ContentHistElement(content: currentContent.value.content, title: chatTitle.obs).toJson(),
        },
        type: templateData.value.id == aiCodeTemplateId ? SystemServiceKeys.aiCode : SystemServiceKeys.aiWriter,
        wordCount: currentContent.value.content.value.countWords(),
        templateId: templateData.value.id,
      );
      await getHistoryList();
    } catch (e) {
      dev.log('E: $e');
    }
  }
}
