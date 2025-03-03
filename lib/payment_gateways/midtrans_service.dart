import 'package:flutter/foundation.dart';
import 'package:midpay/midpay.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/utils/app_common.dart';

class MidtransService {
  Midpay midpay=Midpay();
  num totalAmount = 0;
  int serviceId = 0;
  num servicePrice = 0;
  String serviceName = '';
  late Function(Map<String, dynamic>) onComplete;
  late Function(bool) loaderOnOFF;

  initialize({
    required num totalAmount,
    required Function(Map<String, dynamic>) onComplete,
    required Function(bool) loaderOnOFF,
  }) {
    this.totalAmount = totalAmount;
    this.onComplete = onComplete;
    this.loaderOnOFF = loaderOnOFF;
  }

  Future midtransPaymentCheckout() async {
    //for android auto sandbox when debug and production when release

    midpay.init(
      appConfigs.value.midtransPay.midtransClientKey.validate(),
      kDebugMode ? "https://app.sandbox.midtrans.com/snap/v1/transactions/" : 'https://app.midtrans.com/snap/v1/transactions/',
      environment: kDebugMode ? Environment.sandbox : Environment.production,
    );

    var midtransCustomer = MidtransCustomer(loginUserData.value.firstName, loginUserData.value.lastName, loginUserData.value.email, loginUserData.value.mobile);

    List<MidtransItem> listitems = [];

    var midtransTransaction = MidtransTransaction(totalAmount.toInt() /*100000*/, midtransCustomer, listitems, skipCustomer: true); //TODO: check

    midpay.makePayment(midtransTransaction).catchError((err) => log("ERROR $err"));

    midpay.setFinishCallback(_callback);
  }

  //callback
  Future<void> _callback(TransactionFinished finished) async {
    log("Finish $finished");
    return Future.value(null);
  }
}
