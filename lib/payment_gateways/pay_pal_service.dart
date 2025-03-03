import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../configs.dart';
import '../utils/app_common.dart';

class PayPalService {
  Future paypalCheckOut({required BuildContext context, required num totalAmount, required Function(Map<String, dynamic>) onComplete, required Function(bool) loderOnOFF}) async {
    loderOnOFF(true);
    String payPalClientId = appConfigs.value.paypalPay.paypalClientid.validate();
    String secretKey = appConfigs.value.paypalPay.paypalSecretkey.validate();
    log('PAYPALCLIENTID: $payPalClientId');
    log('SECRETKEY: $secretKey');
    PaypalCheckout(
      sandboxMode: (!kReleaseMode || isIqonicProduct),
      clientId: payPalClientId,
      secretKey: secretKey,
      returnURL: "junedr375.github.io/junedr375-payment/",
      cancelURL: "junedr375.github.io/junedr375-payment/error.html",
      transactions: [
        {
          "amount": {
            "total": totalAmount,
            "currency": isIqonicProduct ? payPalSupportedCurrency : appCurrency.value.currencyCode,
            "details": {"subtotal": totalAmount, "shipping": '0', "shipping_discount": 0}
          },
          "description": 'Name: ${loginUserData.value.userName} - Email: ${loginUserData.value.email}',
        }
      ],
      note: " - ",
      onSuccess: (Map params) async {
        log("onSuccess: $params");
        loderOnOFF(false);
        if (params['message'] is String) {
          toast(params['message']);
        }
        onComplete.call({
          'transaction_id': params['data']['id'],
        });
      },
      onError: (error) {
        log("onError: $error");
        loderOnOFF(false);
        toast(error);
        Get.back();
      },
      onCancel: (params) {
        log("cancelled: $params");
        toast('cancelled');
        loderOnOFF(false);
      },
    ).launch(context).whenComplete(() => loderOnOFF(false)).onError((e, stackTrace) {
      toast(e.toString());
      loderOnOFF(false);
    });
  }
}
