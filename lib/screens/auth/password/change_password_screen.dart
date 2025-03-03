import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/app_scaffold.dart';
import '../../../components/cached_image_widget.dart';
import '../../../generated/assets.dart';
import '../../../main.dart';
import 'change_password_controller.dart';

import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';

class ChangePassword extends StatelessWidget {
  ChangePassword({super.key});
  final ChangePassController changePassController = Get.put(ChangePassController());
  final GlobalKey<FormState> _changePassformKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isCenterTitle: true,
      appBartitleText: locale.value.changePassword,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _changePassformKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              10.height,
              CachedImageWidget(
                url: Assets.imagesAuthResetPassword,
                fit: BoxFit.cover,
                height: 230,
              ),
              10.height,
              AppTextField(
                title: locale.value.oldPassword,
                textStyle: primaryTextStyle(size: 12),
                controller: changePassController.oldPasswordCont, // Optional
                textFieldType: TextFieldType.PASSWORD,
                decoration: inputDecoration(context, fillColor: context.cardColor, filled: true, hintText: "${locale.value.eG} #123@156"),
                suffixPasswordVisibleWidget: const Icon(Icons.remove_red_eye_outlined, color: borderColor),
                suffixPasswordInvisibleWidget: commonLeadingWid(imgPath: Assets.iconsIcEyeSlash, color: borderColor).paddingAll(12),
              ),
              16.height,
              AppTextField(
                title: locale.value.newPassword,
                textStyle: primaryTextStyle(size: 12),
                controller: changePassController.newpasswordCont, // Optional
                textFieldType: TextFieldType.PASSWORD,
                decoration: inputDecoration(context, fillColor: context.cardColor, filled: true, hintText: "${locale.value.eG}  #123@156"),
                suffixPasswordVisibleWidget: const Icon(Icons.remove_red_eye_outlined, color: borderColor),
                suffixPasswordInvisibleWidget: commonLeadingWid(imgPath: Assets.iconsIcEyeSlash, color: borderColor).paddingAll(12),
              ),
              16.height,
              AppTextField(
                title: locale.value.confirmNewPassword,
                textStyle: primaryTextStyle(size: 12),
                controller: changePassController.confirmPasswordCont, // Optional
                textFieldType: TextFieldType.PASSWORD,
                decoration: inputDecoration(context, fillColor: context.cardColor, filled: true, hintText: "${locale.value.eG}  #123@156"),
                suffixPasswordVisibleWidget: const Icon(Icons.remove_red_eye_outlined, color: borderColor),
                suffixPasswordInvisibleWidget: commonLeadingWid(imgPath: Assets.iconsIcEyeSlash, color: borderColor).paddingAll(12),
              ),
              60.height,
              AppButton(
                width: Get.width,
                text: locale.value.submit,
                textStyle: appButtonTextStyleWhite,
                onTap: () async {
                  ifNotTester(() async {
                    if (await isNetworkAvailable()) {
                      if (_changePassformKey.currentState!.validate()) {
                        _changePassformKey.currentState!.save();
                        changePassController.saveForm();
                      }
                    } else {
                      toast(locale.value.yourInternetIsNotWorking);
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
