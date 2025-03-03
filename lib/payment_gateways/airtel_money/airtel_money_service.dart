import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:Cortex/utils/colors.dart';
import '../../components/loader_widget.dart';
import '../../configs.dart';
import '../../generated/assets.dart';
import '../../main.dart';
import '../../network/network_utils.dart';
import '../../screens/subscription_plan/components/subscription_image_component.dart';
import '../../utils/app_common.dart';
import '../../utils/common_base.dart';
import '../../utils/constants.dart';
import 'airtel_payment_response.dart';
import 'package:uuid/uuid.dart';
import 'aritel_auth_model.dart';

class AirtelMoneyDialog extends StatefulWidget {
  final String reference;
  //final int bookingId;
  final num amount;
  final Function(Map<String, dynamic>) onComplete;
  const AirtelMoneyDialog({
    super.key,
    required this.onComplete,
    required this.reference,
  //  required this.bookingId,
    required this.amount,
  });

  @override
  State<AirtelMoneyDialog> createState() => _AirtelMoneyDialogState();
}

class _AirtelMoneyDialogState extends State<AirtelMoneyDialog> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController _textFieldMSISDN = TextEditingController();

  FocusNode msisdnFocus=FocusNode();

  bool isTxnInProgress = false;
  bool isSuccess = false;
  bool isFailToGenerateReq = false;
  String responseCode = "";

  RxBool isLoading = false.obs;

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: Get.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              isFailToGenerateReq
                  ? Column(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.redAccent),
                          child: const Icon(Icons.close_sharp, color: Colors.white),
                        ),
                        10.height,
                        Text(getAirtelMoneyReasonTextFromCode(responseCode).$1, style: boldTextStyle()),
                        16.height,
                        Text(getAirtelMoneyReasonTextFromCode(responseCode).$2, textAlign: TextAlign.center, style: secondaryTextStyle()),
                      ],
                    ).paddingAll(16)
                  : isSuccess
                      ? Column(
                          children: [
                            16.height,
                            SizedBox(
                              width: Get.width * 0.8,
                              child: Text(
                                locale.value.youllBeUseAllTheMentionFeaturesOfOurVizionAi,
                                textAlign: TextAlign.center,
                                style: secondaryTextStyle(color: secondaryTextColor),
                              ),
                            ),
                            Obx(() => 32.height.visible(planSuccessLimits.isNotEmpty)),
                            Obx(
                                  () => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                decoration: boxDecorationDefault(color: primaryTextColor, shape: BoxShape.rectangle),
                                child: AnimatedWrap(
                                  runSpacing: 10,
                                  listAnimationType: ListAnimationType.None,
                                  itemCount: planSuccessLimits.length,
                                  itemBuilder: (context, index) => Row(
                                    children: [
                                      SubIconWithText(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        title: planSuccessLimits[index].limitationTitle,
                                        icon: Image.asset(Assets.iconsIcCheck, width: 14, height: 14),
                                        textSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ).expand(),
                                      16.width,
                                      Text(
                                        "${planSuccessLimits[index].limit} ${planSuccessLimits[index].key == LimitKeys.imageCount ? locale.value.images : locale.value.words}",
                                        style: secondaryTextStyle(color: appColorSecondary, size: 12, weight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                ),
                              ).visible(planSuccessLimits.isNotEmpty),
                            ),
                            58.height,
                            AppButton(
                              width: Get.width,
                              text: locale.value.goToHome,
                              textStyle: appButtonTextStyleWhite,
                              onTap: () {
                                /// To Clear Value
                                planSuccessLimits([]);
                                Get.back();
                              },
                            ),
                            16.height,
                          ],
                        ).paddingAll(16)
                      : isTxnInProgress
                          ? Column(
                              children: [
                                const LoaderWidget(),
                                10.height,
                                Text(locale.value.transactionIsInProcess, style: boldTextStyle()),
                                16.height,
                                Text(locale.value.pleaseCheckThePayment, textAlign: TextAlign.center, style: secondaryTextStyle()),
                              ],
                            ).paddingAll(16)
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Form(
                                  key: formKey,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  child: AppTextField(
                                    focus: msisdnFocus,
                                    controller: _textFieldMSISDN,
                                    textFieldType: TextFieldType.NAME,
                                    decoration: inputDecoration(context, labelText: locale.value.enterYourMsisdnHere),
                                  ),
                                ),
                                16.height,
                                AppButton(
                                  color: appColorPrimary,
                                  height: 30,
                                  text: locale.value.submit,
                                  textStyle: primaryTextStyle(color: Colors.white),
                                  width: Get.width - context.navigationBarHeight,
                                  onTap: () {
                                    hideKeyboard(context);
                                    maxApiCallCount = 30;
                                    _handleClick();
                                  },
                                ),
                              ],
                            ).paddingAll(16)
            ],
          ),
        ),
        Obx(
          () => const LoaderWidget().withSize(height: 80, width: 80).visible(isLoading.value && !isTxnInProgress),
        )
      ],
    );
  }

  void _handleClick() async {
    String transactionId = const Uuid().v1();

    isFailToGenerateReq = false;
    responseCode = "";

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      isLoading(true);
      await authorizeAirtelClient().then((value) async {
        log('acess tokn ${value.accessToken}');
        await paymentAirtelClient(
          reference: APP_NAME,
          txnId: transactionId,
          msisdn: _textFieldMSISDN.text.trim(),
          amount: widget.amount,
          accessToken: value.accessToken.validate(),
        ).then((value) async {
          if (value.status != null && value.status!.responseCode == AirtelMoneyResponseCodes.IN_PROCESS) {
            isTxnInProgress = true;
            setState(() {});
            isSuccess = await checkAirtelPaymentStatus(
              transactionId,
              loderOnOFF: (p0) {
                isLoading(p0);
              },
            );
            setState(() {});
            if (isSuccess) {
              widget.onComplete.call({
                'transaction_id': transactionId,
              });
            }
          } else if (value.status != null) {
            isFailToGenerateReq = true;
            responseCode = value.status!.responseCode.validate();
            setState(() {});
          }
        });
        isLoading(false);
      });
    }
  }
}

//region airtel pay
Future<AirtelAuthModel> authorizeAirtelClient() async {

  Map<dynamic, dynamic>? request = {"client_id": appConfigs.value.airtelMoney.airtelClientid, "client_secret": appConfigs.value.airtelMoney.airtelSecretkey, "grant_type": "client_credentials"};
  return AirtelAuthModel.fromJson(await handleResponse(await airtelPayBuildHttpResponse('auth/oauth2/token', request: request, method: HttpMethodType.POST)));
}

Future<AirtelPaymentResponse> paymentAirtelClient({
  required String reference,
  required String accessToken,
  required String txnId,
  required String msisdn,
  required num amount,
}) async {
  Map<dynamic, dynamic>? request = {
    "reference": reference,
    "subscriber": {"country": airtel_country_code, "currency": airtel_currency_code, "msisdn": msisdn},
    "transaction": {"amount": amount, "country": airtel_country_code, "currency": airtel_currency_code, "id": txnId}
  };

  return AirtelPaymentResponse.fromJson(
    await handleResponse(
      await airtelPayBuildHttpResponse(
        'merchant/v1/payments/',
        request: request,
        method: HttpMethodType.POST,
        extraKeys: {'X-Country': airtel_country_code, 'X-Currency': airtel_currency_code, 'access_token': accessToken, 'isAirtelMoney': true},
      ),
    ),
  );
}

int maxApiCallCount = 30;
AirtelPaymentResponse res = AirtelPaymentResponse();
Future<bool> checkAirtelPaymentStatus(
  String txnId, {
  required Function(bool) loderOnOFF,
}) async {
  bool isSuccess = false;
  if (maxApiCallCount <= 0) {
    return isSuccess;
  }
  await authorizeAirtelClient().then((value) async {
    log('acess tokn ${value.accessToken}');
    log('maxApiCallCount is $maxApiCallCount');

    res = AirtelPaymentResponse.fromJson(await handleResponse(
        await airtelPayBuildHttpResponse('standard/v1/payments/$txnId', extraKeys: {'X-Country': airtel_country_code, 'X-Currency': airtel_currency_code, 'access_token': '${value.accessToken}', 'isAirtelMoney': true}, method: HttpMethodType.GET)));
    if (res.status != null && res.status!.responseCode == AirtelMoneyResponseCodes.SUCCESS) {
      isSuccess = true;
      return isSuccess;
    } else if (maxApiCallCount > 0 && res.status != null && res.status!.responseCode == AirtelMoneyResponseCodes.IN_PROCESS) {
      await Future.delayed(const Duration(seconds: 2));
      maxApiCallCount--;
      // toast("$maxApiCallCount");
      isSuccess = await checkAirtelPaymentStatus(txnId, loderOnOFF: loderOnOFF);
    } else {
      loderOnOFF(false);
      log('return here');
      return isSuccess;
    }
  });
  return isSuccess;
}

Future<Response> airtelPayBuildHttpResponse(
  String endPoint, {
  HttpMethodType method = HttpMethodType.GET,
  Map? request,
  Map? extraKeys,
}) async {
  if (await isNetworkAvailable()) {
    var headers = buildHeaderForAirtelMoney(extraKeys!['access_token'], extraKeys['X-Country'], extraKeys['X-Currency']);
    //  Uri url = buildBaseUrl(endPoint);
    Uri url = Uri.parse(endPoint);
    url = Uri.parse('$AIRTEL_BASE$endPoint');

    Response response;
    log('url : $url');
    if (method == HttpMethodType.POST) {
      log('Request: ${jsonEncode(request)}');
      response = await http.post(url, body: jsonEncode(request), headers: headers);
    } else if (method == HttpMethodType.DELETE) {
      response = await delete(url, headers: headers);
    } else if (method == HttpMethodType.PUT) {
      response = await put(url, body: jsonEncode(request), headers: headers);
    } else {
      response = await get(url, headers: headers);
    }

    log('Response (${method.name}) ${response.statusCode}: ${response.body}');

    return response;
  } else {
    throw errorInternetNotAvailable;
  }
}
