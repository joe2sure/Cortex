// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../../utils/view_all_label_component.dart';
import '../art_gen_controller.dart';

class ChooseRatioComponent extends StatelessWidget {
  ChooseRatioComponent({super.key});

  final ArtGenController artGenController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ViewAllLabel(label: locale.value.chooseSize, isShowAll: false).paddingOnly(left: 16, right: 8),
        HorizontalList(
          itemCount: artGenController.supportedSizes.length,
          spacing: 16,
          runSpacing: 16,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) => Obx(
            () => GestureDetector(
              onTap: () {
                artGenController.selectedImgSize(artGenController.supportedSizes[index]);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: boxDecorationDefault(
                  color: artGenController.supportedSizes[index].id == artGenController.selectedImgSize.value.id ? lightPrimaryColor : context.cardColor,
                ),
                child: Text(
                  artGenController.supportedSizes[index].size,
                  style: secondaryTextStyle(
                    color: artGenController.supportedSizes[index].id == artGenController.selectedImgSize.value.id ? appColorPrimary : null,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
