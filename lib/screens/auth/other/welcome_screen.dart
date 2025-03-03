import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/utils/colors.dart';
import '../../../components/app_scaffold.dart';
import '../../../generated/assets.dart';
import '../../../main.dart';
import '../../../utils/constants.dart';
import '../../dashboard/dashboard_screen.dart';
import '../../home/home_controller.dart';
import '../sign_in_sign_up/signin_screen.dart';
import 'welcome_controller.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});
  final WelcomeScreenController optionScreenController = Get.put(WelcomeScreenController());

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      hideAppBar: true,
      scaffoldBackgroundColor: canvasColor,
      isLoading: optionScreenController.isLoading,
      body: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Image.asset(
                  Assets.imagesWelcomeCurveTop,
                ),
              ),
              Flexible(
                child: Image.asset(
                  Assets.imagesWelcomeCurveTop,
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(Assets.imagesAiImage).paddingSymmetric(horizontal: 31).paddingTop(114),
                Text(
                  locale.value.experienceAisBrillianceFeatures,
                  textAlign: TextAlign.center,
                  style: primaryTextStyle(color: whiteTextColor, size: 32),
                ).paddingSymmetric(vertical: 35, horizontal: 30),
                Column(
                  children: [
                    Row(
                      children: [
                        AppButton(
                          height: 52,
                          elevation: 0,
                          color: appColorSecondary,
                          onTap: () {
                            Get.to(
                              () => SignInScreen(),
                              arguments: true,
                              binding: BindingsBuilder(() {
                                setStatusBarColor(transparentColor, statusBarIconBrightness: Brightness.light, statusBarBrightness: Brightness.light);
                              }),
                            );
                          },
                          child: Text(
                            locale.value.signIN,
                            style: boldTextStyle(
                              fontFamily: FontFamilyConst.archiaFont,
                              size: 12,
                              color: blackTextColor,
                              weight: FontWeight.w400,
                            ),
                          ),
                        ).expand(),
                        24.width,
                        AppButton(
                          height: 52,
                          elevation: 0,
                          color: appColorPrimary,
                          onTap: () {
                            optionScreenController.isLoading(true);
                            Get.offAll(() => DashboardScreen(), binding: BindingsBuilder(() {
                              Get.put(HomeController());
                            }));
                          },
                          child: Text(
                            locale.value.explore,
                            style: boldTextStyle(
                              fontFamily: FontFamilyConst.archiaFont,
                              size: 12,
                              color: whiteTextColor,
                              weight: FontWeight.w400,
                            ),
                          ),
                        ).expand(),
                      ],
                    ).paddingSymmetric(horizontal: 24).paddingBottom(30),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
