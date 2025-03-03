import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:Cortex/main.dart';
import 'package:Cortex/screens/ai_writer/content_gen_controller.dart';
import 'package:Cortex/utils/common_base.dart';
import '../../components/app_scaffold.dart';
import '../../components/title_with_icon_widget.dart';
import '../../generated/assets.dart';
import '../../utils/app_common.dart';
import '../../utils/colors.dart';

class GenerateResultScreen extends StatelessWidget {
  GenerateResultScreen({super.key, this.title});
  final String? title;

  final ContentGenController contentGenController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) {},
        child: AppScaffold(
          appBartitleText: contentGenController.currentContent.value.title.value.isNotEmpty ? contentGenController.currentContent.value.title.value : title,
          body: Stack(
            children: [
              SingleChildScrollView(
                controller: contentGenController.scrollController,
                child: Container(
                  width: Get.width,
                  decoration: boxDecorationWithRoundedCorners(
                    backgroundColor: isDarkMode.value ? colorPrimaryBlack : lightPrimaryColor,
                    border: Border.all(color: isDarkMode.value ? borderColorDark : borderColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Hero(
                    tag: contentGenController.currentContent.value.content.value.formattedHeroTag,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      width: Get.width,
                      child: Obx(
                        () => Markdown(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          selectable: true,
                          data: contentGenController.currentContent.value.content.value.replaceAll('\\n', '\n'),
                        ),
                      ),
                    ),
                  ),
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
                        contentGenController.currentContent.value.content.value.replaceAll('\\n', '\n').copyToClipboard().then((value) => toast(locale.value.copied));
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
                        Share.share(contentGenController.currentContent.value.content.value.replaceAll('\\n', '\n'));
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
      ),
    );
  }
}
