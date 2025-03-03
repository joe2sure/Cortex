import 'package:flutter/cupertino.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/main.dart';
import 'package:Cortex/utils/app_common.dart';

import '../configs.dart';
import '../network/network_utils.dart';


class SadadServices {
  String remarks;
  num totalAmount;
  late Function(Map<String, dynamic>) onComplete;

  SadadServices({
    required this.totalAmount,
    this.remarks = "",
    required Function(Map<String, dynamic>) onComplete,
  });

  //region Sadad Payment Api
  Future<String> sadadLogin(Map request) async {
    try {
      var res = await handleSadadResponse(
        await buildHttpResponse(
          '$SADAD_API_URL/api/userbusinesses/login',
          method: HttpMethodType.POST,
          request: request,
          header: buildHeaderForSadad(),
        ),
      );

      return res['accessToken'];
    } catch (e) {
      throw errorSomethingWentWrong;
    }
  }

  Future sadadCreateInvoice({required Map<String, dynamic> request, required String sadadToken}) async {
    return await handleResponse(await buildHttpResponse(
      '$SADAD_API_URL/api/invoices/createInvoice',
      method: HttpMethodType.POST,
      request: request,
      header: buildHeaderForSadad(sadadToken: sadadToken),
    ));
  }
  Future<void> payWithSadad(BuildContext context) async {
    Map request = {
      "sadadId": appConfigs.value.sadadPay.sadadId.validate(),
      "secretKey":  appConfigs.value.sadadPay.sadadSecretKey.validate(),
      "domain":  appConfigs.value.sadadPay.sadadDomain.validate(),
    };
    await sadadLogin(request).then((accessToken) async {
      await createInvoice(context, accessToken: accessToken).then((value) async {
        //
      }).catchError((e) {
        toast(e.toString());
      });
    }).catchError((e) {

      toast(e.toString());
    });
  }

  Future<void> createInvoice(BuildContext context, {required String accessToken}) async {
    Map<String, dynamic> req = {
      "countryCode": 974,
      "clientname": "${loginUserData.value.firstName} ${loginUserData.value.lastName}",
      "cellnumber": loginUserData.value.mobile.splitAfter('-'),
      "invoicedetails": [
        {
          "description": 'Name:${loginUserData.value.firstName} ${loginUserData.value.lastName} - Email: ${loginUserData.value.email}',
          "quantity": 1,
          "amount": totalAmount,
        },
      ],
      "status": 2,
      "remarks": remarks,
      "amount": totalAmount,
    };
    sadadCreateInvoice(request: req, sadadToken: accessToken).then((value) async {
      log('val:${value[0]['shareUrl']}');
      String? res;
      //String? res = await PaymentWebViewScreen(url: value[0]['shareUrl'], accessToken: accessToken).launch(context);

      if (res.validate().isNotEmpty) {
        onComplete.call({
          'transaction_id': res,
        });
      } else {
        toast(locale.value.transactionFailed, print: true);
      }
    }).catchError((e) {
      toast('Error: $e', print: true);
    });
  }
}
// Handle CinetPayment
