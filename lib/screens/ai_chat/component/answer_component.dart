import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/generated/assets.dart';

import '../../home/model/messages_res.dart';
import 'bot_response_component.dart';

class AnswerComponent extends StatelessWidget {
  final Function() onRegeneratePressed;
  final Function() onSpeakerPressed;
  final Function() onCopyPressed;
  final Function() modelSelectClick;
  final MessegeElement answer;

  const AnswerComponent({
    super.key,
    required this.onRegeneratePressed,
    required this.onSpeakerPressed,
    required this.onCopyPressed,
    required this.modelSelectClick,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 30,
          width: 30,
          decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle),
          child: Image.asset(
            Assets.iconsIcChatbot,
            width: 16,
            height: 16,
          ).center(),
        ),
        12.width,
        BotResponseComponent(
            onRegeneratePressed: onRegeneratePressed,
            onSpeakerPressed: onSpeakerPressed,
            onCopyPressed: onCopyPressed,
            modelSelectClick: modelSelectClick,
            answer: answer,
            child: Obx(
              () => Stack(
                children: [
                  Markdown(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    selectable: true,
                    onSelectionChanged: (text, selection, cause) {},
                    data: answer.messageText.value.replaceAll('\\n', '\n'),
                  ).paddingBottom(10),
                  Positioned(
                    bottom: 0,
                    left: 16,
                    child: Text(
                      "${answer.messageText.value.replaceAll('\\n', '\n').calculateReadTime().toStringAsFixed(1).toDouble().ceil()} min read",
                      style: secondaryTextStyle(),
                    ),
                  ),
                ],
              ),
            )).flexible(),
        32.width
      ],
    ).paddingSymmetric(vertical: 16, horizontal: 16);
  }
}
