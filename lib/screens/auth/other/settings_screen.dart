// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/components/app_dialog_widget.dart';
import 'package:Cortex/utils/colors.dart';
import '../../../components/app_scaffold.dart';
import '../../../components/cached_image_widget.dart';
import '../../../generated/assets.dart';
import '../../../utils/app_common.dart';
import '../model/theme_mode_data_model.dart';
import 'settings_controller.dart';
import '../../../locale/app_localizations.dart';
import '../../../locale/languages.dart';
import '../../../main.dart';
import '../../../utils/common_base.dart';
import '../../../utils/local_storage.dart';
import 'about_us_screen.dart';
import '../password/change_password_screen.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({super.key});
  final SettingsController settingsController = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppScaffold(
        appBartitleText: locale.value.settings,
        hasLeadingWidget: isLoggedIn.value,
        leadingWidget: isLoggedIn.value
            ? IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.grey, size: 20),
              )
            : null,
        body: Column(
          children: [
            commonDivider,
            8.height,
            Obx(
              () => SettingItemWidget(
                title: locale.value.language,
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                titleTextStyle: primaryTextStyle(),
                leading: commonLeadingWid(imgPath: Assets.iconsIcLanguage, color: appColorPrimary),
                trailing: DropdownButtonHideUnderline(
                  child: Container(
                    decoration: BoxDecoration(color: context.cardColor, borderRadius: BorderRadius.circular(10)),
                    child: DropdownButton(
                      elevation: 1,
                      dropdownColor: context.cardColor,
                      borderRadius: BorderRadius.circular(defaultRadius),
                      items: localeLanguageList.map((element) {
                        return DropdownMenuItem(
                          value: element,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (element.flag != null) CachedImageWidget(url: element.flag.validate(), height: 24, width: 24),
                              6.width,
                              if (element.name != null) Text(element.name.validate(), style: primaryTextStyle(size: 14)),
                            ],
                          ).paddingSymmetric(horizontal: 12),
                        );
                      }).toList(),
                      onChanged: (newValue) async {
                        if (newValue is LanguageDataModel) {
                          settingsController.selectedLang(newValue);
                          settingsController.isLoading(true);
                          await setValue(SELECTED_LANGUAGE_CODE, newValue.languageCode);
                          selectedLanguageDataModel = newValue;
                          settingsController.selectedLang(newValue);
                          BaseLanguage temp = await const AppLocalizations().load(Locale(newValue.languageCode.validate()));
                          locale = temp.obs;
                          setValueToLocal(SELECTED_LANGUAGE_CODE, newValue.languageCode.validate());
                          selectedLanguageCode(newValue.languageCode!);
                          Get.updateLocale(Locale(newValue.languageCode.validate()));
                          settingsController.isLoading(false);
                        }
                      },
                      value: settingsController.selectedLang.value.id.validate() > 0 ? settingsController.selectedLang.value : localeLanguageList.first,
                    ),
                  ),
                ),
              ),
            ),
            Obx(
              () => SettingItemWidget(
                title: locale.value.appTheme,
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                titleTextStyle: primaryTextStyle(),
                leading: commonLeadingWid(imgPath: Assets.iconsIcDarkMode, color: appColorPrimary),
                trailing: DropdownButtonHideUnderline(
                  child: Container(
                    decoration: BoxDecoration(color: context.cardColor, borderRadius: BorderRadius.circular(10)),
                    child: DropdownButton(
                      elevation: 1,
                      dropdownColor: context.cardColor,
                      borderRadius: BorderRadius.circular(defaultRadius),
                      items: settingsController.themeModes.map((element) {
                        return DropdownMenuItem(
                          value: element,
                          child: Text(element.mode, style: primaryTextStyle(size: 13)).paddingSymmetric(horizontal: 12),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        if (newValue is ThemeModeData) {
                          settingsController.dropdownValue(newValue);
                          toggleThemeMode(themeId: settingsController.dropdownValue.value.id);
                        }
                      },
                      value: !settingsController.dropdownValue.value.id.isNegative ? settingsController.dropdownValue.value : settingsController.themeModes.first,
                    ),
                  ),
                ),
              ),
            ),
            SettingItemWidget(
              title: locale.value.changePassword,
              onTap: () {
                Get.to(() => ChangePassword());
              },
              titleTextStyle: primaryTextStyle(),
              leading: commonLeadingWid(imgPath: Assets.iconsIcLock, color: appColorPrimary),
            ).visible(isLoggedIn.value),
            SettingItemWidget(
              title: locale.value.deleteAccount,
              onTap: () {
                ifNotTester(() async {
                  if (await isNetworkAvailable()) {
                    showAppDialog(
                      context,
                      negativeText: locale.value.cancel,
                      positiveText: locale.value.delete,
                        titleTextStyle:  primaryTextStyle(color: Colors.red),
                      onConfirm: () {
                        settingsController.handleDeleteAccountClick();
                      },
                        buttonColor: Colors.red,
                      dialogType: AppDialogType.delete,
                      dialogText: locale.value.deleteAccountConfirmation,
                    );
                  } else {
                    toast(locale.value.yourInternetIsNotWorking);
                  }
                });
              },
              titleTextStyle: primaryTextStyle(),
              leading: commonLeadingWid(imgPath: Assets.iconsIcDelete, color: appColorPrimary),
            ).visible(isLoggedIn.value),
            SettingItemWidget(
              title: locale.value.aboutApp,
              splashColor: transparentColor,
              onTap: () {
                Get.to(() => const AboutScreen());
              },
              titleTextStyle: primaryTextStyle(),
              leading: commonLeadingWid(imgPath: Assets.iconsIcInfo, color: appColorPrimary),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            ).visible(!isLoggedIn.value),
            SettingItemWidget(
              title: locale.value.signIn,
              onTap: () {
                doIfLoggedIn(() {});
              },
              titleTextStyle: primaryTextStyle(),
              leading: commonLeadingWid(imgPath: Assets.iconsIcLogin, color: appColorPrimary),
            ).visible(!isLoggedIn.value),
          ],
        ),
      ),
    );
  }
}
