import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/components/app_dialog_widget.dart';
import 'package:Cortex/generated/assets.dart';
import 'package:Cortex/screens/ai_chat/title_edit_bar_component.dart';
import 'package:Cortex/utils/common_base.dart';

import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import '../../home/model/recent_chat_res.dart';
import '../recent_chat_controller.dart';

class RecentComponent extends StatelessWidget {
  final Function()? onPressed;
  final RecentChatElement recentChatElement;

  RecentComponent({super.key, this.onPressed, required this.recentChatElement});

  final RecentChatController recentCont = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecorationWithRoundedCorners(backgroundColor: isDarkMode.value ? fullDarkCanvasColorDark : appSectionBackground, borderRadius: BorderRadius.circular(8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          16.width,
          Obx(
            () => recentChatElement.showEditbar.value
                ? TitleEditBarComponent(
                    recentChatElement: recentChatElement,
                    onClearButton: () {
                      recentChatElement.showEditbar(false);
                    },
                  )
                : Text(
                    recentChatElement.title,
                    textAlign: TextAlign.left,
                    style: primaryTextStyle(size: 14, color: isDarkMode.value ? whiteTextColor : canvasColor),
                  ),
          ).expand(),
          8.width,
          Obx(() => recentChatElement.showEditbar.value
              ? AppButton(
                  height: 20,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  elevation: 0,
                  color: appColorPrimary,
                  onTap: () async {
                    hideKeyboard(context);
                    recentChatElement.title = recentChatElement.editCont.text.trim();
                    recentChatElement.showEditbar(false);
                    recentCont.editTitle(recentChatElement: recentChatElement);
                  },
                  child: Text(locale.value.set, style: boldTextStyle(size: 14, weight: FontWeight.w500, color: white)),
                )
              : Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        recentChatElement.showEditbar(!recentChatElement.showEditbar.value);
                        recentChatElement.editCont.text = recentChatElement.title;
                        recentChatElement.isTyping(true);
                        FocusScope.of(context).requestFocus(recentChatElement.editFocus);
                      },
                      icon: commonLeadingWid(imgPath: Assets.iconsIcEditReview, size: 20),
                    ),
                    IconButton(
                      onPressed: () {
                        showAppDialog(
                          context,
                          onConfirm: () => recentCont.deleteChat(chatId: recentChatElement.id),
                          dialogType: AppDialogType.delete,
                          dialogText: locale.value.deleteChatConfirmation,
                        );
                      },
                      icon: commonLeadingWid(imgPath: Assets.iconsIcDelete, color: deleteTextColor, size: 20),
                    ),
                  ],
                )),
        ],
      ).paddingSymmetric(vertical: 16).onTap(onPressed, borderRadius: BorderRadius.circular(8)),
    );
  }
}
