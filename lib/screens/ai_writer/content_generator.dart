import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/utils/app_common.dart';
import 'package:Cortex/utils/common_base.dart';
import '../../components/app_scaffold.dart';
import '../../components/dynamic_inputs_with_rest.dart';
import '../../components/title_with_icon_widget.dart';
import '../../generated/assets.dart';
import '../../main.dart';
import '../../utils/colors.dart';
import 'content_gen_controller.dart';
import 'components/content_history_widget.dart';

class ContentGenScreen extends StatelessWidget {
  ContentGenScreen({super.key});

  final ContentGenController contentGenController = Get.put(ContentGenController());

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBartitleText: contentGenController.templateData.value.templateName.trim().isNotEmpty ? contentGenController.templateData.value.templateName.trim() : locale.value.contentGenerator,
      isLoading: contentGenController.isLoading,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 16),
          physics: const AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(key: contentGenController.contentFormKey, child: DynamicInputsWidget(inputTypes: contentGenController.templateData.value.userinputList)),
              AppButton(
                height: 52,
                width: Get.width,
                elevation: 0,
                color: appColorSecondary,
                onTap: () {
                  doIfLoggedIn(() {
                    hideKeyboard(context);
                    if (contentGenController.contentFormKey.currentState!.validate()) {
                      contentGenController.contentFormKey.currentState!.save();
                      if (contentGenController.templateData.value.userinputList.first.nameCont.text.isEmpty) {
                        toast("Please select programing language"); //TODO String Translation
                      } else {
                        contentGenController.isLoading(true);
                        contentGenController.generateContent(contentGenController.templateData.value.userinputList.first.nameCont.text);
                      }
                    }
                  });
                },
                child: TitleWithIconWidget(
                  iconPath: isPremiumUser.value ? "" : Assets.iconsIcVideo,
                  title: isPremiumUser.value ? locale.value.generate : locale.value.watchAnAdToGenerate,
                  iconColor: canvasColor,
                  textColor: canvasColor,
                ),
              ).paddingSymmetric(horizontal: 20, vertical: 30),
              ContentHistoryWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
