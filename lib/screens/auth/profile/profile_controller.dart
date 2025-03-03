// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../components/bottom_selection_widget.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../dashboard/dashboard_screen.dart';
import '../services/auth_service_apis.dart';

class ProfileController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool hideShow = true.obs;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  void init() {
    getAboutPageData();
  }

  handleLogout() async {
    if (isLoading.value) return;
    isLoading(true);
    log('HANDLELOGOUT: called');
    await AuthServiceApis.logoutApi().then((value) {
      isLoading(false);
    }).catchError((e) {
      toast(e.toString());
    }).whenComplete(() {
      AuthServiceApis.clearData();
      Get.offAll(() => DashboardScreen(), binding: BindingsBuilder(() {
        // Get.put(HomeScreenController());
      }));
    });
  }

  ///Get ChooseService List
  getAboutPageData({bool isFromSwipRefresh = false}) {
    if (!isFromSwipRefresh) {
      isLoading(true);
    }
    isLoading(true);
    AuthServiceApis.getAboutPageData().then((value) {
      isLoading(false);
      aboutPages(value.data);
    }).onError((error, stackTrace) {
      isLoading(false);
      toast(error.toString());
    });
  }

  handleMoreInfoClick(BuildContext context) {
    serviceCommonBottomSheet(
      context,
      child: BottomSelectionSheet(
          title: locale.value.moreInfo,
          titlePaddingLeft: 0,
          closeIconPaddingRight: 0,
          child: Column(
            children: [
              8.height,
              Text(
                locale.value.ifYouExceedYourPlanLimitYouCanStillAccessAllA,
                style: secondaryTextStyle(),
              ),
            ],
          )),
    );
  }
}
