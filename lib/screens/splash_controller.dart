// ignore_for_file: depend_on_referenced_packages

import 'dart:ui';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/screens/auth/services/auth_service_apis.dart';
import 'package:Cortex/screens/walkthrough/walkthrough_screen.dart';
import 'package:Cortex/utils/app_common.dart';
import 'package:Cortex/utils/colors.dart';
import 'package:Cortex/utils/local_storage.dart';
import '../utils/constants.dart';
import 'auth/model/login_response.dart';
import 'dashboard/dashboard_screen.dart';
import 'home/home_controller.dart';

class SplashScreenController extends GetxController {
  /*  late AppLifecycleReactor _appLifecycleReactor;
  AppOpenAdManager appOpenAdManager = AppOpenAdManager(); */

  @override
  void onInit() {
    super.onInit();
    getPackageInfo().then((value) => currentPackageinfo(value));
    // _appLifecycleReactor = AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
    // _appLifecycleReactor.listenToAppStateChanges();
  }

  @override
  void onReady() {
    super.onReady();
    init();
  }

  void init() {
    AuthServiceApis.getAppConfigurations(forceConfigSync: true).onError((error, stackTrace) {
      toast(error.toString());
    }).whenComplete(() => navigationLogic());
  }

  void navigationLogic() {
    if ((getValueFromLocal(SharedPreferenceConst.FIRST_TIME) ?? false) == false) {
      Get.offAll(() => WalkthroughScreen(), binding: BindingsBuilder(() {
        setStatusBarColor(canvasColor, statusBarIconBrightness: Brightness.light, statusBarBrightness: Brightness.light);
      }));
    } else if (getValueFromLocal(SharedPreferenceConst.IS_LOGGED_IN) == true) {
      setStatusBarColor(transparentColor, statusBarIconBrightness: Brightness.light, statusBarBrightness: Brightness.light);
      try {
        final userData = getValueFromLocal(SharedPreferenceConst.USER_DATA);
        isLoggedIn(true);
        loginUserData(UserData.fromJson(userData));
        Get.offAll(() => DashboardScreen(), binding: BindingsBuilder(() {
          Get.put(HomeController());
        }));
      } catch (e) {
        log('SplashScreenController Err: $e');
        Get.offAll(() => DashboardScreen(), binding: BindingsBuilder(() {
          Get.put(HomeController());
        }));
      }
    } else {
      Get.offAll(() => DashboardScreen(), binding: BindingsBuilder(() {
        Get.put(HomeController());
      }));
    }
  }
}
