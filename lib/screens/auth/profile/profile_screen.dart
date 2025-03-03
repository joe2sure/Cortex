import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/components/app_dialog_widget.dart';
import 'package:Cortex/screens/home/home_controller.dart';
import '../../../components/app_scaffold.dart';
import '../../../components/common_profile_widget.dart';
import '../../../generated/assets.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import '../../../utils/constants.dart';
import '../../subscription_plan/sub_scription_plan_screen.dart';
import '../../subscription_plan/subscription_history_screen.dart';
import '../other/about_us_screen.dart';
import '../other/settings_screen.dart';
import 'edit_user_profile.dart';
import 'edit_user_profile_controller.dart';
import 'profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final ProfileController profileController = Get.put(ProfileController());
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppScaffold(
        hideAppBar: true,
        hasLeadingWidget: false,
        isLoading: profileController.isLoading,
        body: Stack(
          children: [
            AnimatedScrollView(
              padding: EdgeInsets.only(top: Get.height * 0.08, bottom: Get.height * 0.08),
              listAnimationType: ListAnimationType.None,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Obx(
                      () => ProfilePicWidget(
                        heroTag: loginUserData.value.profileImage,
                        profileImage: loginUserData.value.profileImage,
                        firstName: loginUserData.value.firstName,
                        lastName: loginUserData.value.lastName,
                        userName: loginUserData.value.userName,
                        subInfo: loginUserData.value.email,
                        onCameraTap: () {
                          EditUserProfileController editUserProfileController = EditUserProfileController(isProfilePhoto: true);
                          editUserProfileController.showBottomSheet(context);
                        },
                      ),
                    ),
                    Obx(
                      () => Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              try {
                                HomeController hCont = Get.find();
                                Get.to(() => SubscriptionPlanScreen(homeController: hCont));
                              } catch (e) {
                                log('currentPlan Tap E: $e');
                              }
                            },
                            child: Container(
                              decoration: boxDecorationWithRoundedCorners(
                                borderRadius: const BorderRadius.all(Radius.circular(16)),
                                backgroundColor: isDarkMode.value ? cardDarkColor : appColorPrimary.withOpacity(0.1),
                              ),
                              padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
                              margin: const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(locale.value.currentPlan, style: secondaryTextStyle(color: isDarkMode.value ? white : darkGrayGeneral)),
                                      Text(locale.value.validTill, style: secondaryTextStyle(color: isDarkMode.value ? white : darkGrayGeneral)),
                                    ],
                                  ),
                                  16.height,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(userCurrentSubscription.value.name.validate(), style: boldTextStyle()),
                                      Text(
                                        userCurrentSubscription.value.endDate.toString().dateInDMMMMyyyyFormat,
                                        style: boldTextStyle(color: appColorPrimary),
                                      ),
                                    ],
                                  ),
                                  userCurrentSubscription.value.remainingLimits.isEmpty
                                      ? 16.height
                                      : Column(
                                          children: [
                                            Obx(
                                              () => Center(
                                                child: TextButton(
                                                  onPressed: () {
                                                    profileController.handleMoreInfoClick(context);
                                                  },
                                                  child: Text(
                                                    locale.value.moreInfo,
                                                    style: secondaryTextStyle(color: appColorPrimary, size: 12, weight: FontWeight.w500),
                                                  ),
                                                ),
                                              ).visible(!profileController.hideShow.value),
                                            ),
                                            AnimatedWrap(
                                              runSpacing: 10,
                                              listAnimationType: ListAnimationType.None,
                                              itemCount: userCurrentSubscription.value.remainingLimits.length,
                                              itemBuilder: (context, index) {
                                                return Row(
                                                  children: [
                                                    Marquee(
                                                      child: Text(
                                                        userCurrentSubscription.value.remainingLimits[index].limitationTitle,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: primaryTextStyle( size: 14),
                                                      ),
                                                    ).expand(),
                                                    16.width,
                                                    Text(
                                                      "${userCurrentSubscription.value.remainingLimits[index].remaining} / ${userCurrentSubscription.value.remainingLimits[index].limit} ${userCurrentSubscription.value.remainingLimits[index].key == LimitKeys.imageCount ? locale.value.images : locale.value.words}",
                                                      style: secondaryTextStyle( size: 12, weight: FontWeight.w500),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ).paddingTop(16).visible(!profileController.hideShow.value),
                                            Obx(
                                              () => Center(
                                                child: IconButton(
                                                  onPressed: () {
                                                    profileController.hideShow(!profileController.hideShow.value);
                                                  },
                                                  icon: Icon(
                                                    profileController.hideShow.value ? Icons.keyboard_arrow_down_rounded : Icons.keyboard_arrow_up_rounded,
                                                    size: 24,
                                                    color: darkGray.withOpacity(0.5),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                  10.height.visible(userCurrentSubscription.value.name=='Free')
                                ],
                              ),
                            ),
                          ),
                        ],
                      ).paddingOnly(top: 32).visible(!hasInAppStoreReview.value),
                    ),
                    if (userCurrentSubscription.value.id.isNegative || !hasInAppStoreReview.value) 32.height,
                    SettingItemWidget(
                      title: locale.value.editProfile,
                      subTitle: locale.value.personalizeYourProfile,
                      splashColor: transparentColor,
                      onTap: () {
                        Get.to(() => EditUserProfileScreen(), duration: const Duration(milliseconds: 800));
                      },
                      titleTextStyle: primaryTextStyle(),
                      leading: commonLeadingWid(imgPath: Assets.iconsIcEditProfileOutlined, color: appColorPrimary),
                      trailing: trailing,
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                    ),
                    commonDivider,
                    SettingItemWidget(
                      title: locale.value.subscriptionHistory,
                      subTitle: locale.value.seeYourSubscriptionHistory,
                      splashColor: transparentColor,
                      onTap: () {
                        Get.to(() => SubscriptionHistoryScreen());
                      },
                      titleTextStyle: primaryTextStyle(),
                      leading: commonLeadingWid(imgPath: Assets.iconsIcSubscriptionHistory, color: appColorPrimary),
                      trailing: trailing,
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                    ).visible(!hasInAppStoreReview.value),
                    commonDivider.visible(!hasInAppStoreReview.value),
                    SettingItemWidget(
                      title: locale.value.rateApp,
                      subTitle: locale.value.showSomeLoveShare,
                      splashColor: transparentColor,
                      onTap: () async {
                        handleRate();
                      },
                      titleTextStyle: primaryTextStyle(),
                      leading: commonLeadingWid(imgPath: Assets.iconsIcStar, color: appColorPrimary),
                      trailing: trailing,
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                    ),
                    commonDivider,
                    SettingItemWidget(
                      title: locale.value.aboutApp,
                      subTitle: aboutPages.length>1?locale.value.privacyPolicyTerms:aboutPages[0].name,
                      splashColor: transparentColor,
                      onTap: () {
                        Get.to(() => const AboutScreen());
                      },
                      titleTextStyle: primaryTextStyle(),
                      leading: commonLeadingWid(imgPath: Assets.iconsIcInfo, color: appColorPrimary),
                      trailing: trailing,
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                    ),
                    commonDivider,
                    SettingItemWidget(
                      title: locale.value.logout,
                      subTitle: locale.value.securelyLogOutOfAccount,
                      splashColor: transparentColor,
                      onTap: () {
                        showAppDialog(
                          context,
                          onConfirm: () {
                            profileController.handleLogout();
                          },
                          dialogType: AppDialogType.confirmation,
                          dialogText: locale.value.doYouWantToLogout,
                          titleText: locale.value.ohNoYouAreLeaving,
                          negativeText: locale.value.cancel,
                          positiveText: locale.value.logout,
                        );
                      },
                      titleTextStyle: primaryTextStyle(),
                      leading: commonLeadingWid(imgPath: Assets.iconsIcLogout, color: appColorPrimary),
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                    ),
                    30.height,
                    SnapHelperWidget<PackageInfoData>(
                      future: getPackageInfo(),
                      onSuccess: (data) {
                        return VersionInfoWidget(prefixText: 'v', textStyle: primaryTextStyle()).center();
                      },
                    ),
                    32.height,
                  ],
                ),
              ],
            ),
            Positioned(
              top: Get.height * 0.04,
              right: 16,
              child: IconButton(
                onPressed: () async {
                  Get.to(() => SettingScreen());
                },
                icon: commonLeadingWid(imgPath: Assets.iconsIcSetting, color: appColorPrimary, size: 24),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget get trailing => Icon(Icons.arrow_forward_ios, size: 12, color: darkGray.withOpacity(0.5));
}
