// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/utils/colors.dart';

import '../../configs.dart';
import '../network/network_utils.dart';
import '../utils/app_common.dart';
import '../utils/constants.dart';

class StripeServices {
  static Future<void> stripePaymentMethod({required num amount, required Function(bool) loderOnOFF, required Function(Map<String, dynamic>) onComplete}) async {
    loderOnOFF(true);
    try {
      Stripe.publishableKey = appConfigs.value.stripePay.stripePublickey;
      Stripe.merchantIdentifier = STRIPE_merchantIdentifier;

      await Stripe.instance.applySettings().catchError((e) {
        toast(e.toString(), print: true);
        throw e.toString();
      });
      final paysheetData = await getStripePaymentIntents(amount: amount, loderOnOFF: loderOnOFF);
      String? clientSecret = paysheetData == null ? null : paysheetData["client_secret"];
      String? tnxId = paysheetData == null ? null : paysheetData["transaction_id"];
      SetupPaymentSheetParameters setupPaymentSheetParameters = SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        style: isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
        appearance: const PaymentSheetAppearance(colors: PaymentSheetAppearanceColors(primary: appColorPrimary)),
        merchantDisplayName: APP_NAME,
        customerId: loginUserData.value.email,
        // customerEphemeralKeySecret: isAndroid ? clientSecret : null,
        setupIntentClientSecret: clientSecret,
        billingDetails: BillingDetails(
          name: loginUserData.value.userName,
          email: loginUserData.value.email,
          address: Address(
            city: "",
            country: defaultCountry.countryCode,
            line1: "",
            line2: "",
            postalCode: "",
            state: "",
          ),
        ),
      );

      await Stripe.instance.initPaymentSheet(paymentSheetParameters: setupPaymentSheetParameters).then((value) async {
        await Stripe.instance.presentPaymentSheet().then((val) async {
          onComplete.call({
            'transaction_id': tnxId,
          });
        }).catchError((e) {
          if (e.toString().contains("The payment flow has been canceled")) {
            toast("The payment flow has been canceled.");    //TODO String Translation
          } else {
            toast(e.toString());
          }
          log('Stripe present sheet method: $e');
        });
      }).catchError((e) {
        toast(e.toString());
        log('Stripe init sheet method: $e');
      });
    } catch (e) {
      toast(e.toString());
      log('stripePaymentMethod catch: $e');
    }
  }

  static Future<Map<String, dynamic>?> getStripePaymentIntents({required num amount, required Function(bool) loderOnOFF}) async {
    try {
      var headers = {
        'Authorization': 'Bearer ${appConfigs.value.stripePay.stripeSecretkey}',
        'Content-Type': 'application/x-www-form-urlencoded',
      };

      var request = http.Request('POST', Uri.parse(STRIPE_URL));

      request.bodyFields = {
        'amount': (amount * 100).toInt().toString(),
        'currency': isIqonicProduct ? STRIPE_CURRENCY_CODE : appCurrency.value.currencyCode,
        'description': 'Name: ${loginUserData.value.userName} - Email: ${loginUserData.value.email}',
      };

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      var res = jsonDecode(await response.stream.bytesToString());

      log('RESPONSE: ${response.reasonPhrase}');

      apiPrint(
        url: STRIPE_URL,
        request: jsonEncode(request.bodyFields),
        responseBody: jsonEncode(res),
        statusCode: response.statusCode,
      );
      if (response.statusCode == 200) {
        log("Response: $res");
        loderOnOFF.call(false);
        var paymentDetail = {"transaction_id": res["id"], "client_secret": res["client_secret"]};
        return paymentDetail;
      } else {
        loderOnOFF.call(false);
      }
    } catch (e) {
      toast(e.toString(), print: true);
    }
    return null;
  }
}
