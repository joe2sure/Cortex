import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/generated/assets.dart';
import 'package:Cortex/utils/common_base.dart';
import '../../../main.dart';
import '../home_controller.dart';

class HomeSearchBarComponent extends StatelessWidget {
  final String? hintText;
  final Function(String)? onFieldSubmitted;
  final Function()? onTap;
  final Function()? onClearButton;
  final HomeController homeController;

  const HomeSearchBarComponent({
    super.key,
    this.hintText,
    this.onTap,
    this.onFieldSubmitted,
    this.onClearButton,
    required this.homeController,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: homeController.searchCont,
      textFieldType: TextFieldType.OTHER,
      textInputAction: TextInputAction.done,
      textStyle: primaryTextStyle(),
      onTap: onTap,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: (p0) {
        homeController.isSearching(homeController.searchCont.text.trim().isNotEmpty);
        homeController.searchStream.add(p0);
      },
      suffix: Obx(
        () => appCloseIconButton(
          context,
          onPressed: () {
            hideKeyboard(context);
            homeController.searchCont.clear();
            homeController.isSearching(homeController.searchCont.text.trim().isNotEmpty);
            if (onClearButton != null) {
              onClearButton!.call();
            }
          },
          size: 11,
        ).visible(homeController.isSearching.value),
      ),
      decoration: inputDecorationWithOutBorder(
        context,
        hintText: hintText ?? locale.value.searchTemplates,
        filled: true,
        fillColor: context.cardColor,
        prefixIcon: commonLeadingWid(imgPath: Assets.iconsIcSearch, size: 18).paddingAll(14),
      ),
    );
  }
}
