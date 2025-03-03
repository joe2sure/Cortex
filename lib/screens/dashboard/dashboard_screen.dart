import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/screens/ai_chat/recent_chat_controller.dart';
import 'package:Cortex/screens/favourite/fav_controller.dart';
import 'package:Cortex/utils/app_common.dart';
import '../../main.dart';
import '../../utils/colors.dart';
import '../../utils/common_base.dart';
import '../../utils/rive_utils.dart';
import '../home/home_controller.dart';
import 'components/btm_nav_item.dart';
import 'dashboard_controller.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});
  final DashboardController dashboardController = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return DoublePressBackWidget(
      message: locale.value.pressBackAgainToExitApp,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Obx(
              () => dashboardController.screen[dashboardController.currentIndex.value],
            ),
            Obx(
              () => Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.only(left: 32, top: 8, right: 32, bottom: 6),
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: canvasColor.withOpacity(0.9),
                    borderRadius: const BorderRadius.all(Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(
                        color: canvasColor.withOpacity(0.3),
                        offset: const Offset(0, 20),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ...List.generate(
                        dashboardController.bottomNavItems.length,
                        (index) {
                          return BtmNavItem(
                            navBar: dashboardController.bottomNavItems[index],
                            press: () {
                              if (!isLoggedIn.value && (index == 1 || index == 2)) {
                                doIfLoggedIn(() {
                                  handleChangeTabIndex(index);
                                });
                              } else {
                                handleChangeTabIndex(index);
                              }
                            },
                            riveOnInit: (artboard) {
                              log('RIVEONINIT: called');
                              dashboardController.bottomNavItems[index].rive.status = RiveUtils.getRiveInput(artboard, stateMachineName: dashboardController.bottomNavItems[index].rive.stateMachineName);
                            },
                            selectedNav: dashboardController.selectedBottonNav.value,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ).paddingBottom(16),
            ).visible(!dashboardController.isLoading.value)
          ],
        ),
        extendBody: true,
      ),
    );
  }

  void handleChangeTabIndex(int index) {
    if (dashboardController.bottomNavItems[index].rive.status != null) {
      RiveUtils.chnageSMIBoolStatefor1Sec(dashboardController.bottomNavItems[index].rive.status!);
      log('RIVEONINIT.chnageSMIBoolState: called');
    }
    dashboardController.selectedBottonNav(dashboardController.bottomNavItems[index]);
    dashboardController.currentIndex(index);
    try {
      if (index == 0 || (index == 3 && isLoggedIn.value)) {
        HomeController hCont = Get.find();
        hCont.getDashboardDetail(showLoader: false);
      } else if (isLoggedIn.value && index == 1) {
        FavController favCont = Get.find();
        favCont.favouriteTemplateList(showLoader: false);
      } else if (index == 2) {
        RecentChatController rcCont = Get.find();
        rcCont.recentChatList(showLoader: false);
      }
    } catch (e) {
      log('onItemSelected Err: $e');
    }
  }
}
