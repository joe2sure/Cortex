import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/screens/home/services/system_service_helper.dart';
import 'package:Cortex/utils/colors.dart';
import 'package:Cortex/utils/constants.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../ai_writer/content_generator.dart';
import '../home_controller.dart';
import 'template_component.dart';

class HomeTemplatesComponent extends StatelessWidget {
  final HomeController homeController;

  const HomeTemplatesComponent({super.key, required this.homeController});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => homeController.dashboardData.value.customTemplate.isEmpty
          ? const Offstage()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      locale.value.templates,
                      style: primaryTextStyle(size: 18, color: isDarkMode.value ? Colors.white : primaryTextColor),
                    ).paddingSymmetric(horizontal: 16),
                    GestureDetector(
                      onTap: () {
                         navigateToService(serviceType: SystemServiceKeys.aiWriter);
                      },
                      child: Text(
                        locale.value.viewAll,
                        style: secondaryTextStyle(color: isDarkMode.value ? Colors.white : primaryTextColor),
                      ).paddingSymmetric(horizontal: 16),
                    ),
                  ],
                ),
                16.height,
                HorizontalList(
                  itemCount: homeController.dashboardData.value.customTemplate.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return TemplateComponent(
                      isLoading: homeController.isLoading,
                      customTemplate: homeController.dashboardData.value.customTemplate[index].obs,
                      onTapCard: () {
                        Get.to(() => ContentGenScreen(), arguments: homeController.dashboardData.value.customTemplate[index]);
                      },
                    ).paddingOnly(right: index < 4 ? 8 : 16, left: index > 0 ? 8 : 18);
                  },
                )
              ],
            ).paddingOnly(bottom: 24, top: 8),
    );
  }
}
