import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/utils/common_base.dart';
import '../home/model/recent_chat_res.dart';

class TitleEditBarComponent extends StatelessWidget {
  final String? hintText;
  final Function(String)? onFieldSubmitted;
  final Function()? onTap;
  final Function()? onClearButton;
  final RecentChatElement recentChatElement;

  const TitleEditBarComponent({
    super.key,
    this.hintText,
    this.onTap,
    this.onFieldSubmitted,
    this.onClearButton,
    required this.recentChatElement,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: recentChatElement.editCont,
      focus: recentChatElement.editFocus,
      textFieldType: TextFieldType.MULTILINE,
      textInputAction: TextInputAction.done,
      textStyle: primaryTextStyle(),
      onTap: onTap,
      minLines: 2,
      maxLines: 3,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: (p0) {
        recentChatElement.isTyping(p0.trim().isNotEmpty);
      },
      suffix: Obx(
        () => appCloseIconButton(
          context,
          onPressed: () {
            hideKeyboard(context);
            recentChatElement.editCont.clear();
            recentChatElement.isTyping(recentChatElement.editCont.text.trim().isNotEmpty);
            if (onClearButton != null) {
              onClearButton!.call();
            }
          },
          size: 11,
        ).visible(recentChatElement.isTyping.value),
      ),
      decoration: inputDecorationWithOutBorder(
        context,
        hintText: hintText,
        filled: true,
        fillColor: context.cardColor,
      ),
    );
  }
}
