import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:Cortex/utils/app_common.dart';
import '../../main.dart';
import '../home/model/recent_chat_res.dart';
import '../home/services/history_api_service.dart';
import 'chat_screen.dart';
import 'model/explore_more_model.dart';

class RecentChatController extends GetxController {
  Rx<Future<RxList<RecentChatElement>>> getRecentChatsResponseFuture = Future(() => RxList<RecentChatElement>()).obs;
  RxList<RecentChatElement> recentChats = RxList();
  RxBool isLastPage = false.obs;
  RxBool isLoading = false.obs;
  RxInt page = 1.obs;

  SpeechToText speech = SpeechToText();
  RxString lastWords = ''.obs;
  RxString lastError = ''.obs;
  RxString lastStatus = ''.obs;
  RxBool speechStatus = false.obs;

  List<ExploreMoreModel> exploreMoreList = getExploreMoreList();

  @override
  void onInit() {
    recentChatList();
    super.onInit();
  }

  Future<void> recentChatList({bool showLoader = true}) async {
    if (isLoggedIn.value) {
      if (showLoader) {
        isLoading(true);
      }
      await getRecentChatsResponseFuture(
        HistoryServiceApis.getRecentChats(
          recentChats: recentChats,
          page: page.value,
          lastPageCallBack: (p0) {
            isLastPage(p0);
          },
        ),
      ).then((res) {}).catchError((e) {
        log('recentChatList E: $e');
      }).whenComplete(() => isLoading(false));
    }
  }

  Future<void> editTitle({required RecentChatElement recentChatElement}) async {
    isLoading(true);
    await HistoryServiceApis.addEditRecentChats(
      request: {
        "chat_id": recentChatElement.id,
        "title": recentChatElement.editCont.text.trim(),
      },
      isEdit: true,
    ).then((res) {}).catchError((e) {
      log('addEditRecentChats E: $e');
    }).whenComplete(() => isLoading(false));
    // Saving the generated chat title
  }

  Future<void> deleteChat({required int chatId}) async {
    isLoading(true);
    await HistoryServiceApis.deleteRecentChats(chatId: chatId).then((res) {
      toast(locale.value.chatRemoved);
      recentChats.removeWhere((element) => element.id == chatId);
    }).catchError((e) {
      toast(e.toString());
      log('deleteRecentChats E: $e');
    }).whenComplete(() => isLoading(false));
    // Saving the generated chat title
  }

  //----------------------------------Speech To Text-------------------------------
  void startListening() async {
    bool available = await speech.initialize(onStatus: statusListener, onError: errorListener);

    if (available) {
      if (isAndroid) speech.listen(onResult: resultListener);

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

  void resultListener(SpeechRecognitionResult result) {
    lastWords(result.recognizedWords);
    if (result.finalResult) {
      speechStatus(false);
      stopListening();
      Get.to(() => ChatScreen(), arguments: lastWords.value);
    }
    log("LastWords: $lastWords");
  }

  void errorListener(SpeechRecognitionError error) {
    speechStatus(false);
    lastError('${error.errorMsg} - ${error.permanent}');
    log("lastError: $lastError");
  }

  void stopListening() async {
    await speech.stop();
  }

  void statusListener(String status) {
    lastStatus(status);
    log("lastStatus: $lastStatus");

    if (status.toLowerCase().trim() == 'done') {
      speechStatus(false);
    }
  }
}
