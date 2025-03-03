import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants.dart';
import '../home_controller.dart';
import '../service_card.dart';
import '../services/system_service_helper.dart';

class TagAndDescGenComponent extends StatelessWidget {
  TagAndDescGenComponent({super.key});
  final HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        /// Navigate to specific screen
        navigateToService(serviceType: SystemServiceKeys.aiImageToText);
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: 102,
        width: Get.width,
        decoration: boxDecorationWithRoundedCorners(backgroundColor: appColorPrimary, borderRadius: BorderRadius.circular(10)),
        child: ServiceCard(serviceItem: getSystemServicebyKey(type: SystemServiceKeys.aiImageToText)),
      ),
    );
  }
}
