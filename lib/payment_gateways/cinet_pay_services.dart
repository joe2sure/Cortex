import 'dart:math';
import 'package:cinetpay/cinetpay.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/main.dart';
import 'package:Cortex/utils/app_common.dart';


class CinetPayServices {
  num totalAmount;
  late Function(Map<String, dynamic>) onComplete;

  // Local Variable
  Map<String, dynamic>? response;

  CinetPayServices({
    required this.totalAmount,
    required Function(Map) onComplete,
  });

  final String transactionId = Random().nextInt(100000000).toString();

  Future<void> payWithCinetPay({required BuildContext context}) async {
    await Navigator.push(getContext, MaterialPageRoute(builder: (_) => cinetPay()));
  }

  Widget cinetPay() {
    return CinetPayCheckout(
      title: "",
      configData:  <String, dynamic>{
        'apikey': appConfigs.value.cinetPay.cinetPayAPIKey.validate(),
        'site_id': appConfigs.value.cinetPay.siteId.validate(),
        'notify_url': 'http://mondomaine.com/notify/',
        'mode': 'PRODUCTION',
      },
      paymentData: <String, dynamic>{
        'transaction_id': transactionId,
        'amount': totalAmount,
        'currency': appConfigs.value.currency.currencyCode,
        'channels': 'ALL',
        'description': 'Email: ${loginUserData.value.email}',
      },
      waitResponse: (data) {
        response = data;
        log(response);

        if (data['status'] == "REFUSED") {
          toast(locale.value.transactionFailed);
        } else if (data['status'] == "ACCEPTED") {
          toast(locale.value.transactionIsSuccessful);
          onComplete.call({
            'transaction_id': transactionId,
          });
        }
      },
      onError: (data) {
        response = data;
        log(response);
      },
    );
  }
}
