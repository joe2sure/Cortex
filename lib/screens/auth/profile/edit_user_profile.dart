import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../../components/loader_widget.dart';
import '../../../../main.dart';
import '../../../../utils/common_base.dart';
import '../../../components/app_scaffold.dart';
import '../../../components/common_profile_widget.dart';
import '../../../generated/assets.dart';
import 'edit_user_profile_controller.dart';
import '../../../utils/app_common.dart';

class EditUserProfileScreen extends StatelessWidget {
  EditUserProfileScreen({super.key});
  final EditUserProfileController editUserProfileController = Get.put(EditUserProfileController());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBartitleText: locale.value.editProfile,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  16.height,
                  Obx(() => ProfilePicWidget(
                        heroTag: editUserProfileController.imageFile.value.path.isNotEmpty
                            ? editUserProfileController.imageFile.value.path
                            : loginUserData.value.profileImage.isNotEmpty
                                ? loginUserData.value.profileImage
                                : loginUserData.value.profileImage,
                        profileImage: editUserProfileController.imageFile.value.path.isNotEmpty
                            ? editUserProfileController.imageFile.value.path
                            : loginUserData.value.profileImage.isNotEmpty
                                ? loginUserData.value.profileImage
                                : loginUserData.value.profileImage,
                        firstName: loginUserData.value.firstName,
                        lastName: loginUserData.value.lastName,
                        userName: loginUserData.value.userName,
                        showBgCurves: false,
                        showOnlyPhoto: true,
                        onCameraTap: () {
                          editUserProfileController.showBottomSheet(context);
                        },
                        onPicTap: () {
                          editUserProfileController.showBottomSheet(context);
                        },
                      )),
                  32.height,
                  AppTextField(
                    title: locale.value.firstName,
                    textStyle: primaryTextStyle(size: 12),
                    controller: editUserProfileController.fNameCont,
                    focus: editUserProfileController.fNameFocus,
                    nextFocus: editUserProfileController.lNameFocus,
                    textFieldType: TextFieldType.NAME,
                    decoration: inputDecoration(
                      context,
                      hintText: "${locale.value.eG}  ${locale.value.merry}",
                      fillColor: context.cardColor,
                      filled: true,
                    ),
                    suffix: commonLeadingWid(imgPath: Assets.navigationIcUserOutlined, size: 14).paddingAll(14),
                  ).paddingSymmetric(horizontal: 16),
                  16.height,
                  AppTextField(
                    title: locale.value.lastName,
                    textStyle: primaryTextStyle(size: 12),
                    controller: editUserProfileController.lNameCont,
                    focus: editUserProfileController.lNameFocus,
                    nextFocus: editUserProfileController.emailFocus,
                    textFieldType: TextFieldType.NAME,
                    decoration: inputDecoration(
                      context,
                      hintText: "${locale.value.eG}  ${locale.value.doe}",
                      fillColor: context.cardColor,
                      filled: true,
                    ),
                    suffix: commonLeadingWid(imgPath: Assets.navigationIcUserOutlined, size: 14).paddingAll(14),
                  ).paddingSymmetric(horizontal: 16),
                  16.height,
                  AppTextField(
                    title: locale.value.email,
                    textStyle: primaryTextStyle(size: 12),
                    controller: editUserProfileController.emailCont,
                    focus: editUserProfileController.emailFocus,
                    nextFocus: editUserProfileController.mobileFocus,
                    textFieldType: TextFieldType.EMAIL,
                    readOnly: true,
                    enabled: false,
                    decoration: inputDecoration(
                      context,
                      hintText: "${locale.value.eG} merry_456@gmail.com",
                      fillColor: context.cardColor,
                      filled: true,
                    ),
                    suffix: commonLeadingWid(imgPath: Assets.iconsIcMail, size: 14).paddingAll(14),
                  ).paddingSymmetric(horizontal: 16),
                  16.height,
                  AppTextField(
                    title: locale.value.contactNumber,
                    textStyle: primaryTextStyle(size: 12),
                    textFieldType: TextFieldType.PHONE,
                    controller: editUserProfileController.mobileCont,
                    focus: editUserProfileController.mobileFocus,
                    nextFocus: editUserProfileController.addressFocus,
                    errorThisFieldRequired: locale.value.thisFieldIsRequired,
                    decoration: inputDecoration(
                      context,
                      hintText: "${locale.value.eG}  1-2188219848",
                      fillColor: context.cardColor,
                      filled: true,
                    ),
                  ).paddingSymmetric(horizontal: 16),
                  16.height,
                  AppTextField(
                    isValidationRequired: false,
                    title: locale.value.address,
                    textStyle: primaryTextStyle(size: 12),
                    textFieldType: TextFieldType.MULTILINE,
                    controller: editUserProfileController.addressCont,
                    focus: editUserProfileController.addressFocus,
                    errorThisFieldRequired: locale.value.thisFieldIsRequired,
                    decoration: inputDecoration(
                      context,
                      hintText: "${locale.value.eG} 123, ${locale.value.mainStreet}",
                      fillColor: context.cardColor,
                      filled: true,
                    ),
                  ).paddingSymmetric(horizontal: 16),
                  32.height,
                  AppButton(
                    width: Get.width,
                    text: locale.value.update,
                    textStyle: appButtonTextStyleWhite,
                    onTap: () async {
                      ifNotTester(() async {
                        if (await isNetworkAvailable()) {
                          editUserProfileController.updateUserProfile();
                        } else {
                          toast(locale.value.yourInternetIsNotWorking);
                        }
                      });
                    },
                  ).paddingSymmetric(horizontal: 16),
                  24.height,
                ],
              ),
            ),
          ),
          Obx(() => const LoaderWidget().visible(editUserProfileController.isLoading.value)),
        ],
      ),
    );
  }
}
