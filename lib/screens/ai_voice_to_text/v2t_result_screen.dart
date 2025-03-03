import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:Cortex/screens/ai_voice_to_text/v2t_gen_controller.dart';
import 'package:Cortex/utils/common_base.dart';

import '../../components/app_scaffold.dart';
import '../../components/title_with_icon_widget.dart';
import '../../generated/assets.dart';
import '../../main.dart';
import '../../utils/app_common.dart';
import '../../utils/colors.dart';

class V2TResultScreen extends StatelessWidget {
  V2TResultScreen({super.key});

  final V2TController v2TController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppScaffold(
        appBartitleText: locale.value.back,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(locale.value.title, style: boldTextStyle()),
                  8.height,
                  Container(
                    width: Get.width,
                    decoration: boxDecorationWithRoundedCorners(
                      backgroundColor: isDarkMode.value ? colorPrimaryBlack : lightPrimaryColor,
                      border: Border.all(color: isDarkMode.value ? borderColorDark : borderColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Hero(
                      tag: v2TController.currentContent.value.title.value.formattedHeroTag,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        width: Get.width,
                        child: Obx(
                          () => Markdown(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            selectable: true,
                            data: v2TController.currentContent.value.title.value.replaceAll('\\n', '\n'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  16.height,
                  Text(locale.value.content, style: boldTextStyle()),
                  8.height,
                  Container(
                    width: Get.width,
                    decoration: boxDecorationWithRoundedCorners(
                      backgroundColor: isDarkMode.value ? colorPrimaryBlack : lightPrimaryColor,
                      border: Border.all(color: isDarkMode.value ? borderColorDark : borderColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Hero(
                      tag: v2TController.currentContent.value.content.value.formattedHeroTag,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        width: Get.width,
                        child: Obx(
                          () => Markdown(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            selectable: true,
                            data: v2TController.currentContent.value.content.value.replaceAll('\\n', '\n'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ).paddingSymmetric(horizontal: 16),
            ).paddingBottom(70),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppButton(
                    width: Get.width,
                    elevation: 0,
                    color: appColorSecondary,
                    onTap: () {
                      v2TController.currentContent.value.content.value.replaceAll('\\n', '\n').copyToClipboard().then((value) => toast(locale.value.copied));
                    },
                    child: TitleWithIconWidget(
                      iconPath: Assets.iconsIcCopy,
                      title: locale.value.copy,
                      iconColor: canvasColor,
                      textColor: canvasColor,
                    ),
                  ).expand(),
                  16.width,
                  AppButton(
                    width: Get.width,
                    elevation: 0,
                    color: canvasColor,
                    onTap: () {
                      Share.share(v2TController.currentContent.value.content.value.replaceAll('\\n', '\n'));
                    },
                    child: TitleWithIconWidget(
                      iconPath: Assets.iconsIcShare,
                      title: locale.value.share,
                      iconColor: Colors.white,
                      textColor: Colors.white,
                    ),
                  ).expand(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
