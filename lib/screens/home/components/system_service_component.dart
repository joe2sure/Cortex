import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import '../home_controller.dart';
import 'sys_serv_comp4.dart';
import 'sys_serv_comp1.dart';
import 'sys_serv_comp2.dart';
import 'sys_serv_comp3.dart';

class SystemServicesComponent extends StatelessWidget {
  final HomeController homeController;
  const SystemServicesComponent({super.key, required this.homeController});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      decoration: boxDecorationWithRoundedCorners(
        backgroundColor: isDarkMode.value ? fullDarkCanvasColorDark : appSectionBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          16.height,
          Text(
            locale.value.unlockThePowerOfAi,
            style: primaryTextStyle(size: 20, color: isDarkMode.value ? whiteTextColor : canvasColor, weight: FontWeight.w600),
          ),
          Column(
            children: [
              16.height,
              const SysServComp1(),
              SysServComp2(),
              const SysServComp3(),
              const SysServComp4(),
            ],
          )
        ],
      ).paddingSymmetric(horizontal: 16),
    );
  }
}
