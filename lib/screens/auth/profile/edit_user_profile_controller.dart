import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/utils/colors.dart';

import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/common_base.dart';
import '../../../utils/constants.dart';
import '../../../utils/local_storage.dart';
import '../model/login_response.dart';
import '../services/auth_service_apis.dart';

class EditUserProfileController extends GetxController {
  //Constructor region
  EditUserProfileController({this.isProfilePhoto = false});

  bool isProfilePhoto;

  //Constructor endregion
  RxBool isLoading = false.obs;
  Rx<File> imageFile = File("").obs;
  XFile? pickedFile;

  TextEditingController fNameCont = TextEditingController();
  TextEditingController lNameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController mobileCont = TextEditingController();
  TextEditingController addressCont = TextEditingController();

  FocusNode fNameFocus = FocusNode();
  FocusNode lNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode mobileFocus = FocusNode();
  FocusNode addressFocus = FocusNode();

  @override
  void onInit() {
    init();
    super.onInit();
  }

  Future<void> init() async {
    fNameCont.text = loginUserData.value.firstName;
    lNameCont.text = loginUserData.value.lastName;
    mobileCont.text = loginUserData.value.mobile;
    emailCont.text = loginUserData.value.email;
    addressCont.text = loginUserData.value.address;
  }

  Future<void> updateUserProfile() async {
    if (!isProfilePhoto) {
      hideKeyBoardWithoutContext();
    }
    isLoading(true);

    AuthServiceApis.updateProfile(
      firstName: isProfilePhoto ? loginUserData.value.firstName : fNameCont.text.trim(),
      lastName: isProfilePhoto ? loginUserData.value.lastName : lNameCont.text.trim(),
      mobile: isProfilePhoto ? loginUserData.value.mobile : mobileCont.text.trim(),
      address: isProfilePhoto ? loginUserData.value.address : addressCont.text.trim(),
      imageFile: imageFile.value.path.isNotEmpty ? imageFile.value : null,
      onSuccess: (data) {
        isLoading(false);
        if (data != null) {
          if ((data as String).isJson()) {
            log("Response: ${jsonDecode(data)}");
            UserResponse loginResponseModel = UserResponse.fromJson(jsonDecode(data));
            loginUserData(UserData(
              id: loginUserData.value.id,
              firstName: loginResponseModel.userData.firstName,
              lastName: loginResponseModel.userData.lastName,
              userName: "${loginResponseModel.userData.firstName} ${loginResponseModel.userData.lastName}",
              mobile: loginResponseModel.userData.mobile,
              email: loginUserData.value.email,
              userRole: loginUserData.value.userRole,
              address: loginResponseModel.userData.address,
              apiToken: loginUserData.value.apiToken,
              profileImage: loginResponseModel.userData.profileImage,
              loginType: loginUserData.value.loginType,
            ));
            setValueToLocal(SharedPreferenceConst.USER_DATA, loginUserData.toJson());
            Get.back();
          }
        }
      },
    ).then((data) {
      toast(locale.value.profileUpdatedSuccessfully);
    }).catchError((e) {
      isLoading(false);
      toast(e.toString());
    });
  }

  void _getFromGallery() async {
    pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1800, maxHeight: 1800);
    if (pickedFile != null) {
      imageFile(File(pickedFile!.path));
      if (isProfilePhoto) {
        showConfimDialogChoosePhoto();
      }
      // setState(() {});
    }
  }

  _getFromCamera() async {
    pickedFile = await ImagePicker().pickImage(source: ImageSource.camera, maxWidth: 1800, maxHeight: 1800);
    if (pickedFile != null) {
      imageFile(File(pickedFile!.path));
      if (isProfilePhoto) {
        showConfimDialogChoosePhoto();
      }
    }
  }

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      backgroundColor: context.cardColor,
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SettingItemWidget(
              title: locale.value.gallery,
              leading: const Icon(Icons.image, color: appColorPrimary),
              onTap: () async {
                _getFromGallery();
                finish(context);
              },
            ),
            SettingItemWidget(
              title: locale.value.camera,
              leading: const Icon(Icons.camera, color: appColorPrimary),
              onTap: () {
                _getFromCamera();
                finish(context);
              },
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
            ),
          ],
        ).paddingAll(16.0);
      },
    );
  }

  void showConfimDialogChoosePhoto() {
    showConfirmDialogCustom(
      getContext,
      primaryColor: appColorPrimary,
      negativeText: locale.value.cancel,
      positiveText: locale.value.yes,
      onAccept: (_) {
        ifNotTester(() async {
          if (await isNetworkAvailable()) {
            updateUserProfile();
          } else {
            toast(locale.value.yourInternetIsNotWorking);
          }
        });
      },
      dialogType: DialogType.ACCEPT,
      customCenterWidget: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.file(
            imageFile.value,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              alignment: Alignment.center,
              width: 100,
              height: 100,
              decoration: boxDecorationDefault(shape: BoxShape.circle, color: appColorPrimary.withOpacity(0.4)),
              child: Text(
                "${loginUserData.value.firstName.firstLetter.toUpperCase()}${loginUserData.value.lastName.firstLetter.toUpperCase()}",
                style: const TextStyle(fontSize: 100 * 0.3, color: Colors.white),
              ),
            ),
          ).cornerRadiusWithClipRRect(45),
        ],
      ).paddingSymmetric(vertical: 16),
      title: locale.value.wouldYouLikeToSetProfilePhotoAs,
    );
  }
}
