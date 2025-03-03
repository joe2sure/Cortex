import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:Cortex/configs.dart';
import 'package:Cortex/generated/assets.dart';
import 'package:Cortex/open_ai/models/v1_chat_completions_res.dart';
import 'package:Cortex/screens/home/services/system_service_helper.dart';
import 'package:Cortex/utils/app_common.dart';

import '../../main.dart';
import '../../open_ai/models/gpt_model.dart';
import '../../open_ai/openai_apis.dart';
import '../../utils/colors.dart';
import '../../utils/common_base.dart';
import '../../utils/constants.dart';
import '../../utils/getImage.dart';
import '../../utils/text_completion_stream/text_completions_repository.dart';
import '../home/model/messages_res.dart';
import '../home/model/recent_chat_res.dart';
import '../home/services/history_api_service.dart';
import '../home/services/home_api_service.dart';
import 'recent_chat_controller.dart';

class AiChatController extends GetxController {
  RxBool isLoading = false.obs;

  //Get History
  Rx<Future<RxList<MessegeElement>>> getMessagesResponseFuture = Future(() => RxList<MessegeElement>()).obs;
  RxBool isLastPage = false.obs;
  RxInt page = 1.obs;

  final GlobalKey<FormState> contentFormKey = GlobalKey();
  TextEditingController promptCont = TextEditingController();
  FocusNode promptFocus = FocusNode();

  RxList<V1ChatCompletionResponse> chatResponseList = RxList();

  RxList<MessegeElement> messageList = RxList();
  RxBool enableSendBtn = false.obs;

  final RxBool showCopied = false.obs;

  SpeechToText speech = SpeechToText();
  FlutterTts flutterTts = FlutterTts();
  RxString lastWords = ''.obs;
  RxString lastError = ''.obs;
  RxString lastStatus = ''.obs;
  RxBool speechStatus = false.obs;
  RxBool isSpeak = false.obs;
  Rx<RecentChatElement> recentChatElement = RecentChatElement(title: locale.value.newChat).obs;
  RxString speechText = ''.obs;

  final ScrollController scrollController = ScrollController();

  RxString pickedfilePath = ''.obs;
  RxString pickedfileTxtContent = ''.obs;

  @override
  void onReady() {
    // recentChatList();
    if (Get.arguments is RecentChatElement) {
      recentChatElement(Get.arguments);
      getMessageList();
    } else if (Get.arguments is String) {
      promptCont.text = Get.arguments;
      generateContent();
    }
    super.onReady();
  }

  @override
  void onClose() {
    flutterTts.stop();
    super.onClose();
  }

  Future<void> createNewChat() async {
    // Saving the generated chat title
    await HistoryServiceApis.addEditRecentChats(
      request: {"user_id": loginUserData.value.id, "title": locale.value.newChat},
    ).then((value) async {
      if (value.recentChats.isNotEmpty) {
        recentChatElement(value.recentChats.first);
        dev.log('RECENTCHATELEMENT: ${recentChatElement.value.toJson()}');
      }
      try {
        Get.find<RecentChatController>().recentChatList(showLoader: false);
      } catch (e) {
        log('Get.find<RecentChatController>() E: $e');
      }
    }).catchError((e) {
      log('createNewChat E: $e');
    });
  }

  Future<void> getMessageList({bool showLoader = true}) async {
    if (showLoader) {
      isLoading(true);
    }
    await getMessagesResponseFuture(
      HistoryServiceApis.getMessageList(
        messageList: messageList,
        page: page.value,
        chatId: recentChatElement.value.id,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).then((value) {
      try {
        scrollController.jumpToBottom();
      } catch (e) {
        log('E: $e');
      }
      debugPrint('MESSAGELIST msgScrollCont.jumpTo: ${value.length}');
    }).catchError((e) {
      log('getMessageList E: $e');
    }).whenComplete(() => isLoading(false));
  }

  Future<void> generateContent() async {
    loginPremiumTesterHandler(
      () async {
        if (recentChatElement.value.id.isNegative) {
          await createNewChat();
        }
        isLoading(true);
        // Extracting relevant messages from the chat history
        List messages = messageList
            .map((element) => {
                  "role": element.from > 0 ? "user" : "system",
                  "content": element.images.isNotEmpty
                      ? [
                          {"type": "text", "text": element.messageText.value},
                          {
                            "type": "image_url",
                            "image_url": {"url": element.images.first, "detail": "high"}
                          }
                        ]
                      : element.messageText.value,
                })
            .take(10)
            .toList();
        GPTModel selectedModel = gpt4oModel.value;
        if (pickedfilePath.value.isNotEmpty) {
          selectedModel = gptModels.firstWhere((element) => element.slug == ModelConstKeys.gpt4o, orElse: () => gpt4oModel.value);
        } else if (messageList.isNotEmpty) {
          selectedModel = gptModels.firstWhere((element) => element.slug == messageList.last.currentModel.value.slug, orElse: () => gpt4oModel.value);
        }

        MessegeElement questionMessage = MessegeElement(
          chatId: recentChatElement.value.id,
          to: selectedModel.id,
          from: loginUserData.value.id,
          messageText: promptCont.text.trim().obs,
          time: DateTime.now().formatDateYYYYmmddHHmm(),
          wordCount: promptCont.text.trim().countWords(),
          images: pickedfilePath.value.isNotEmpty ? [pickedfilePath.value] : [],
          selectedModel: selectedModel.obs,
        );
        messageList.add(questionMessage);
        // msgScrollCont.animateTo(msgScrollCont.position.maxScrollExtent, curve: Curves.easeOut, duration: const Duration(milliseconds: 300));
        Map<String, dynamic> req = {
          "model": selectedModel.slug,
          "messages": [
            {"role": "system", "content": "You are a helpful assistant. Your Name is $APP_NAME. if Someone asks about your name or identity related question reply i am $APP_NAME nice to meet you whats your name....."},
            ...messages,
            {
              "role": "user",
              "content": pickedfilePath.value.isNotEmpty
                  ? pickedfilePath.value.contains(RegExp(r'\.pdf|\.txt'))
                      ? "This is the content from uploaded file: \n\n$pickedfileTxtContent\n\n\n${promptCont.text}"
                      : [
                          {"type": "text", "text": promptCont.text},
                          {
                            "type": "image_url",
                            "image_url": {"url": pickedfilePath.value, "detail": "high"}
                          }
                        ]
                  : promptCont.text,
            },
          ],
          "max_tokens": 1600,
          "stream": true
        };

        promptCont.clear();
        pickedfilePath("");

        TextCompletionsRepository().textCompletions(
          request: req,
          onStreamValue: (characters) {
            dev.log('CHARACTERS: $characters');
            if (messageList.isNotEmpty) {
              messageList.last.messageText(characters);
            }
            try {
              scrollController.jumpTo(scrollController.position.maxScrollExtent);
            } catch (e) {
              log('E: $e');
            }
          },
          onStreamCreated: (subscription) {
            isLoading(false);
            MessegeElement answerMessage = MessegeElement(
              chatId: recentChatElement.value.id,
              to: loginUserData.value.id,
              from: selectedModel.id,
              messageText: "".obs,
              time: DateTime.now().formatDateYYYYmmddHHmm(),
              selectedModel: selectedModel.obs,
            );

            messageList.add(answerMessage);
          },
          onComplete: (status) async {
            dev.log('ONCOMPLETE: $status');
            if (status) {
              // msgScrollCont.animateTo(msgScrollCont.position.maxScrollExtent, curve: Curves.easeOut, duration: const Duration(milliseconds: 300));
              if (recentChatElement.value.title.trim().isEmpty || recentChatElement.value.title.trim() == "New Chat") {
                await generateTitle();
              }

              if (messageList.isNotEmpty) {
                try {
                  // Saving the questionMessage
                  await HistoryServiceApis.saveMessage(request: questionMessage.toJson());
                } catch (e) {
                  log('questionMessage save E: $e');
                }
                messageList.last.wordCount = messageList.last.messageText.value.countWords();
                try {
                  // Saving the answerMessage
                  await HistoryServiceApis.saveMessage(request: messageList.last.toJson());
                } catch (e) {
                  log('answerMessage save E: $e');
                }

                try {
                  //Custom Api for handling History & Usage Calculation
                  HomeServiceApis.saveHistoryApi(
                    data: {
                      "request_body": req,
                      "response_body": recentChatElement.value.toJson(),
                    },
                    type: SystemServiceKeys.aiChat,
                    wordCount: messageList.last.wordCount,
                  );
                } catch (e) {
                  log('answerMessage save E: $e');
                }
              }
            }
          },
          // Debounce 100ms for receive next value
          debounce: const Duration(milliseconds: 100),
        );
      },
      checkPremium: true,
      systemService: SystemServiceKeys.aiChat,
    );
  }

  Future<void> generateTitle() async {
    try {
      // Extracting relevant messages from the chat history
      List messages = messageList
          .map((element) => {
                "role": element.from > 0 ? "user" : "system",
                "content": element.messageText.value,
              })
          .take(5)
          .toList();

      // Initialize chatTitle with a default value
      String chatTitle = messages.isNotEmpty ? messages[0]['content'].toString() : "";

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
        }
      }
      // Saving the generated chat title
      await HistoryServiceApis.addEditRecentChats(
        request: {"chat_id": recentChatElement.value.id, "title": chatTitle},
        isEdit: true,
      );
      recentChatElement(RecentChatElement(id: recentChatElement.value.id, title: chatTitle));
      Get.find<RecentChatController>().recentChatList(showLoader: false);
    } catch (e) {
      dev.log('E: $e');
    }
  }

  //----------------------------------Speech To Text-------------------------------
  void startListening() async {
    bool available = await speech.initialize(onStatus: statusListener, onError: errorListener);

    if (available) {
      speech.listen(onResult: resultListener);

      speechStatus(true);
      lastWords('');
      lastError('');
      speech.listen(
        onResult: resultListener,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 10),
        listenOptions: SpeechListenOptions(listenMode: ListenMode.dictation),
      );
    } else {
      speechStatus(false);
      toast(locale.value.theUserHasDeniedTheUseOfSpeechRecognition);
    }
  }

  void stopListening() {
    speechStatus(false);
    speech.stop();
  }

  void cancelListening() {
    speechStatus(false);
    speech.cancel();
  }

  void resultListener(SpeechRecognitionResult result) {
    lastWords(result.recognizedWords);
    promptCont.text = lastWords.value;
    if (result.finalResult) {
      speechStatus(false);
      enableSendBtn(promptCont.text.trim().isNotEmpty);
    }
    log("LastWords: $lastWords");
  }

  void errorListener(SpeechRecognitionError error) {
    speechStatus(false);
    lastError('${error.errorMsg} - ${error.permanent}');
    log("lastError: $lastError");
  }

  void statusListener(String status) {
    lastStatus(status);
    log("lastStatus: $lastStatus");

    if (status == 'done') {
      speechStatus(false);
    }
  }

  void chatBotSpeak({required String text}) {
    flutterTts.setLanguage("en-US");
    flutterTts.setSpeechRate(0.5); //speed of speech
    flutterTts.setVolume(1.0); //volume of speech
    flutterTts.setPitch(1);

    if (text.isNotEmpty) {
      flutterTts.speak(text);
    }
  }

  //----------------------------------Image and File-------------------------------

  Future<void> handleDocumentClick() async {
    isLoading(true);
    await pickFiles(
      allowedExtensions: chatFilesAllowedExtensions,
      maxFileSizeMB: max_acceptable_file_size,
      type: FileType.custom,
    ).then((pickfiles) async {
      Get.back();
      if (pickfiles.isNotEmpty) {
        isLoading(true);
        await HomeServiceApis.uploadImage(files: pickfiles.map((e) => e.path).toList()).then((result) async {
          if (pickfiles.first.path.contains(RegExp(r'\.pdf|\.txt'))) {
            pickedfileTxtContent(await extractTextFromFile(pickfiles.first));
          }
          if (result.uploadImage.isNotEmpty) {
            pickedfilePath(result.uploadImage.first);
          }
        }).whenComplete(() => isLoading(false));
      }
    }).catchError((e) {
      toast(e);
      log('ChatServices().uploadFiles Err: $e');
      return;
    }).whenComplete(() => isLoading(false));
  }

  Future<void> handleCameraClick() async {
    GetImage(ImageSource.camera, path: (path, name, xFile) async {
      Get.back();
      log('Path camera : ${path.toString()} name $name');
      isLoading(true);
      await HomeServiceApis.uploadImage(files: [xFile.path]).then((result) async {
        if (result.uploadImage.isNotEmpty) {
          pickedfilePath(result.uploadImage.first);
        }
      }).whenComplete(() => isLoading(false));
    });
  }

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      backgroundColor: context.cardColor,
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SettingItemWidget(
              title: "File",
              leading:commonLeadingWid(imgPath: Assets.iconsIcFile, color: appColorPrimary),
              onTap: () async {
                if (!isLoading.value) {
                  handleDocumentClick();
                }
              },
            ),
            SettingItemWidget(
              title: locale.value.camera,
              leading: commonLeadingWid(imgPath: Assets.iconsIcCamera, color: appColorPrimary),
              onTap: () {
                if (!isLoading.value) {
                  handleCameraClick();
                }
              },
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
            ),
          ],
        ).paddingAll(16.0);
      },
    );
  }

  /* Future<void> _handleGalleryClick() async {
    Get.back();
    GetImage(ImageSource.gallery, path: (path, name, xFile) async {
      log('Path Gallery : ${path.toString()} name $name');
      isLoading(true);
      await HomeServiceApis.uploadImage(files: [xFile.path]).then((result) async {
        if (result.uploadImage.isNotEmpty) {
          pickedfilePath(result.uploadImage.first);
        }
      }).whenComplete(() => isLoading(false));
    });
    /* GetMultipleImage(path: (xFiles) async {
      log('Path Gallery : ${xFiles.length.toString()}');
      final existingNames = pickedImage.map((file) => file.name.trim().toLowerCase()).toSet();
      pickedImages.addAll(xFiles.where((file) => !existingNames.contains(file.name.trim().toLowerCase())));
    }); */
  }

  Future<void> _handleCameraClick() async {
    Get.back();
    GetImage(ImageSource.camera, path: (path, name, xFile) async {
      log('Path Camera : ${path.toString()} name $name');
      isLoading(true);
      await HomeServiceApis.uploadImage(files: [xFile.path]).then((result) async {
        if (result.uploadImage.isNotEmpty) {
          pickedfilePath(result.uploadImage.first);
        }
      }).whenComplete(() => isLoading(false));
    });
  } */

  /* void showBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      backgroundColor: context.cardColor,
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SettingItemWidget(
              title: locale.value.gallery,
              leading: const Icon(Icons.image, color: appColorPrimary),
              onTap: () async {
                _handleGalleryClick();
              },
            ),
            SettingItemWidget(
              title: locale.value.camera,
              leading: const Icon(Icons.camera, color: appColorPrimary),
              onTap: () {
                _handleCameraClick();
              },
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
            ),
          ],
        ).paddingAll(16.0);
      },
    );
  } */
}
