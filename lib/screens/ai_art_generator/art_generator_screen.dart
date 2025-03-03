import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/generated/assets.dart';
import 'package:Cortex/utils/app_common.dart';
import 'package:Cortex/utils/common_base.dart';
import '../../components/app_scaffold.dart';
import '../../components/title_with_icon_widget.dart';
import '../../main.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../home/services/system_service_helper.dart';
import 'art_gen_controller.dart';
import 'components/choose_ratio_component.dart';
import 'components/choose_style_component.dart';
import 'components/prompt_component.dart';
import 'components/art_gen_history_widget.dart';

class ArtGeneratorMainScreen extends StatelessWidget {
  ArtGeneratorMainScreen({super.key});
  final ArtGenController artGenController = Get.put(ArtGenController());

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBartitleText: getSystemServicebyKey(type: SystemServiceKeys.aiArtGenerator).name.isNotEmpty ? getSystemServicebyKey(type: SystemServiceKeys.aiArtGenerator).name : 'AI Art Generation',
      isLoading: artGenController.isLoading,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            PromptComponent(),
            16.height,
            ChooseRatioComponent(),
            16.height,
            ChooseStyleComponent(),
            24.height,
            AppButton(
                height: 52,
                width: Get.width,
                elevation: 0,
                color: appColorSecondary,
                onTap: () {
                  doIfLoggedIn(() {
                    artGenController.shouldOpenImg(true);
                    hideKeyboard(context);
                    artGenController.handleClickArtGen();
                  });
                },
                child: TitleWithIconWidget(
                  iconPath: isPremiumUser.value ? "" : Assets.iconsIcVideo,
                  title: isPremiumUser.value ? locale.value.generate : locale.value.watchAnAdToGenerate,
                  iconColor: canvasColor,
                  textColor: canvasColor,
                )).paddingSymmetric(horizontal: 20, vertical: 30),
            ArtGenHistoryWidget()
          ],
        ),
      )),
    );
  }
}
