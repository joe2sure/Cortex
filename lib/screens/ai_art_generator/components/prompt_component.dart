import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import '../../../utils/view_all_label_component.dart';
import '../art_gen_controller.dart';

class PromptComponent extends StatelessWidget {
  PromptComponent({super.key});

  final ArtGenController artGenController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ViewAllLabel(label: locale.value.enterPrompt, isShowAll: false).paddingOnly(right: 8),
        AppTextField(
          textFieldType: TextFieldType.MULTILINE,
          controller: artGenController.promptCont,
          focus: artGenController.promptFocus,
          minLines: 6,
          cursorColor: appColorPrimary,
          decoration: inputDecoration(
            context,
            labelText: locale.value.typeAnything,
            borderRadius: 4,
            fillColor: context.cardColor,
            filled: true,
          ),
        )
      ],
    ).paddingSymmetric(horizontal: 16);
  }
}
