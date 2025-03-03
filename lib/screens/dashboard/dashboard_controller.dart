// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/screens/subscription_plan/sub_scription_plan_controller.dart';
import 'package:Cortex/utils/push_notification_service.dart';
import '../../generated/assets.dart';
import '../../main.dart';
import '../../utils/app_common.dart';
import '../../utils/common_base.dart';
import '../../utils/constants.dart';
import '../../utils/local_storage.dart';
import '../auth/other/settings_screen.dart';
import '../auth/profile/profile_controller.dart';
import '../auth/profile/profile_screen.dart';
import '../auth/services/auth_service_apis.dart';
import '../favourite/fav_screen.dart';
import '../ai_chat/recent_chat_screen.dart';
import '../home/home_screen.dart';
import 'model/menu.dart';
import 'model/rive_model.dart';

class DashboardController extends GetxController {
  RxInt currentIndex = 0.obs;
  RxBool isLoading = false.obs;

  RxList<RMenu> bottomNavItems = [
    RMenu(
      title: locale.value.home,
      rive: RiveModel(src: Assets.riveBottombarIcons, artboard: "HOME", stateMachineName: "HOME_interactivity"),
    ),
    RMenu(
      title: locale.value.favorites,
      rive: RiveModel(src: Assets.riveBottombarIcons, artboard: "LIKE/STAR", stateMachineName: "STAR_Interactivity"),
    ),
    RMenu(
      title: locale.value.aiChat,
      rive: RiveModel(src: Assets.riveBottombarIcons, artboard: "CHAT", stateMachineName: "CHAT_Interactivity"),
    ),
  ].obs;

  // ReactiveController to update UI when isLoggedIn changes
  // final ReactiveController loginStatusController = ReactiveController();

  Rx<RMenu> selectedBottonNav = RMenu(
    title: locale.value.home,
    rive: RiveModel(src: Assets.riveBottombarIcons, artboard: "HOME", stateMachineName: "HOME_interactivity"),
  ).obs;

  RxList<StatelessWidget> screen = [
    HomeScreen(),
    FavouriteScreen(),
    RecentChatScreen(isFromBottomTab: true),
  ].obs;

  @override
  void onInit() {
    if (!isLoggedIn.value) {
      ProfileController().getAboutPageData();
    }
    PushNotificationService().registerFCMandTopics();
    getAppConfigurations(isFromDashboard: true).then((value) {
      Future.delayed(const Duration(seconds: 2), () {
        if (Get.context != null) {
          showForceUpdateDialog(Get.context!);
        }
      });
    });
    fetchRemoteConfigValues();
    super.onInit();
  }

  @override
  void onReady() {
    if (bottomNavItems.isNotEmpty) {
      selectedBottonNav(bottomNavItems.first);
    }
    reloadBottomTabs();
    if (Get.context != null) {
      View.of(Get.context!).platformDispatcher.onPlatformBrightnessChanged = () {
        WidgetsBinding.instance.handlePlatformBrightnessChanged();
        try {
          final getThemeFromLocal = getValueFromLocal(SettingsLocalConst.THEME_MODE);
          if (getThemeFromLocal is int) {
            toggleThemeMode(themeId: getThemeFromLocal);
          }
        } catch (e) {
          log('getThemeFromLocal from cache E: $e');
        }
      };
    }
    super.onReady();
  }

  void reloadBottomTabs() {
    debugPrint('reloadBottomTabs ISLOGGEDIN.VALUE: ${isLoggedIn.value}');
    if (isLoggedIn.value) {
      screen.removeWhere((element) => element is SettingScreen);
      if (bottomNavItems.indexWhere((element) => element is ProfileScreen).isNegative) {
        screen.add(ProfileScreen());
      }
      screen.toSet();

      bottomNavItems.removeWhere((element) => element.rive.stateMachineName.contains("SETTINGS_Interactivity"));
      if (bottomNavItems.indexWhere((element) => element.rive.stateMachineName.contains("USER_Interactivity")).isNegative) {
        bottomNavItems.add(RMenu(
          title: locale.value.profile,
          rive: RiveModel(src: Assets.riveBottombarIcons, artboard: "USER", stateMachineName: "USER_Interactivity"),
        ));
      }
      bottomNavItems.toSet();
    } else {
      screen.removeWhere((element) => element is ProfileScreen);
      screen.add(SettingScreen());
      screen.toSet();

      bottomNavItems.removeWhere((element) => element.rive.stateMachineName.contains("USER_Interactivity"));
      bottomNavItems.add(RMenu(
        title: locale.value.settings,
        rive: RiveModel(src: Assets.riveBottombarIcons, artboard: "SETTINGS", stateMachineName: "SETTINGS_Interactivity"),
      ));
      bottomNavItems.toSet();
    }
    selectedBottonNav(bottomNavItems[currentIndex.value]);
  }
}

Future<void> getPlanList() async {
  try {
    PlanController planController = Get.put(PlanController());
    planController.getPlanList(showLoader: false);
  } catch (e) {
    debugPrint('getPlanList E: $e');
  }
}

///Get ChooseService List
Future<void> getAppConfigurations({bool isFromDashboard = false, bool forceSync = false}) async {
  await AuthServiceApis.getAppConfigurations(forceConfigSync: forceSync).onError((error, stackTrace) {
    toast(error.toString());
  });
}
