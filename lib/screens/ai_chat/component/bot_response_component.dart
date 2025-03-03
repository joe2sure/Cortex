import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/generated/assets.dart';
import 'package:Cortex/utils/common_base.dart';

import '../../../open_ai/models/gpt_model.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants.dart';
import '../../home/model/messages_res.dart';
import '../ai_chat_controller.dart';
import 'icon_with_bg.dart';

class BotResponseComponent extends StatelessWidget {
  final Widget child;
  final Function() onRegeneratePressed;
  final Function() onSpeakerPressed;
  final Function() onCopyPressed;
  final Function() modelSelectClick;
  final MessegeElement answer;

  BotResponseComponent({
    super.key,
    required this.child,
    required this.onRegeneratePressed,
    required this.onSpeakerPressed,
    required this.onCopyPressed,
    required this.modelSelectClick,
    required this.answer,
  });

  final AiChatController aiChatController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: boxDecorationWithRoundedCorners(
              backgroundColor: isDarkMode.value ? colorPrimaryBlack : lightPrimaryColor,
              border: Border.all(color: isDarkMode.value ? borderColorDark : borderColor, width: 0.5),
              borderRadius: const BorderRadius.only(bottomRight: Radius.circular(8), topRight: Radius.circular(8), bottomLeft: Radius.circular(8)),
            ),
            child: child.paddingAll(14),
          ).paddingBottom(20),
          Positioned(
            bottom: answer.showModelSelection.value ? 0 : -(Get.height * 0.2 + 16),
            right: 0,
            left: 0,
            child: ClipRect(
              // <-- clips to the 200x200 [Container] below
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 5.0,
                  sigmaY: 5.0,
                ),
                child: Container(
                  alignment: Alignment.center,
                  width: Get.width,
                  height: Get.height * 0.2,
                ),
              ),
            ).paddingSymmetric(horizontal: 8),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Row(
              children: [
                Obx(
                  () => GestureDetector(
                    onTap: modelSelectClick,
                    behavior: HitTestBehavior.translucent,
                    child: Container(
                        height: 28,
                        decoration: boxDecorationWithRoundedCorners(
                          backgroundColor: isDarkMode.value ? fullDarkCanvasColorDark : appSectionBackground,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: isDarkMode.value ? borderColorDark : borderColor, width: 0.3),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              answer.selectedModel.value.icon,
                              color: appColorPrimary,
                            ).paddingAll(7),
                            Text(
                              answer.selectedModel.value.shortName,
                              style: secondaryTextStyle(),
                            ).paddingRight(7),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              color: secondaryTextColor,
                              size: 16,
                            ).paddingRight(7),
                          ],
                        )),
                  ),
                ),
                6.width,
                ...List.generate(
                  chatBotIconList.length,
                  (index) => Row(
                    children: [
                      IconWithBGWidget(
                        iconPath: chatBotIconList[index],
                        bgColor: isDarkMode.value ? fullDarkCanvasColorDark : appSectionBackground,
                        onPressed: index == 0
                            ? onRegeneratePressed
                            : index == 1
                                ? onSpeakerPressed
                                : onCopyPressed,
                      ),
                      index == 2 ? 11.width : 6.width,
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 25,
            right: 0,
            left: 0,
            child: Obx(
              () => AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                alignment: Alignment.center,
                height: answer.showModelSelection.value ? null : 0,
                width: answer.showModelSelection.value ? null : 0,
                margin: EdgeInsets.symmetric(horizontal: Get.width * 0.12),
                padding: const EdgeInsets.all(8),
                decoration: boxDecorationWithRoundedCorners(
                  backgroundColor: isDarkMode.value ? fullDarkCanvasColorDark : appSectionBackground,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: isDarkMode.value ? borderColorDark : borderColor, width: 0.3),
                ),
                child: Column(
                  children: List.generate(
                    gptModels.length,
                    (index) => ModelCardWidget(
                      gptModel: gptModels[index],
                      isSelected: (answer.selectedModel.value.id == gptModels[index].id).obs,
                      onTap: () {
                        answer.showModelSelection(!answer.showModelSelection.value);
                        answer.currentModel(gptModels[index]);
                        onRegeneratePressed.call();
                      },
                    ).paddingOnly(bottom: index == gptModels.length - 1 ? 0 : 8),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ModelCardWidget extends StatelessWidget {
  final GPTModel gptModel;
  final void Function()? onTap;
  final RxBool isSelected;

  ModelCardWidget({
    super.key,
    required this.gptModel,
    required this.onTap,
    required this.isSelected,
  });

  final AiChatController aiChatController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.translucent,
        child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(4),
            decoration: boxDecorationWithRoundedCorners(
              backgroundColor: isDarkMode.value ? lightCanvasColor : appSectionBackground,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: isDarkMode.value ? borderColorDark : borderColor, width: 0.3),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                commonLeadingWid(
                  imgPath: gptModel.icon,
                  color: appColorPrimary,
                ).paddingAll(8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      gptModel.title,
                      style: primaryTextStyle(size: 12),
                    ),
                    Text(
                      gptModel.desc,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: secondaryTextStyle(size: 10),
                    ),
                  ],
                ).paddingRight(8),
                (isSelected.value
                        ? Lottie.asset(
                            Assets.lottieCheck,
                            fit: BoxFit.cover,
                            height: 20,
                            width: 20,
                            repeat: false,
                          )
                        : Icon(Icons.circle_outlined, size: 18, color: appColorSecondary.withOpacity(0.4)))
                    .paddingRight(8)
              ],
            )),
      ),
    );
  }
}
