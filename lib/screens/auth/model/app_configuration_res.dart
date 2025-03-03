import '../../../utils/constants.dart';

class ConfigurationResponse {
  CustomerAppUrl customerAppUrl;
  RazorPay razorPay;
  StripePay stripePay;
  PaystackPay paystackPay;
  PaypalPay paypalPay;
  FlutterwavePay flutterwavePay;
  AirtelMoney airtelMoney;
  Phonepe phonepe;
  MidtransPay midtransPay;
  CinetPay cinetPay;
  SadadPay sadadPay;

  int isForceUpdateforAndroid;
  int androidMinimumForceUpdateCode;
  int androidLatestVersionUpdateCode;
  int isForceUpdateforIos;
  int isoMinimumForceUpdateCode;
  int isoLatestVersionUpdateCode;
  Currency currency;
  String siteDescription;
  int isUserPushNotification;
  int enableChatGpt;
  int testWithoutKey;
  String chatgptKey;
  int enableAds;
  String interstitialAdId;
  String nativeAdId;
  String bannerAdId;
  String openAdId;
  String rewardedAdId;
  String rewardinterstitialAdId;
  int enableIosAds;
  String iosInterstitialAdId;
  String iosNativeAdId;
  String iosBannerAdId;
  String iosOpenAdId;
  String iosRewardedAdId;
  String iosRewardinterstitialAdId;
  int enablePicsart;
  String picsartKey;
  int enableCutoutpro;
  String cutoutproKey;
  int enableGemini;
  String geminiKey;
  String notification;
  String firebaseKey;
  int inAppPurchase;
  String applicationLanguage;
  bool status;
  int dailyLimit;
  String entitlementId;
  String appleAPIKey;
  String googleAPIKey;
  int isInAppPurchaseEnable;

  ConfigurationResponse({
    required this.customerAppUrl,
    required this.razorPay,
    required this.stripePay,
    required this.paystackPay,
    required this.paypalPay,
    required this.flutterwavePay,
    required this.airtelMoney,
    required this.phonepe,
    required this.midtransPay,
    required this.cinetPay,
    required this.sadadPay,
    this.isForceUpdateforAndroid = -1,
    this.androidMinimumForceUpdateCode = -1,
    this.androidLatestVersionUpdateCode = -1,
    this.isForceUpdateforIos = -1,
    this.isoMinimumForceUpdateCode = -1,
    this.isoLatestVersionUpdateCode = -1,
    required this.currency,
    this.siteDescription = "",
    this.isUserPushNotification = -1,
    this.enableChatGpt = -1,
    this.testWithoutKey = -1,
    this.chatgptKey = "",
    this.enableAds = -1,
    this.interstitialAdId = "",
    this.nativeAdId = "",
    this.bannerAdId = "",
    this.openAdId = "",
    this.rewardedAdId = "",
    this.rewardinterstitialAdId = "",
    this.enableIosAds = -1,
    this.iosInterstitialAdId = "",
    this.iosNativeAdId = "",
    this.iosBannerAdId = "",
    this.iosOpenAdId = "",
    this.iosRewardedAdId = "",
    this.iosRewardinterstitialAdId = "",
    this.enablePicsart = -1,
    this.picsartKey = "",
    this.enableCutoutpro = -1,
    this.cutoutproKey = "",
    this.enableGemini = -1,
    this.geminiKey = "",
    this.notification = "",
    this.firebaseKey = "",
    this.inAppPurchase = -1,
    this.applicationLanguage = "",
    this.status = false,
    this.dailyLimit = -1,
    this.entitlementId = "",
    this.appleAPIKey = "",
    this.googleAPIKey = "",
    this.isInAppPurchaseEnable = 0,
  });

  factory ConfigurationResponse.fromJson(Map<String, dynamic> json) {
    return ConfigurationResponse(
      customerAppUrl: json['customer_app_url'] is Map ? CustomerAppUrl.fromJson(json['customer_app_url']) : CustomerAppUrl(),
      razorPay: json['razor_pay'] is Map ? RazorPay.fromJson(json['razor_pay']) : RazorPay(),
      stripePay: json['stripe_pay'] is Map ? StripePay.fromJson(json['stripe_pay']) : StripePay(),
      paystackPay: json['paystack_pay'] is Map ? PaystackPay.fromJson(json['paystack_pay']) : PaystackPay(),
      paypalPay: json['paypal_pay'] is Map ? PaypalPay.fromJson(json['paypal_pay']) : PaypalPay(),
      flutterwavePay: json['flutterwave_pay'] is Map ? FlutterwavePay.fromJson(json['flutterwave_pay']) : FlutterwavePay(),
      airtelMoney: json['airtel_pay'] is Map ? AirtelMoney.fromJson(json['airtel_pay']) : AirtelMoney(),
      phonepe: json['phonepay_pay'] is Map ? Phonepe.fromJson(json['phonepay_pay']) : Phonepe(),
      midtransPay: json['midtrans_pay'] is Map ? MidtransPay.fromJson(json['midtrans_pay']) : MidtransPay(),
      cinetPay: json['cinet_pay'] is Map ? CinetPay.fromJson(json['cinet_pay']) : CinetPay(),
      sadadPay: json['sadad_pay'] is Map ? SadadPay.fromJson(json['sadad_pay']) : SadadPay(),
      isForceUpdateforAndroid: json['isForceUpdateforAndroid'] is int ? json['isForceUpdateforAndroid'] : -1,
      androidMinimumForceUpdateCode: json['android_minimum_force_update_code'] is int ? json['android_minimum_force_update_code'] : -1,
      androidLatestVersionUpdateCode: json['android_latest_version_update_code'] is int ? json['android_latest_version_update_code'] : -1,
      isForceUpdateforIos: json['isForceUpdateforIos'] is int ? json['isForceUpdateforIos'] : -1,
      isoMinimumForceUpdateCode: json['iso_minimum_force_update_code'] is int ? json['iso_minimum_force_update_code'] : -1,
      isoLatestVersionUpdateCode: json['iso_latest_version_update_code'] is int ? json['iso_latest_version_update_code'] : -1,
      currency: json['currency'] is Map ? Currency.fromJson(json['currency']) : Currency(),
      siteDescription: json['site_description'] is String ? json['site_description'] : "",
      isUserPushNotification: json['is_user_push_notification'] is int ? json['is_user_push_notification'] : -1,
      enableChatGpt: json['enable_chat_gpt'] is int ? json['enable_chat_gpt'] : -1,
      testWithoutKey: json['test_without_key'] is int ? json['test_without_key'] : -1,
      chatgptKey: json['chatgpt_key'] is String ? json['chatgpt_key'] : "",
      enableAds: json['enable_ads'] is int ? json['enable_ads'] : -1,
      interstitialAdId: json['interstitial_ad_id'] is String ? json['interstitial_ad_id'] : "",
      nativeAdId: json['native_ad_id'] is String ? json['native_ad_id'] : "",
      bannerAdId: json['banner_ad_id'] is String ? json['banner_ad_id'] : "",
      openAdId: json['open_ad_id'] is String ? json['open_ad_id'] : "",
      rewardedAdId: json['rewarded_ad_id'] is String ? json['rewarded_ad_id'] : "",
      rewardinterstitialAdId: json['rewardinterstitial_ad_id'] is String ? json['rewardinterstitial_ad_id'] : "",
      enableIosAds: json['enable_ios_ads'] is int ? json['enable_ios_ads'] : -1,
      iosInterstitialAdId: json['ios_interstitial_ad_id'] is String ? json['ios_interstitial_ad_id'] : "",
      iosNativeAdId: json['ios_native_ad_id'] is String ? json['ios_native_ad_id'] : "",
      iosBannerAdId: json['ios_banner_ad_id'] is String ? json['ios_banner_ad_id'] : "",
      iosOpenAdId: json['ios_open_ad_id'] is String ? json['ios_open_ad_id'] : "",
      iosRewardedAdId: json['ios_rewarded_ad_id'] is String ? json['ios_rewarded_ad_id'] : "",
      iosRewardinterstitialAdId: json['ios_rewardinterstitial_ad_id'] is String ? json['ios_rewardinterstitial_ad_id'] : "",
      enablePicsart: json['enable_picsart'] is int ? json['enable_picsart'] : -1,
      picsartKey: json['picsart_key'] is String ? json['picsart_key'] : "",
      enableCutoutpro: json['enable_cutoutpro'] is int ? json['enable_cutoutpro'] : -1,
      cutoutproKey: json['cutoutpro_key'] is String ? json['cutoutpro_key'] : "",
      enableGemini: json['enable_gemini'] is int ? json['enable_gemini'] : -1,
      geminiKey: json['gemini_key'] is String ? json['gemini_key'] : "",
      notification: json['notification'] is String ? json['notification'] : "",
      firebaseKey: json['firebase_key'] is String ? json['firebase_key'] : "",
      inAppPurchase: json['in_app_purchase'] is int ? json['in_app_purchase'] : -1,
      applicationLanguage: json['application_language'] is String ? json['application_language'] : "",
      status: json['status'] is bool ? json['status'] : false,
      dailyLimit: json['daily_limit'] is int ? json['daily_limit'] : -1,
      entitlementId: json['entitlement_id'] is String ? json['entitlement_id'] : "",
      appleAPIKey: json['apple_public_api_key'] is String ? json['apple_public_api_key'] : "",
      googleAPIKey: json['google_public_api_key'] is String ? json['google_public_api_key'] : "",
      isInAppPurchaseEnable: json['is_in_app_purchase_enable'] is int ? json['is_in_app_purchase_enable'] : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_app_url': customerAppUrl.toJson(),
      'razor_pay': razorPay.toJson(),
      'stripe_pay': stripePay.toJson(),
      'paystack_pay': paystackPay.toJson(),
      'paypal_pay': paypalPay.toJson(),
      'flutterwave_pay': flutterwavePay.toJson(),
      'airtel_pay': airtelMoney.toJson(),
      'phonepay_pay': phonepe.toJson(),
      'isForceUpdateforAndroid': isForceUpdateforAndroid,
      'android_minimum_force_update_code': androidMinimumForceUpdateCode,
      'android_latest_version_update_code': androidLatestVersionUpdateCode,
      'isForceUpdateforIos': isForceUpdateforIos,
      'iso_minimum_force_update_code': isoMinimumForceUpdateCode,
      'iso_latest_version_update_code': isoLatestVersionUpdateCode,
      'currency': currency.toJson(),
      'site_description': siteDescription,
      'is_user_push_notification': isUserPushNotification,
      'enable_chat_gpt': enableChatGpt,
      'test_without_key': testWithoutKey,
      'chatgpt_key': chatgptKey,
      'enable_ads': enableAds,
      'interstitial_ad_id': interstitialAdId,
      'native_ad_id': nativeAdId,
      'banner_ad_id': bannerAdId,
      'open_ad_id': openAdId,
      'rewarded_ad_id': rewardedAdId,
      'rewardinterstitial_ad_id': rewardinterstitialAdId,
      'enable_ios_ads': enableIosAds,
      'ios_interstitial_ad_id': iosInterstitialAdId,
      'ios_native_ad_id': iosNativeAdId,
      'ios_banner_ad_id': iosBannerAdId,
      'ios_open_ad_id': iosOpenAdId,
      'ios_rewarded_ad_id': iosRewardedAdId,
      'ios_rewardinterstitial_ad_id': iosRewardinterstitialAdId,
      'enable_picsart': enablePicsart,
      'picsart_key': picsartKey,
      'enable_cutoutpro': enableCutoutpro,
      'cutoutpro_key': cutoutproKey,
      'enable_gemini': enableGemini,
      'gemini_key': geminiKey,
      'notification': notification,
      'firebase_key': firebaseKey,
      'in_app_purchase': inAppPurchase,
      'application_language': applicationLanguage,
      'status': status,
      'daily_limit': dailyLimit,
      'entitlement_id': entitlementId,
      'apple_public_api_key': appleAPIKey,
      'google_public_api_key': googleAPIKey,
      'is_in_app_purchase_enable': isInAppPurchaseEnable,
    };
  }
}

class CustomerAppUrl {
  String customerAppPlayStore;
  String customerAppAppStore;

  CustomerAppUrl({
    this.customerAppPlayStore = "",
    this.customerAppAppStore = "",
  });

  factory CustomerAppUrl.fromJson(Map<String, dynamic> json) {
    return CustomerAppUrl(
      customerAppPlayStore: json['customer_app_play_store'] is String ? json['customer_app_play_store'] : "",
      customerAppAppStore: json['customer_app_app_store'] is String ? json['customer_app_app_store'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_app_play_store': customerAppPlayStore,
      'customer_app_app_store': customerAppAppStore,
    };
  }
}

class RazorPay {
  String razorpaySecretkey;
  String razorpayPublickey;

  RazorPay({
    this.razorpaySecretkey = "",
    this.razorpayPublickey = "",
  });

  factory RazorPay.fromJson(Map<String, dynamic> json) {
    return RazorPay(
      razorpaySecretkey: json['razorpay_secretkey'] is String ? json['razorpay_secretkey'] : "",
      razorpayPublickey: json['razorpay_publickey'] is String ? json['razorpay_publickey'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'razorpay_secretkey': razorpaySecretkey,
      'razorpay_publickey': razorpayPublickey,
    };
  }
}

class StripePay {
  String stripeSecretkey;
  String stripePublickey;

  StripePay({
    this.stripeSecretkey = "",
    this.stripePublickey = "",
  });

  factory StripePay.fromJson(Map<String, dynamic> json) {
    return StripePay(
      stripeSecretkey: json['stripe_secretkey'] is String ? json['stripe_secretkey'] : "",
      stripePublickey: json['stripe_publickey'] is String ? json['stripe_publickey'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stripe_secretkey': stripeSecretkey,
      'stripe_publickey': stripePublickey,
    };
  }
}

class PaystackPay {
  String paystackSecretkey;
  String paystackPublickey;

  PaystackPay({
    this.paystackSecretkey = "",
    this.paystackPublickey = "",
  });

  factory PaystackPay.fromJson(Map<String, dynamic> json) {
    return PaystackPay(
      paystackSecretkey: json['paystack_secretkey'] is String ? json['paystack_secretkey'] : "",
      paystackPublickey: json['paystack_publickey'] is String ? json['paystack_publickey'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paystack_secretkey': paystackSecretkey,
      'paystack_publickey': paystackPublickey,
    };
  }
}

class PaypalPay {
  String paypalSecretkey;
  String paypalClientid;

  PaypalPay({
    this.paypalSecretkey = "",
    this.paypalClientid = "",
  });

  factory PaypalPay.fromJson(Map<String, dynamic> json) {
    return PaypalPay(
      paypalSecretkey: json['paypal_secretkey'] is String ? json['paypal_secretkey'] : "",
      paypalClientid: json['paypal_clientid'] is String ? json['paypal_clientid'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paypal_secretkey': paypalSecretkey,
      'paypal_clientid': paypalClientid,
    };
  }
}

class FlutterwavePay {
  String flutterwaveSecretkey;
  String flutterwavePublickey;

  FlutterwavePay({
    this.flutterwaveSecretkey = "",
    this.flutterwavePublickey = "",
  });

  factory FlutterwavePay.fromJson(Map<String, dynamic> json) {
    return FlutterwavePay(
      flutterwaveSecretkey: json['flutterwave_secretkey'] is String ? json['flutterwave_secretkey'] : "",
      flutterwavePublickey: json['flutterwave_publickey'] is String ? json['flutterwave_publickey'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'flutterwave_secretkey': flutterwaveSecretkey,
      'flutterwave_publickey': flutterwavePublickey,
    };
  }
}

class Currency {
  String currencyName;
  String currencySymbol;
  String currencyCode;
  String currencyPosition;
  int noOfDecimal;
  String thousandSeparator;
  String decimalSeparator;

  Currency({
    this.currencyName = "Doller",
    this.currencySymbol = "\$",
    this.currencyCode = "USD",
    this.currencyPosition = CurrencyPosition.CURRENCY_POSITION_LEFT,
    this.noOfDecimal = 2,
    this.thousandSeparator = ",",
    this.decimalSeparator = ".",
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      currencyName: json['currency_name'] is String ? json['currency_name'] : "Doller",
      currencySymbol: json['currency_symbol'] is String ? json['currency_symbol'] : "\$",
      currencyCode: json['currency_code'] is String ? json['currency_code'] : "USD",
      currencyPosition: json['currency_position'] is String ? json['currency_position'] : "left",
      noOfDecimal: json['no_of_decimal'] is int ? json['no_of_decimal'] : 2,
      thousandSeparator: json['thousand_separator'] is String ? json['thousand_separator'] : ",",
      decimalSeparator: json['decimal_separator'] is String ? json['decimal_separator'] : ".",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currency_name': currencyName,
      'currency_symbol': currencySymbol,
      'currency_code': currencyCode,
      'currency_position': currencyPosition,
      'no_of_decimal': noOfDecimal,
      'thousand_separator': thousandSeparator,
      'decimal_separator': decimalSeparator,
    };
  }
}

class AirtelMoney {
  String airtelSecretkey;
  String airtelClientid;

  AirtelMoney({
    this.airtelSecretkey = "",
    this.airtelClientid = "",
  });

  factory AirtelMoney.fromJson(Map<String, dynamic> json) {
    return AirtelMoney(
      airtelSecretkey: json['airtel_secretkey'] is String ? json['airtel_secretkey'] : "",
      airtelClientid: json['airtel_clientid'] is String ? json['airtel_clientid'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'airtel_secretkey': airtelSecretkey,
      'airtel_clientid': airtelClientid,
    };
  }
}

class Phonepe {
  String phonepeAppId;
  String phonepeMerchantId;
  String phonepeSaltKey;
  String phonepeSaltIndex;

  Phonepe({
    this.phonepeAppId = "",
    this.phonepeMerchantId = "",
    this.phonepeSaltKey = "",
    this.phonepeSaltIndex = "",
  });

  factory Phonepe.fromJson(Map<String, dynamic> json) {
    return Phonepe(
      phonepeAppId: json['phonepay_app_id'] is String ? json['phonepay_app_id'] : "",
      phonepeMerchantId: json['phonepay_merchant_id'] is String ? json['phonepay_merchant_id'] : "",
      phonepeSaltKey: json['phonepay_salt_key'] is String ? json['phonepay_salt_key'] : "",
      phonepeSaltIndex: json['phonepay_salt_index'] is String ? json['phonepay_salt_index'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phonepay_app_id': phonepeAppId,
      'phonepay_merchant_id': phonepeMerchantId,
      'phonepay_salt_key': phonepeSaltKey,
      'phonepay_salt_index': phonepeSaltIndex,
    };
  }
}

class MidtransPay {
  String midtransClientKey;

  MidtransPay({
    this.midtransClientKey = "",
  });

  factory MidtransPay.fromJson(Map<String, dynamic> json) {
    return MidtransPay(
      midtransClientKey: json['midtrans_clientid'] is String ? json['midtrans_clientid'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'midtrans_clientid': midtransClientKey,
    };
  }
}

class CinetPay {
  String cinetPayAPIKey;

  String siteId;

  CinetPay({this.cinetPayAPIKey = "", this.siteId = ''});

  factory CinetPay.fromJson(Map<String, dynamic> json) {
    return CinetPay(
      siteId: json['cinet_siteid'] is String ? json['cinet_siteid'] : "",
      cinetPayAPIKey: json['cinet_apikey'] is String ? json['cinet_apikey'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {'cinet_apikey': cinetPayAPIKey, 'cinet_siteid': siteId};
  }
}

class SadadPay {
  String sadadId;
  String sadadSecretKey;

  String sadadDomain;

  SadadPay({this.sadadId = "", this.sadadSecretKey = '', this.sadadDomain = ''});

  factory SadadPay.fromJson(Map<String, dynamic> json) {
    return SadadPay(sadadId: json['sadad_id'] is String ? json['sadad_id'] : "", sadadSecretKey: json['sadad_secret_key'] is String ? json['sadad_secret_key'] : "", sadadDomain: json['sadad_domain'] is String ? json['sadad_domain'] : "");
  }

  Map<String, dynamic> toJson() {
    return {'sadad_id': sadadId, 'sadad_secret_key': sadadSecretKey, 'sadad_domain': sadadDomain};
  }
}
