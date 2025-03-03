import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/components/app_scaffold.dart';
import 'package:Cortex/screens/subscription_plan/sub_scription_plan_payment_controller.dart';

import '../../generated/assets.dart';
import '../../main.dart';
import '../../utils/app_common.dart';
import '../../utils/colors.dart';
import '../../utils/common_base.dart';
import '../../utils/constants.dart';
import '../dashboard/dashboard_controller.dart';

class SubscriptionPlanPaymentScreen extends StatelessWidget {
  const SubscriptionPlanPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBartitleText: locale.value.payment,
      isLoading: subscriptionPlanPaymentController.isLoading,
      body: Stack(
        fit: StackFit.expand,
        children: [
          RefreshIndicator(
            onRefresh: () async {
              getAppConfigurations();
              return await Future.delayed(const Duration(seconds: 2));
            },
            child: Obx(
              () => SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    8.height,
                    Text(locale.value.choosePaymentMethod, style: primaryTextStyle()).paddingSymmetric(horizontal: 16),
                    16.height,
                    stripePaymentWidget(context).paddingTop(8).visible(appConfigs.value.stripePay.stripePublickey.isNotEmpty && appConfigs.value.stripePay.stripeSecretkey.isNotEmpty),
                    razorPaymentWidget(context).paddingTop(8).visible(appConfigs.value.razorPay.razorpaySecretkey.isNotEmpty),
                    payStackPaymentWidget(context).paddingTop(8).visible(appConfigs.value.paystackPay.paystackPublickey.isNotEmpty && appConfigs.value.paystackPay.paystackSecretkey.isNotEmpty),
                    payPalPaymentWidget(context).paddingTop(8).visible(appConfigs.value.paypalPay.paypalClientid.isNotEmpty && appConfigs.value.paypalPay.paypalSecretkey.isNotEmpty),
                    flutterWavePaymentWidget(context).paddingTop(8).visible(appConfigs.value.flutterwavePay.flutterwaveSecretkey.isNotEmpty && appConfigs.value.flutterwavePay.flutterwavePublickey.isNotEmpty),
                    airtelMoneyPaymentWidget(context).paddingTop(8).visible(appConfigs.value.airtelMoney.airtelSecretkey.isNotEmpty && appConfigs.value.airtelMoney.airtelClientid.isNotEmpty),
                    midtransPay(context).paddingTop(8).visible(appConfigs.value.midtransPay.midtransClientKey.isNotEmpty),
                    sadadPay(context).paddingTop(8).visible(appConfigs.value.sadadPay.sadadSecretKey.isNotEmpty && appConfigs.value.sadadPay.sadadId.isNotEmpty && appConfigs.value.sadadPay.sadadDomain.isNotEmpty),
                    cinetPay(context).paddingTop(8).visible(appConfigs.value.cinetPay.siteId.isNotEmpty && appConfigs.value.cinetPay.cinetPayAPIKey.isNotEmpty),
                  ],
                ),
              ),
            ),
          ),
          if (appConfigs.value.stripePay.stripePublickey.isNotEmpty && appConfigs.value.stripePay.stripeSecretkey.isNotEmpty ||
              appConfigs.value.razorPay.razorpaySecretkey.isNotEmpty ||
              appConfigs.value.paystackPay.paystackPublickey.isNotEmpty && appConfigs.value.paystackPay.paystackSecretkey.isNotEmpty ||
              appConfigs.value.paypalPay.paypalClientid.isNotEmpty && appConfigs.value.paypalPay.paypalSecretkey.isNotEmpty ||
              appConfigs.value.flutterwavePay.flutterwaveSecretkey.isNotEmpty && appConfigs.value.flutterwavePay.flutterwavePublickey.isNotEmpty ||
              appConfigs.value.airtelMoney.airtelSecretkey.isNotEmpty && appConfigs.value.airtelMoney.airtelClientid.isNotEmpty ||
              appConfigs.value.midtransPay.midtransClientKey.isNotEmpty ||
              appConfigs.value.sadadPay.sadadSecretKey.isNotEmpty && appConfigs.value.sadadPay.sadadId.isNotEmpty && appConfigs.value.sadadPay.sadadDomain.isNotEmpty ||
              appConfigs.value.cinetPay.siteId.isNotEmpty && appConfigs.value.cinetPay.cinetPayAPIKey.isNotEmpty)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: AppButton(
                width: Get.width,
                text: locale.value.payNow,
                textStyle: appButtonTextStyleWhite,
                onTap: () {
                  subscriptionPlanPaymentController.handlePayNowClick(context);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget stripePaymentWidget(BuildContext context) {
    return Obx(
      () => RadioListTile(
        tileColor: context.cardColor,
        controlAffinity: ListTileControlAffinity.trailing,
        shape: RoundedRectangleBorder(borderRadius: radius()),
        secondary: const Image(
          image: AssetImage(Assets.iconsIcStripeLogo),
          height: 16,
          width: 22,
        ),
        fillColor: WidgetStateProperty.all(appColorPrimary),
        title: Text("Stripe", style: primaryTextStyle()),
        value: PaymentMethods.PAYMENT_METHOD_STRIPE,
        groupValue: subscriptionPlanPaymentController.paymentOption.value,
        onChanged: (value) {
          subscriptionPlanPaymentController.paymentOption(value.toString());
        },
      ).paddingSymmetric(horizontal: 16),
    );
  }

  Widget razorPaymentWidget(BuildContext context) {
    return Obx(
      () => RadioListTile(
        tileColor: context.cardColor,
        controlAffinity: ListTileControlAffinity.trailing,
        shape: RoundedRectangleBorder(borderRadius: radius()),
        secondary: const Image(
          image: AssetImage(Assets.imagesRazorpayLogo),
          height: 16,
          width: 22,
        ),
        fillColor: WidgetStateProperty.all(appColorPrimary),
        title: Text("Razor Pay", style: primaryTextStyle()),
        value: PaymentMethods.PAYMENT_METHOD_RAZORPAY,
        groupValue: subscriptionPlanPaymentController.paymentOption.value,
        onChanged: (value) {
          subscriptionPlanPaymentController.paymentOption(value.toString());
        },
      ).paddingSymmetric(horizontal: 16),
    );
  }

  Widget payStackPaymentWidget(BuildContext context) {
    return Obx(
      () => RadioListTile(
        tileColor: context.cardColor,
        controlAffinity: ListTileControlAffinity.trailing,
        shape: RoundedRectangleBorder(borderRadius: radius()),
        secondary: const Image(
          image: AssetImage(Assets.imagesPaystackLogo),
          height: 16,
          width: 22,
        ),
        fillColor: WidgetStateProperty.all(appColorPrimary),
        title: Text("PaysStack", style: primaryTextStyle()),
        value: PaymentMethods.PAYMENT_METHOD_PAYSTACK,
        groupValue: subscriptionPlanPaymentController.paymentOption.value,
        onChanged: (value) {
          subscriptionPlanPaymentController.paymentOption(value.toString());
        },
      ).paddingSymmetric(horizontal: 16),
    );
  }

  Widget payPalPaymentWidget(BuildContext context) {
    return Obx(
      () => RadioListTile(
        tileColor: context.cardColor,
        controlAffinity: ListTileControlAffinity.trailing,
        shape: RoundedRectangleBorder(borderRadius: radius()),
        secondary: const Image(
          image: AssetImage(Assets.imagesPaypalLogo),
          height: 16,
          width: 22,
        ),
        fillColor: WidgetStateProperty.all(appColorPrimary),
        title: Text("PayPal", style: primaryTextStyle()),
        value: PaymentMethods.PAYMENT_METHOD_PAYPAL,
        groupValue: subscriptionPlanPaymentController.paymentOption.value,
        onChanged: (value) {
          subscriptionPlanPaymentController.paymentOption(value.toString());
        },
      ).paddingSymmetric(horizontal: 16),
    );
  }

  Widget flutterWavePaymentWidget(BuildContext context) {
    return Obx(
      () => RadioListTile(
        tileColor: context.cardColor,
        controlAffinity: ListTileControlAffinity.trailing,
        shape: RoundedRectangleBorder(borderRadius: radius()),
        secondary: const Image(
          image: AssetImage(Assets.imagesFlutterWaveLogo),
          height: 16,
          width: 22,
        ),
        fillColor: WidgetStateProperty.all(appColorPrimary),
        title: Text("FlutterWave", style: primaryTextStyle()),
        value: PaymentMethods.PAYMENT_METHOD_FLUTTER_WAVE,
        groupValue: subscriptionPlanPaymentController.paymentOption.value,
        onChanged: (value) {
          subscriptionPlanPaymentController.paymentOption(value.toString());
        },
      ).paddingSymmetric(horizontal: 16),
    );
  }

  Widget airtelMoneyPaymentWidget(BuildContext context) {
    return Obx(
      () => RadioListTile(
        tileColor: context.cardColor,
        controlAffinity: ListTileControlAffinity.trailing,
        shape: RoundedRectangleBorder(borderRadius: radius()),
        secondary: const Image(
          image: AssetImage(Assets.imagesAirtelLogo),
          height: 16,
          width: 22,
        ),
        fillColor: WidgetStateProperty.all(appColorPrimary),
        title: Text("Airtel Money", style: primaryTextStyle()),
        value: PaymentMethods.PAYMENT_METHOD_AIRTEL,
        groupValue: subscriptionPlanPaymentController.paymentOption.value,
        onChanged: (value) {
          subscriptionPlanPaymentController.paymentOption(value.toString());
        },
      ).paddingSymmetric(horizontal: 16),
    );
  }

  Widget midtransPay(BuildContext context) {
    return Obx(
      () => RadioListTile(
        tileColor: context.cardColor,
        controlAffinity: ListTileControlAffinity.trailing,
        shape: RoundedRectangleBorder(borderRadius: radius()),
        secondary: const Image(
          image: AssetImage(Assets.imagesMidtransLogo),
          height: 16,
          width: 22,
        ),
        fillColor: WidgetStateProperty.all(appColorPrimary),
        title: Text("Midtrans", style: primaryTextStyle()),
        value: PaymentMethods.PAYMENT_METHOD_MIDTRANS,
        groupValue: subscriptionPlanPaymentController.paymentOption.value,
        onChanged: (value) {
          subscriptionPlanPaymentController.paymentOption(value.toString());
        },
      ).paddingSymmetric(horizontal: 16),
    );
  }

  Widget sadadPay(BuildContext context) {
    return Obx(
      () => RadioListTile(
        tileColor: context.cardColor,
        controlAffinity: ListTileControlAffinity.trailing,
        shape: RoundedRectangleBorder(borderRadius: radius()),
        secondary: const Image(
          image: AssetImage(Assets.imagesSadadLogo),
          height: 16,
          width: 22,
        ),
        fillColor: WidgetStateProperty.all(appColorPrimary),
        title: Text("Sadad", style: primaryTextStyle()),
        value: PaymentMethods.PAYMENT_METHOD_SADAD,
        groupValue: subscriptionPlanPaymentController.paymentOption.value,
        onChanged: (value) {
          subscriptionPlanPaymentController.paymentOption(value.toString());
        },
      ).paddingSymmetric(horizontal: 16),
    );
  }

  Widget cinetPay(BuildContext context) {
    return Obx(
      () => RadioListTile(
        tileColor: context.cardColor,
        controlAffinity: ListTileControlAffinity.trailing,
        shape: RoundedRectangleBorder(borderRadius: radius()),
        secondary: const Image(
          image: AssetImage(Assets.imagesCinetpayLogo),
          height: 16,
          width: 22,
        ),
        fillColor: WidgetStateProperty.all(appColorPrimary),
        title: Text("CinetPay", style: primaryTextStyle()),
        value: PaymentMethods.PAYMENT_METHOD_CINETPAY,
        groupValue: subscriptionPlanPaymentController.paymentOption.value,
        onChanged: (value) {
          subscriptionPlanPaymentController.paymentOption(value.toString());
        },
      ).paddingSymmetric(horizontal: 16),
    );
  }
}
