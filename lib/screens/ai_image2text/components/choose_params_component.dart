// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import '../../../utils/view_all_label_component.dart';
import '../ai_img_to_txt_controller.dart';

class ChooseParamsComponent extends StatelessWidget {
  ChooseParamsComponent({super.key});

  final AiImgToTxtController artGenController = Get.find();
  @override
  Widget build(BuildContext context) {
    return AnimatedListView(
      listAnimationType: ListAnimationType.None,
      itemCount: artGenController.choosePrameters.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ViewAllLabel(label: artGenController.choosePrameters[index].title, isShowAll: false).paddingOnly(left: 16, right: 8),
            HorizontalList(
              itemCount: artGenController.choosePrameters[index].options.length,
              spacing: 16,
              runSpacing: 16,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, i) => Obx(
                () => GestureDetector(
                  onTap: () {
                    artGenController.choosePrameters[index].selectedOption(artGenController.choosePrameters[index].options[i]);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: boxDecorationDefault(
                      color: (artGenController.choosePrameters[index].options[i].id == artGenController.choosePrameters[index].selectedOption.value.id).obs.value
                          ? isDarkMode.value
                              ? appColorPrimary
                              : lightPrimaryColor
                          : isDarkMode.value
                              ? fullDarkCanvasColorDark
                              : Colors.grey.shade100,
                    ),
                    child: Text(
                      artGenController.choosePrameters[index].options[i].text,
                      style: secondaryTextStyle(
                        color: (artGenController.choosePrameters[index].options[i].id == artGenController.choosePrameters[index].selectedOption.value.id).obs.value
                            ? isDarkMode.value
                                ? whiteColor
                                : appColorPrimary
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ).paddingTop(16);
      },
    );
  }
}
