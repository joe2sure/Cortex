import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/app_scaffold.dart';
import '../../../components/cached_image_widget.dart';
import '../../../generated/assets.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import '../password/forget_password_screen.dart';
import 'auth_bg_widget.dart';
import 'sign_in_controller.dart';
import 'signup_screen.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});
  final SignInController signInController = Get.put(SignInController());

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      hideAppBar: true,
      isLoading: signInController.isLoading,
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
                    url: Assets.imagesAuthSignin,
                    fit: BoxFit.cover,
                    height: 230,
                  ),
                  10.height,
                  Text(
                    locale.value.logIn,
                    style: primaryTextStyle(size: 24, color: white),
                  ),
                  8.height,
                  Text(
                    locale.value.youHaveBeenMissedForALongTime,
                    style: secondaryTextStyle(size: 14, color: white),
                  ),
                  SizedBox(height: Get.height * 0.07),
                  Form(
                    key: signInController.signInformKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppTextField(
                          title: locale.value.email,
                          textStyle: primaryTextStyle(size: 12),
                          controller: signInController.emailCont,
                          focus: signInController.emailFocus,
                          nextFocus: signInController.passwordFocus,
                          textFieldType: TextFieldType.EMAIL,
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
                              controller: signInController.passwordCont,
                              focus: signInController.passwordFocus,
                              obscureText: !signInController.passwordVisible.value,
                              textFieldType: TextFieldType.PASSWORD,
                              decoration: inputDecoration(
                                context,
                                fillColor: context.cardColor,
                                filled: true,
                                hintText: "••••••••",
                              ),
                              suffix: InkWell(
                                  onTap: () {
                                    signInController.togglePasswordVisibility(); // Toggle visibility
                                  },
                                  child: signInController.passwordVisible.value
                                      ? commonLeadingWid(imgPath: Assets.iconsIcEye, size: 14).paddingAll(12)
                                      : commonLeadingWid(imgPath: Assets.iconsIcEyeSlash, size: 14).paddingAll(12)));
                        }),
                        8.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(
                              () => CheckboxListTile(
                                checkColor: whiteColor,
                                value: signInController.isRememberMe.value,
                                activeColor: appColorPrimary,
                                visualDensity: VisualDensity.compact,
                                dense: true,
                                controlAffinity: ListTileControlAffinity.leading,
                                contentPadding: EdgeInsets.zero,
                                onChanged: (val) async {
                                  signInController.toggleSwitch();
                                },
                                checkboxShape: RoundedRectangleBorder(borderRadius: radius(0)),
                                side: const BorderSide(color: secondaryTextColor, width: 1.5),
                                title: Text(
                                  locale.value.rememberMe,
                                  style: secondaryTextStyle(color: darkGrayGeneral),
                                ),
                              ),
                            ).expand(),
                            TextButton(
                              onPressed: () {
                                Get.to(() => ForgetPassword());
                              },
                              child: Text(
                                locale.value.forgotPassword,
                                style: primaryTextStyle(
                                  size: 12,
                                  color: appColorPrimary,
                                  decoration: TextDecoration.underline,
                                  fontStyle: FontStyle.italic,
                                  decorationColor: appColorPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        32.height,
                        AppButton(
                          width: Get.width,
                          text: locale.value.signIn,
                          textStyle: appButtonTextStyleWhite,
                          onTap: () {
                            if (signInController.signInformKey.currentState!.validate()) {
                              signInController.signInformKey.currentState!.save();
                              signInController.saveForm();
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
                      Text(locale.value.notRegistered, style: secondaryTextStyle()),
                      4.width,
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: () {
                          Get.to(() => SignUpScreen());
                        },
                        child: Text(
                          locale.value.registerNow,
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
                  16.height,
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 10.0),
                        child: const Divider(color: borderColor),
                      ).expand(),
                      Text(locale.value.orSignInWith, style: primaryTextStyle(color: secondaryTextColor, size: 14)).paddingSymmetric(horizontal: 20),
                      Container(
                        margin: const EdgeInsets.only(right: 10.0),
                        child: const Divider(
                          color: borderColor,
                        ),
                      ).expand(),
                    ],
                  ),
                  16.height,
                  AppButton(
                    width: Get.width,
                    color: context.cardColor,
                    text: "",
                    textStyle: appButtonFontColorText,
                    onTap: () {
                      signInController.googleSignIn();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          Assets.imagesGoogleLogo,
                          height: 20,
                          width: 20,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.g_mobiledata_rounded),
                        ),
                        8.width,
                        Text(
                          locale.value.signInWithGoogle,
                          style: primaryTextStyle(),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  AppButton(
                    width: Get.width,
                    color: context.cardColor,
                    text: "",
                    textStyle: appButtonFontColorText,
                    onTap: () {
                      signInController.appleSignIn();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          Assets.imagesAppleLogo,
                          height: 20,
                          width: 20,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.g_mobiledata_rounded),
                        ),
                        8.width,
                        Text(
                          locale.value.signInWithApple,
                          style: primaryTextStyle(),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ).paddingTop(16).visible(isApple),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
