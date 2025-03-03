import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/components/app_dialog_widget.dart';
import 'package:Cortex/generated/assets.dart';
import '../configs.dart';
import '../screens/auth/model/about_page_res.dart';
import '../screens/auth/model/app_configuration_res.dart';
import '../screens/auth/model/login_response.dart';
import '../screens/subscription_plan/models/subscription_history_response.dart';
import '../screens/subscription_plan/models/subscription_plan_model.dart';
import 'api_end_points.dart';
import 'colors.dart';
import 'constants.dart';
import 'local_storage.dart';

RxString ipAddress = "".obs;
RxString deviceId = "".obs;
RxString selectedLanguageCode = DEFAULT_LANGUAGE.obs;
RxBool isLoggedIn = false.obs;
RxBool isPremiumUser = false.obs;
Rx<SubscriptionHistoryData> userCurrentSubscription = SubscriptionHistoryData().obs;
Rx<UserData> loginUserData = UserData().obs;
RxBool isDarkMode = false.obs;
RxBool hasInAppStoreReview = false.obs;
Rx<Currency> appCurrency = Currency().obs;
RxBool adsLoader = false.obs;
Rx<ConfigurationResponse> appConfigs = ConfigurationResponse(
  customerAppUrl: CustomerAppUrl(),
  razorPay: RazorPay(),
  stripePay: StripePay(),
  paystackPay: PaystackPay(),
  paypalPay: PaypalPay(),
  flutterwavePay: FlutterwavePay(),
  airtelMoney: AirtelMoney(),
  midtransPay: MidtransPay(),
  cinetPay: CinetPay(),
  phonepe: Phonepe(),
  sadadPay: SadadPay(),
  currency: Currency(),
).obs;

Rx<PackageInfoData> currentPackageinfo = PackageInfoData().obs;

RxList<AboutDataModel> aboutPages = RxList();

//Booking Success
RxList<PlanLimits> planSuccessLimits = RxList();

//In App Purchase
Rx<bool> isInAppPurchaseEnable=false.obs;

int get dailyUsedLimit => getValueFromLocal(APIEndPoints.checkDailyLimit) is int ? getValueFromLocal(APIEndPoints.checkDailyLimit) : 0;

int get dailyAvilableLimit => appConfigs.value.dailyLimit.isNegative ? 4 : appConfigs.value.dailyLimit;

String get lastRequestTime => getValueFromLocal(CheckDailyLimitKeys.lastRequestTime) is String ? getValueFromLocal(CheckDailyLimitKeys.lastRequestTime) : "";

// Currency position common
bool get isCurrencyPositionLeft => appCurrency.value.currencyPosition == CurrencyPosition.CURRENCY_POSITION_LEFT;

bool get isCurrencyPositionRight => appCurrency.value.currencyPosition == CurrencyPosition.CURRENCY_POSITION_RIGHT;

bool get isCurrencyPositionLeftWithSpace => appCurrency.value.currencyPosition == CurrencyPosition.CURRENCY_POSITION_LEFT_WITH_SPACE;

bool get isCurrencyPositionRightWithSpace => appCurrency.value.currencyPosition == CurrencyPosition.CURRENCY_POSITION_RIGHT_WITH_SPACE;
//endregion

// region Decoration
Decoration boxDecoration({
  BorderRadiusGeometry? borderRadius,
  Color? color,
  Gradient? gradient,
  BoxBorder? border,
  BoxShape? shape,
  BlendMode? backgroundBlendMode,
  List<BoxShadow>? boxShadow,
  DecorationImage? image,
}) {
  return boxDecorationDefault(
    color: color ?? (isDarkMode.value ? appScreenBackgroundDark : appScreenBackground),
    borderRadius: (shape != null && shape == BoxShape.circle) ? null : (borderRadius ?? radius()),
    boxShadow: boxShadow,
    gradient: gradient,
    border: border,
    shape: shape ?? BoxShape.rectangle,
    backgroundBlendMode: backgroundBlendMode,
    image: image,
  );
}
//endregion
//Widget

void showAppDialog(
  BuildContext context, {
  required VoidCallback onConfirm,
  required AppDialogType dialogType,
  required String dialogText,
  String? titleText,
  String? positiveText,
  String? negativeText,
  String? description,
  Color? buttonColor,
  TextStyle? titleTextStyle,
  TextStyle? dialogTextStyle,
  Color? confirmTextColor,
  Color? cancelTextColor,
  Widget? dialogImageWidget,
}) {
  showInDialog(
    context,
    contentPadding: EdgeInsets.zero,
    backgroundColor: buttonColor,
    builder: (p0) {
      return AppDialogWidget(
        onConfirm: () {
          onConfirm.call();
          Get.back();
        },
        dialogType: dialogType,
        buttonColor: buttonColor,
        titleText: titleText,
        titleTextStyle: titleTextStyle,
        dialogText: dialogText,
        dialogTextStyle: dialogTextStyle,
        description: description,
        negativeText: negativeText,
        cancelTextColor: cancelTextColor,
        positiveText: positiveText,
        confirmTextColor: confirmTextColor,
        dialogImageWidget: dialogImageWidget,
      );
    },
  );
}

String getDialogImage(AppDialogType dialogType, {double? size}) {
  String image;
  switch (dialogType) {
    case AppDialogType.confirmation:
      image = Assets.iconsIcConfirm;
      break;
    case AppDialogType.accept:
      image = Assets.iconsIcDoneDialog;
      break;
    case AppDialogType.delete:
      image = Assets.iconsIcDeleteDialog;
      break;
    case AppDialogType.update:
      image = Assets.iconsIcUpdateDialog;
      break;
    case AppDialogType.add:
      image = Assets.iconsIcCheck;
      break;
  }
  return image;
}
//endRegion
