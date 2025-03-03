import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:Cortex/services/in_app_purchase.dart';
import 'package:Cortex/payment_gateways/pay_pal_service.dart';
import 'package:Cortex/payment_gateways/sadad_services.dart';
import 'package:Cortex/screens/subscription_plan/plan_confirmation_dialog.dart';
import 'package:Cortex/screens/subscription_plan/services/plan_services_api.dart';
import 'package:Cortex/screens/subscription_plan/subscription_plan_success_screen.dart';
import '../../configs.dart';
import '../../payment_gateways/airtel_money/airtel_money_service.dart';
import '../../payment_gateways/cinet_pay_services.dart';
import '../../payment_gateways/midtrans_service.dart';
import '../../payment_gateways/pay_stack_service.dart';
import '../../payment_gateways/razor_pay_service.dart';
import '../../payment_gateways/stripe_services.dart';
import '../../utils/app_common.dart';
import '../../utils/common_base.dart';
import '../../utils/constants.dart';
import '../dashboard/dashboard_controller.dart';
import '../dashboard/dashboard_screen.dart';
import 'models/subscription_plan_model.dart';
import 'models/subscription_plan_req.dart';

SubscriptionPlanPaymentController subscriptionPlanPaymentController = SubscriptionPlanPaymentController();

class SubscriptionPlanPaymentController {
  SubscriptionPlanReq? subscriptionPlanReq;
  List<PlanLimits>? planLimits;
  num? amount;

  SubscriptionPlanPaymentController({this.subscriptionPlanReq, this.planLimits, this.amount});

  RxString paymentOption = "".obs;
  RxBool isLoading = false.obs;

  //Options

  RazorPayService razorPayService = RazorPayService();

  PayStackService paystackServices = PayStackService();

/*  FlutterWaveService flutterWaveServices = FlutterWaveService();*/

  PayPalService payPalService = PayPalService();

  MidtransService midtransPay = MidtransService();

  handlePayNowClick(BuildContext context, {Package? selectedRevenueCatPlan}) {
    if (paymentOption.value.isEmpty) {
      toast("Please select payment gateway"); // todo : add languages
      return;
    }
    showInDialog(
      context,
      contentPadding: EdgeInsets.zero,
      builder: (context) {
        return PlanConfirmationDialog(
          onConfirm: () {
            Get.back();
            if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_STRIPE) {
              payWithStripe();
            } else if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_RAZORPAY) {
              payWithRazorPay();
            } else if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_PAYSTACK) {
              payWithPayStack();
            } else if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_FLUTTER_WAVE) {
              payWithFlutterWave(context);
            } else if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_PAYPAL) {
              payWithPaypal(context);
            } else if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_AIRTEL) {
              payWithAirtelMoney(context);
            } else if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_MIDTRANS) {
              payWithMidtrans();
            } else if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_SADAD) {
              payWithSadad(context);
            } else if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_CINETPAY) {
              payWithCinetPay(context);
            } else if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_INAPPPURCHASE) {
              payWithInAppPurchase(context, selectedRevenueCatPlan);
            }
          },
        );
      },
    );
  }

  payWithStripe() async {
    await StripeServices.stripePaymentMethod(
      loderOnOFF: (p0) {
        isLoading(p0);
      },
      amount: amount.validate(),
      onComplete: (res) {
        log('TRANSACTION_ID============================ ${res["transaction_id"]}');
        saveSubscriptionPlan(paymentType: PaymentMethods.PAYMENT_METHOD_STRIPE, txnId: res["transaction_id"], paymentStatus: PaymentStatus.PAID);
      },
    ).catchError(onError);
  }

  payWithRazorPay() async {
    isLoading(true);
    razorPayService.init(
      razorKey: appConfigs.value.razorPay.razorpaySecretkey,
      totalAmount: amount.validate(),
      onComplete: (res) {
        log("txn id: $res");
        saveSubscriptionPlan(paymentType: PaymentMethods.PAYMENT_METHOD_RAZORPAY, txnId: res["transaction_id"], paymentStatus: PaymentStatus.PAID);
      },
    );
    await Future.delayed(const Duration(seconds: 1));
    razorPayService.razorPayCheckout();
    await Future.delayed(const Duration(seconds: 2));
    isLoading(false);
  }

  payWithFlutterWave(BuildContext context) async {
    isLoading(true);
   /* flutterWaveServices.checkout(
      ctx: context,
      loderOnOFF: (p0) {
        isLoading(p0);
      },
      totalAmount: amount.validate(),
      isTestMode: appConfigs.value.flutterwavePay.flutterwavePublickey.toLowerCase().contains("test"),
      onComplete: (res) {
        saveSubscriptionPlan(paymentType: PaymentMethods.PAYMENT_METHOD_FLUTTER_WAVE, txnId: res["transaction_id"], paymentStatus: PaymentStatus.PAID);
      },
    );*/
    await Future.delayed(const Duration(seconds: 1));
    isLoading(false);
  }

  payWithPaypal(BuildContext context) {
    isLoading(true);
    payPalService.paypalCheckOut(
      context: context,
      loderOnOFF: (p0) {
        isLoading(p0);
      },
      totalAmount: amount.validate(),
      onComplete: (res) {
        saveSubscriptionPlan(paymentType: PaymentMethods.PAYMENT_METHOD_PAYPAL, txnId: res["transaction_id"], paymentStatus: PaymentStatus.PAID);
      },
    );
  }

  payWithPayStack() async {
    isLoading(true);
    await paystackServices.init(
      loderOnOFF: (p0) {
        isLoading(p0);
      },
      totalAmount: amount.validate(),
      onComplete: (res) {
        saveSubscriptionPlan(paymentType: PaymentMethods.PAYMENT_METHOD_PAYSTACK, txnId: res["transaction_id"], paymentStatus: PaymentStatus.PAID);
      },
    );
    await Future.delayed(const Duration(seconds: 1));
    isLoading(false);
    if (Get.context != null) {
      paystackServices.checkout();
    } else {
      toast("context not found!!!!");
    }
  }

  payWithAirtelMoney(BuildContext context) async {
    isLoading(true);
    showInDialog(
      context,
      contentPadding: EdgeInsets.zero,
      barrierDismissible: false,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 4, 4, 8),
              width: Get.width,
              decoration: boxDecorationDefault(
                color: context.primaryColor,
                borderRadius: radiusOnly(topRight: defaultRadius, topLeft: defaultRadius),
              ),
              child: Row(
                children: [
                  Text("Airtel Money Payment", style: boldTextStyle(color: Colors.white)).expand(),
                  const CloseButton(color: Colors.white),
                ],
              ),
            ),
            16.height,
            AirtelMoneyDialog(
              amount: amount.validate(),
              reference: APP_NAME,
              onComplete: (res) {
                log('RES: $res');
                saveSubscriptionPlan(paymentType: PaymentMethods.PAYMENT_METHOD_AIRTEL, txnId: res["transaction_id"], paymentStatus: PaymentStatus.PAID);
              },
            )
          ],
        );
      },
    ).then((value) => isLoading(false));
  }

  void payWithMidtrans() async {
    isLoading(true);
    midtransPay.initialize(
      totalAmount: amount.validate(),
      onComplete: (res) {
        log('RES: $res');
        saveSubscriptionPlan(paymentType: PaymentMethods.PAYMENT_METHOD_MIDTRANS, txnId: res["transaction_id"], paymentStatus: PaymentStatus.PAID);
      },
      loaderOnOFF: (v) {
        isLoading(v);
      },
    );
    await Future.delayed(const Duration(seconds: 1));
    midtransPay.midtransPaymentCheckout();
    await Future.delayed(const Duration(seconds: 2));
    isLoading(false);
  }

  void payWithSadad(BuildContext context) async {
    SadadServices sadadServices = SadadServices(
      totalAmount: amount.validate(),
      onComplete: (res) {
        log('RES: $res');
        saveSubscriptionPlan(paymentType: PaymentMethods.PAYMENT_METHOD_SADAD, txnId: res["transaction_id"], paymentStatus: PaymentStatus.PAID);
      },
    );
    sadadServices.payWithSadad(context);
  }

  void payWithCinetPay(BuildContext context) async {
    CinetPayServices cinetPay = CinetPayServices(
      totalAmount: amount.validate(),
      onComplete: (res) {
        log('RES: $res');
        saveSubscriptionPlan(paymentType: PaymentMethods.PAYMENT_METHOD_CINETPAY, txnId: res["transaction_id"], paymentStatus: PaymentStatus.PAID);
      },
    );
    cinetPay.payWithCinetPay(context: context);
  }

  payWithInAppPurchase(BuildContext context, Package? selectedRevenueCatPlan) async {
    InAppPurchaseService purchaseService = Get.put(InAppPurchaseService());
    if (!getBoolAsync(SharedPreferenceConst.HAS_IN_REVENUE_CAT_LOGIN_DONE_LEASE_ONCE)) purchaseService.loginToRevenueCate();

    if (selectedRevenueCatPlan != null) {
      await purchaseService.startPurchase(
        subscriptionPlanReq: subscriptionPlanReq,
        selectedRevenueCatPackage: selectedRevenueCatPlan,
        onComplete: (res) {
          subscriptionPlanReq?.gateway = 'in_app_purchase';
          subscriptionPlanReq?.paymentBy = isIOS ? "apple_payment" : "google_payment";
          subscriptionPlanReq?.gatewayMode = isIOS ? "Apple" : "Google";

          saveSubscriptionPlan(paymentType: PaymentMethods.PAYMENT_METHOD_INAPPPURCHASE, txnId: subscriptionPlanReq!.transactionId, paymentStatus: PaymentStatus.PAID);
        },
      );
    }
  }

  void onPaymentSuccess() async {
    reLoadBookingsOnDashboard();
    await Future.delayed(const Duration(milliseconds: 300));
    Get.offUntil(GetPageRoute(page: () => SubscriptionPlanSuccessScreen()), (route) => route.isFirst || route.settings.name == '/$DashboardScreen');
  }

  void reLoadBookingsOnDashboard() {
    try {
      DashboardController dashboardController = Get.put(DashboardController());
      dashboardController.currentIndex(0);
      dashboardController.reloadBottomTabs();
    } catch (e) {
      log('E: $e');
    }
  }

  ///SAVE SUBSCRIPTION API
  void saveSubscriptionPlan({required String txnId, required String paymentType, required String paymentStatus}) {
    log('PAYMENT STATUS: $paymentStatus');
    hideKeyBoardWithoutContext();
    if (subscriptionPlanReq == null) return;
    isLoading(true);

    planSuccessLimits(planLimits.validate());
    subscriptionPlanReq!.transactionId = txnId;
    subscriptionPlanReq!.paymentType = paymentType;
    subscriptionPlanReq!.paymentStatus = paymentStatus;

    /// Place Order API
    PlanServiceApi.saveSubscriptionPlanApi(subscriptionPlanReq!.toJson()).then((value) async {
      log('SAVE_SUBSCRIPTION_PLAN_API ');
      onPaymentSuccess();
      isPremiumUser(true);
    }).catchError((e) {
      toast(e.toString(), print: true);
    }).whenComplete(() => isLoading(false));
  }
}
