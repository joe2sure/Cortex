import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/utils/common_base.dart';

import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/constants.dart';
import '../../ai_art_generator/art_generator_screen.dart';
import '../../ai_chat/recent_chat_controller.dart';
import '../../ai_voice_to_text/v2t_screen.dart';
import '../../ai_writer/ai_writer_screen.dart';
import '../../ai_writer/content_generator.dart';
import '../../ai_image/ai_image_screen.dart';
import '../../ai_image2text/ai_img_to_txt_screen.dart';
import '../../ai_chat/recent_chat_screen.dart';
import '../model/home_detail_res.dart';

RxList<SystemService> serviceList = RxList();

SystemService getSystemServicebyKey({required String type}) {
  return serviceList.firstWhere((element) => element.type.toLowerCase() == type.toLowerCase(), orElse: () => SystemService());
}

void navigateToService({required String serviceType, dynamic arguments}) {
  if (serviceType.toLowerCase() == SystemServiceKeys.aiArtGenerator) {
    Get.to(() => ArtGeneratorMainScreen(), arguments: arguments);
  } else if (serviceType.toLowerCase() == SystemServiceKeys.aiImage) {
    Get.to(() => AiImageScreen(), arguments: arguments);
  } else if (serviceType.toLowerCase() == SystemServiceKeys.aiCode) {
    Get.to(() => ContentGenScreen(), arguments: arguments);
  } else if (serviceType.toLowerCase() == SystemServiceKeys.aiChat) {
    Get.to(() => RecentChatScreen(), arguments: arguments, binding: BindingsBuilder(() {
      try {
        RecentChatController rCont = Get.find();
        rCont.page(1);
        rCont.recentChatList();
      } catch (e) {
        log('navigateToService rCont = Get.find() Err: $e');
      }
    }));
  } else if (serviceType.toLowerCase() == SystemServiceKeys.aiImageToText) {
    Get.to(() => AiImgToTxtScreen(), arguments: arguments);
  } else if (serviceType.toLowerCase() == SystemServiceKeys.aiWriter) {
    Get.to(() => AiWriterScreen(), arguments: arguments);
  } else if (serviceType.toLowerCase() == SystemServiceKeys.aiVoiceToText) {
    Get.to(() => V2TScreen(), arguments: arguments);
  }
}

Future<void> loginPremiumTesterHandler(
  VoidCallback callback, {
  bool checkLogin = false,
  bool checkPremium = false,
  bool checkIsTestUser = false,
  required String systemService,
  String? category,
}) async {
  if (checkPremium || checkIsTestUser) {
    checkLogin = true;
  }
  // Check if login status should be verified
  if (checkLogin) {
    // Execute callback only if the user is logged in
    doIfLoggedIn(() async {
      // Check if the user is a test user with default email
      if (checkIsTestUser && loginUserData.value.email == Constants.DEFAULT_EMAIL) {
        // Notify the user that demo user privileges cannot be granted
        toast(locale.value.demoUserCannotBeGrantedForThis);
      }
      // Check if premium content access is required and user is not premium
      else if (checkPremium) {
        // Prompt the user to subscribe to access premium content
        await ifNotSubscribed(callback, systemService: systemService, category: category);
      }
      // If all conditions pass, execute the callback
      else {
        callback();
      }
    });
  }
  // If login status verification is not required
  else {
    callback();
  }
}
