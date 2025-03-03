import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/generated/assets.dart';
import 'package:Cortex/screens/ai_image2text/components/img_to_txt_history_widget.dart';
import 'package:Cortex/utils/app_common.dart';
import 'package:Cortex/utils/common_base.dart';
import '../../components/app_scaffold.dart';
import '../../components/title_with_icon_widget.dart';
import '../../main.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../home/services/system_service_helper.dart';
import 'components/choose_params_component.dart';
import 'components/image_prompt_component.dart';
import 'ai_img_to_txt_controller.dart';

class AiImgToTxtScreen extends StatelessWidget {
  AiImgToTxtScreen({super.key});
  final AiImgToTxtController aiImgToTxtController = Get.put(AiImgToTxtController());

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBartitleText: getSystemServicebyKey(type: SystemServiceKeys.aiImageToText).name.isNotEmpty ? getSystemServicebyKey(type: SystemServiceKeys.aiImageToText).name : locale.value.aiImageToText,
      isLoading: aiImgToTxtController.isLoading,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              20.height,
              ImagePromptComponent(),
              ChooseParamsComponent(),
              24.height,
              AppButton(
                height: 52,
                width: Get.width,
                elevation: 0,
                color: appColorSecondary,
                onTap: () {
                  doIfLoggedIn(() {
                    aiImgToTxtController.generateTagsAndDescFromImage();
                  });
                },
                child: TitleWithIconWidget(
                  iconPath: isPremiumUser.value ? "" : Assets.iconsIcVideo,
                  title: isPremiumUser.value ? locale.value.generate : locale.value.watchAnAdToGenerate,
                  iconColor: canvasColor,
                  textColor: canvasColor,
                ),
              ).paddingSymmetric(horizontal: 20, vertical: 30),
              ImgToTxtHistoryWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
