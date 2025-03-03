import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart' hide ResponseMessage;
import 'package:record/record.dart';
import 'package:rive/rive.dart';
import 'package:Cortex/screens/ai_voice_to_text/model/v2t_hist_element.dart';
import 'package:Cortex/utils/constants.dart';
import '../../generated/assets.dart';
import '../../open_ai/openai_apis.dart';
import '../../utils/audio_recorder_io.dart';
import '../../utils/common_base.dart';
import '../home/home_controller.dart';
import '../home/model/history_data_model.dart';
import '../home/services/history_api_service.dart';
import '../home/services/home_api_service.dart';
import '../home/services/system_service_helper.dart';
import 'v2t_result_screen.dart';

class V2TController extends GetxController with AudioRecorderMixin {
  RxBool isLoading = false.obs;

  RxBool voiceAssistantDialogAling = false.obs;
  RxBool onVoiceAssistantDialogOpened = false.obs;

  RxList<RiveAnimationController<dynamic>> riveContList = RxList();
  SMITrigger? listen;
  SMIBool? speakAndListen;
  SMITrigger? listenToIdle;
  bool isSpeaking = false;

  final audioRecorder = AudioRecorder();
  RxString pathOfRecorderding = "".obs;
  Rx<Amplitude> audioAmplitude = Amplitude(current: 0.0, max: 0.0).obs;

  Rx<int> recordDuration = 0.obs;
  Timer? _timer;
  StreamSubscription<RecordState>? _recordSub;
  Rx<RecordState> audioRecordState = RecordState.stop.obs;
  StreamSubscription<Amplitude>? _amplitudeSub;

  Rx<V2THistElement> currentContent = V2THistElement(content: "".obs, title: "".obs).obs;

  //Get History
  Rx<Future<HistoryResponse>> getHistoryResponseFuture = Future(() => HistoryResponse()).obs;
  Rx<HistoryResponse> historyResponse = HistoryResponse().obs;

  RxBool displayGeneratedText = false.obs;

  RxList<PlatformFile> selectedAudiofile = RxList();

  Rx<String> selectedLanguage = Rx<String>('en');

  @override
  void onInit() {
    loadRiveFile();

    _recordSub = audioRecorder.onStateChanged().listen((recordState) {
      _updateRecordState(recordState);
    });

    _amplitudeSub = audioRecorder.onAmplitudeChanged(const Duration(milliseconds: 300)).listen((amp) {
      log('AMP: ${amp.current}---${amp.max}');

      /* if (amp.current.abs() < 30) {
        setSpeakAndListen(true);
      }
      if (amp.current.abs() > 30) {
        setSpeakAndListen(false);
      } */
      audioAmplitude(amp);
    });
    getHistoryList();
    super.onInit();
  }

  void loadRiveFile() async {
    final ByteData data = await rootBundle.load(Assets.riveVoiceAssistantAnimation);
    final RiveFile file = RiveFile.import(data);

    final StateMachineController? stateMachineController = StateMachineController.fromArtboard(
      file.mainArtboard,
      'mic_Interactivity',
      onStateChange: onStateChange,
    );
    if (stateMachineController != null) {
      riveContList.add(stateMachineController);

      listen = stateMachineController.findSMI<SMITrigger>("listen");
      speakAndListen = stateMachineController.findSMI<SMIBool>("speak & listen");
      listenToIdle = stateMachineController.findSMI<SMITrigger>("listen to idle");
    }
  }

  void onStateChange(String artboard, String sm) {
    log('State changed to: $artboard  $sm');
  }

  void startListeningAnimation() {
    if (listen == null) return;
    listen!.fire();
  }

  void setIdle() {
    if (listenToIdle == null) return;
    listenToIdle!.fire();
  }

  void setSpeakAndListen(bool isSpeaking) {
    if (speakAndListen == null) return;
    speakAndListen!.change(isSpeaking);
  }

//--------------------------------OpenAi Api call---------------------

  Future<void> generateTagsAndDescFromImage() async {
    loginPremiumTesterHandler(
      () async {
        setIdle();
        isLoading(true);
        Map<String, dynamic> req = {
          "model": "whisper-1",
        };

        if (selectedLanguage.value.isNotEmpty) req.putIfAbsent("language", () => selectedLanguage.value);

        OpenAiApis.audioTranscriptions(
          filePath: pathOfRecorderding.value,
          type: SystemServiceKeys.aiVoiceToText,
          req: req,
          onSuccess: (res) {
            currentContent.value.content(utf8.decode(latin1.encode(res)));
            Get.to(() => V2TResultScreen(), duration: const Duration(milliseconds: 500));
            generateTitle();
          },
          loaderOff: () {
            isLoading(false);
          },
        ).catchError((e) {
          isLoading(false);
          toast(e.toString(), print: true);
        }).whenComplete(() => isLoading(false));
      },
      checkPremium: true,
      systemService: SystemServiceKeys.aiVoiceToText,
    );
  }

//----------------------------------History----------

  /// Get History APi
  Future<void> getHistoryList({bool showLoader = true}) async {
    if (showLoader) {
      isLoading(true);
    }
    await getHistoryResponseFuture(HistoryServiceApis.getUserHistory(type: SystemServiceKeys.aiVoiceToText)).then((value) {
      historyResponse(value);
    }).catchError((e) {
      log('getHistoryList E: $e');
    }).whenComplete(() => isLoading(false));
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

  Future<void> generateTitle() async {
    try {
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
          Analyze this content ${currentContent.value.content.value} it is a text extracted from audio and generate suitable title.title length must be between 60-70 chars.And in the following JSON format:
          {
            "chat_title": "",
          }
        ''',
          },
        ],
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
          currentContent.value.title(utf8.decode(latin1.encode(chatTitle)));
        }
      }

      //Custom Api for handling History & Usage Calculation
      await HomeServiceApis.saveHistoryApi(
        data: {
          "request_body": req,
          "response_body": currentContent.value.toJson(),
        },
        files: [pathOfRecorderding.value],
        type: SystemServiceKeys.aiVoiceToText,
        wordCount: currentContent.value.content.value.countWords(),
      );

      await getHistoryList();
    } catch (e) {
      dev.log('E: $e');
    }
  }

//----------------------------------audio----------
  Future<void> start() async {
    startListeningAnimation();
    try {
      if (await audioRecorder.hasPermission()) {
        const encoder = AudioEncoder.wav;

        if (!await _isEncoderSupported(encoder)) {
          return;
        }

        final devs = await audioRecorder.listInputDevices();
        log(devs.toString());

        const config = RecordConfig(encoder: encoder, numChannels: 1);

        // Record to file
        await recordFile(audioRecorder, config);

        // Record to stream
        // await recordStream(_audioRecorder, config);

        recordDuration(0);

        _startTimer();
      }
    } catch (e) {
      log(e);
    }
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      recordDuration(recordDuration.value + 1);
    });
  }

  Future<void> stop() async {
    setSpeakAndListen(false);
    setIdle();
    final path = await audioRecorder.stop();
    log('pathOfRecorderding: $path');
    if (path != null) {
      pathOfRecorderding(path);
      generateTagsAndDescFromImage();
    }
  }

  Future<void> pause() => audioRecorder.pause();

  Future<void> resume() => audioRecorder.resume();

  void _updateRecordState(RecordState recordState) {
    audioRecordState(recordState);

    switch (recordState) {
      case RecordState.pause:
        _timer?.cancel();
        break;
      case RecordState.record:
        _startTimer();
        break;
      case RecordState.stop:
        _timer?.cancel();
        recordDuration(0);
        break;
    }
  }

  Future<bool> _isEncoderSupported(AudioEncoder encoder) async {
    final isSupported = await audioRecorder.isEncoderSupported(
      encoder,
    );

    if (!isSupported) {
      log('${encoder.name} is not supported on this platform.');
      log('Supported encoders are:');

      for (final e in AudioEncoder.values) {
        if (await audioRecorder.isEncoderSupported(e)) {
          debugPrint('- ${encoder.name}');
        }
      }
    }

    return isSupported;
  }

  //--------------------------------File picker---------------------
  Future<void> handleFilesPickerClick() async {
    final pickedFiles = await pickFiles(type: FileType.audio);
    if (pickedFiles.isNotEmpty) {
      pathOfRecorderding(pickedFiles.first.path);
      generateTagsAndDescFromImage();
    }
  }

  //--------------------------------AudioPlayer---------------------

  @override
  void onClose() {
    try {
      _timer?.cancel();
      _recordSub?.cancel();
      _amplitudeSub?.cancel();
      audioRecorder.dispose();
    } catch (e) {
      debugPrint('E: $e');
    }
    super.onClose();
  }
}
