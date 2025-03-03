import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../configs.dart';
import '../utils/app_common.dart';

class PayStackService {
  PaystackPlugin paystackPlugin = PaystackPlugin();
  num totalAmount = 0;
  late Function(Map<String, dynamic>) onComplete;
  late Function(bool) loderOnOFF;

  init({required num totalAmount, required Function(Map<String, dynamic>) onComplete, required Function(bool) loderOnOFF}) {
    paystackPlugin.initialize(publicKey: appConfigs.value.paystackPay.paystackPublickey.validate());
    this.totalAmount = totalAmount;
    this.onComplete = onComplete;
    this.loderOnOFF = loderOnOFF;
  }

  Future checkout() async {
    loderOnOFF(true);
    int price = totalAmount.toInt() * 100;
    Charge charge = Charge()
      ..amount = price
      ..reference = 'ref_${DateTime.now().millisecondsSinceEpoch}'
      ..email = loginUserData.value.email
      ..currency = isIqonicProduct ? payStackCurrency : appCurrency.value.currencyCode; //Todo appCurrency.value.currencyCode

    CheckoutResponse response = await paystackPlugin.checkout(
      Get.context!,
      method: CheckoutMethod.card,
      charge: charge,
    );

    log('Response: $response');

    if (response.status == true) {
      log('Response $response');
      onComplete.call({
        'transaction_id': response.reference.validate(),
      });
      loderOnOFF(false);
      log('Payment was successful. Ref: ${response.reference}');
    } else {
      loderOnOFF(false);
      toast(response.message, print: true);
    }
  }
}
