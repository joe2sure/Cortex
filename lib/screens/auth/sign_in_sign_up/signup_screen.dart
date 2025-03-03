import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../components/app_scaffold.dart';
import '../../../components/cached_image_widget.dart';
import '../../../components/loader_widget.dart';
import '../../../configs.dart';
import '../../../generated/assets.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import 'auth_bg_widget.dart';
import 'sign_up_controller.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});
  final SignUpController signUpController = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      hideAppBar: true,
      isLoading: signUpController.isLoading,
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const AuthBackground(),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  10.height,
                  CachedImageWidget(
                    url: Assets.imagesAuthSignup,
                    fit: BoxFit.cover,
                    height: 230,
                  ),
                  10.height,
                  Text(
                    locale.value.signUp,
                    style: primaryTextStyle(size: 24, color: white),
                  ),
                  8.height,
                  Text(
                    locale.value.createAccountForBetterExperience,
                    style: secondaryTextStyle(size: 14, color: white),
                  ),
                  SizedBox(height: Get.height * 0.07),
                  Form(
                    key: signUpController.signUpformKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        16.height,
                        AppTextField(
                          title: locale.value.firstName,
                          textStyle: primaryTextStyle(size: 12),
                          controller: signUpController.fisrtNameCont,
                          focus: signUpController.fisrtNameFocus,
                          nextFocus: signUpController.lastNameFocus,
                          textFieldType: TextFieldType.USERNAME,
                          decoration: inputDecoration(
                            context,
                            fillColor: context.cardColor,
                            filled: true,
                            hintText: "${locale.value.eG} ${locale.value.merry}",
                          ),
                          suffix: commonLeadingWid(imgPath: Assets.navigationIcUserOutlined, size: 14).paddingAll(14),
                        ),
                        16.height,
                        AppTextField(
                          title: locale.value.lastName,
                          textStyle: primaryTextStyle(size: 12),
                          controller: signUpController.lastNameCont,
                          focus: signUpController.lastNameFocus,
                          nextFocus: signUpController.emailFocus,
                          textFieldType: TextFieldType.USERNAME,
                          decoration: inputDecoration(
                            context,
                            fillColor: context.cardColor,
                            filled: true,
                            hintText: "${locale.value.eG}  ${locale.value.doe}",
                          ),
                          suffix: commonLeadingWid(imgPath: Assets.navigationIcUserOutlined, size: 14).paddingAll(14),
                        ),
                        16.height,
                        AppTextField(
                          title: locale.value.email,
                          textStyle: primaryTextStyle(size: 12),
                          controller: signUpController.emailCont,
                          focus: signUpController.emailFocus,
                          nextFocus: signUpController.passwordFocus,
                          textFieldType: TextFieldType.EMAIL_ENHANCED,
                          decoration: inputDecoration(
                            context,
                            fillColor: context.cardColor,
                            filled: true,
                            hintText: "${locale.value.eG} merry_456@gmail.com",
                          ),
                          suffix: commonLeadingWid(imgPath: Assets.iconsIcMail, size: 14).paddingAll(14),
                        ),
                        16.height,
                        Obx(() {
                          return AppTextField(
                              title: locale.value.password,
                              textStyle: primaryTextStyle(size: 12),
                              controller: signUpController.passwordCont,
                              focus: signUpController.passwordFocus,
                              obscureText: !signUpController.passwordVisible.value,
                              textFieldType: TextFieldType.PASSWORD,
                              decoration: inputDecoration(
                                context,
                                fillColor: context.cardColor,
                                filled: true,
                                hintText: "${locale.value.eG} #123@156",
                              ),
                              validator: (value){
                                log(value!.length);
                                if(value.length>=8 && value.length<=12)
                                  {
                                    return null;
                                  }
                                else
                                  {
                                    return "Password should 8 to 12 characters long";
                                  }
                              },
                              suffix: InkWell(
                                onTap: () {
                                  signUpController.togglePasswordVisibility(); // Toggle visibility
                                },
                                child: signUpController.passwordVisible.value
                                    ? commonLeadingWid(imgPath: Assets.iconsIcEye, size: 14).paddingAll(12)
                                    : commonLeadingWid(imgPath: Assets.iconsIcEyeSlash, size: 14).paddingAll(12),
                              ));
                        }),
                        16.height,
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Obx(
                                  () => CheckboxListTile(
                                    checkColor: whiteColor,
                                    value: signUpController.isAcceptedTc.value,
                                    activeColor: appColorPrimary,
                                    visualDensity: VisualDensity.compact,
                                    dense: true,
                                    controlAffinity: ListTileControlAffinity.leading,
                                    contentPadding: EdgeInsets.zero,
                                    onChanged: (val) async {
                                      signUpController.isAcceptedTc.value = !signUpController.isAcceptedTc.value;
                                    },
                                    checkboxShape: RoundedRectangleBorder(borderRadius: radius(0)),
                                    side: const BorderSide(color: secondaryTextColor, width: 1.5),
                                    title: RichTextWidget(
                                      list: [
                                        TextSpan(text: "${locale.value.iAgreeToThe} ", style: secondaryTextStyle()),
                                        TextSpan(
                                          text: "Terms & Conditions",
                                          style: primaryTextStyle(color: appColorPrimary, size: 12, decoration: TextDecoration.underline, decorationColor: appColorPrimary),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              commonLaunchUrl(TERMS_CONDITION_URL, launchMode: LaunchMode.externalApplication);
                                            },
                                        ),
                                        TextSpan(text: " And ", style: secondaryTextStyle()),
                                        TextSpan(
                                          text: "Privacy Policy",
                                          style: primaryTextStyle(color: appColorPrimary, size: 12, decoration: TextDecoration.underline, decorationColor: appColorPrimary),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              commonLaunchUrl(PRIVACY_POLICY_URL, launchMode: LaunchMode.externalApplication);
                                            },
                                        ),
                                      ],
                                    ),
                                  ),
                                ).expand(),
                              ],
                            ),
                          ],
                        ),
                        16.height,
                        AppButton(
                          width: Get.width,
                          text: locale.value.signUp,
                          textStyle: appButtonTextStyleWhite,
                          onTap: () {
                            if (signUpController.signUpformKey.currentState!.validate()) {
                              signUpController.signUpformKey.currentState!.save();
                              signUpController.saveForm();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  8.height,
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(locale.value.alreadyHaveAnAccount, style: secondaryTextStyle()),
                      4.width,
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: () {
                          Get.back();
                        },
                        child: Text(
                          locale.value.signIn,
                          style: primaryTextStyle(
                            size: 12,
                            color: appColorPrimary,
                            decoration: TextDecoration.underline,
                            decorationColor: appColorPrimary,
                          ),
                        ).paddingSymmetric(horizontal: 8),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Obx(() => const LoaderWidget().center().visible(signUpController.isLoading.value)),
          ],
        ),
      ),
    );
  }
}
