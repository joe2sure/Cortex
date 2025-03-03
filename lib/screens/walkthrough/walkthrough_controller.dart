// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../generated/assets.dart';
import '../../main.dart';
import '../../utils/colors.dart';
import '../auth/other/welcome_screen.dart';
import 'model/walkthrough_model.dart';
import '../../utils/constants.dart';
import '../../utils/local_storage.dart';

class WalkthroughController extends GetxController {
  PageController pageController = PageController();

  RxInt currentPage = 0.obs;

  List<WalkThroughElementModel> walkthroughDetails = [
    WalkThroughElementModel(image: Assets.imagesWalkthrough1, title: locale.value.empoweringNyourTomorrowsNworld),
    WalkThroughElementModel(image: Assets.imagesWalkthrough2, title: locale.value.smartFeaturesNunleashingAiNpotential),
    WalkThroughElementModel(image: Assets.imagesWalkthrough3, title: locale.value.innovaMindAiAtNredefiningNintelligence),
  ];

  @override
  void onInit() {
    setValueToLocal(SharedPreferenceConst.FIRST_TIME, true);
    super.onInit();
  }

  void handleNext() {
    pageController.nextPage(duration: const Duration(milliseconds: 100), curve: Curves.bounceIn);
    if (currentPage.value == (walkthroughDetails.length - 1)) {
      Get.offAll(() => WelcomeScreen(), binding: BindingsBuilder(() {
        if (Get.context != null) {
          setStatusBarColor(canvasColor, statusBarIconBrightness: Brightness.light, statusBarBrightness: Brightness.light);
        }
      }));
    }
  }

  void handleSkip() {
    Get.offAll(() => WelcomeScreen(), binding: BindingsBuilder(() {
      if (Get.context != null) {
        setStatusBarColor(canvasColor, statusBarIconBrightness: Brightness.light, statusBarBrightness: Brightness.light);
      }
    }));
  }

  @override
  void onClose() {
    if (Get.context != null) {
      setStatusBarColor(canvasColor, statusBarIconBrightness: Brightness.light, statusBarBrightness: Brightness.light);
    }
    super.onClose();
  }
}
