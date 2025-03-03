// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../main.dart';
import '../../../utils/view_all_label_component.dart';
import '../art_gen_controller.dart';
import 'style_component.dart';

class ChooseStyleComponent extends StatelessWidget {
  ChooseStyleComponent({super.key});
  final ArtGenController artGenController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ViewAllLabel(
          label: locale.value.chooseStyle,
          isShowAll: false,
        ).paddingOnly(left: 16, right: 8),
        HorizontalList(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: artGenController.imageStyles.length,
          itemBuilder: (context, index) => Obx(
            () => StyleComponent(
              styleTitle: artGenController.imageStyles[index].style,
              isSelected: artGenController.imageStyles[index].id == artGenController.selectedStyle.value.id,
              showBorder: artGenController.imageStyles[index].id == artGenController.selectedStyle.value.id,
              imagePath: artGenController.imageStyles[index].image,
            ).onTap(() {
              artGenController.selectedStyle(artGenController.imageStyles[index]);
            }),
          ),
        ),
      ],
    );
  }
}
