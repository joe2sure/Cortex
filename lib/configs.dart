// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart';

/// isIqonicProduct boolean is made for daily check limit for our demo Vizion AI app keep false to disable daily check limit
const bool isIqonicProduct = false;

const APP_NAME = 'Vizion AI';
const APP_LOGO_URL = '$DOMAIN_URL/img/logo/mini_logo.png';
const DEFAULT_LANGUAGE = 'en';
const DASHBOARD_AUTO_SLIDER_SECOND = 5;

///Live Url
const DOMAIN_URL = "";

const BASE_URL = '$DOMAIN_URL/api/';

const APP_PLAY_STORE_URL = '';
const APP_APPSTORE_URL = 'https://apps.apple.com/in/app/vizion-ai/id6478587159';

const TERMS_CONDITION_URL = '$DOMAIN_URL/page/terms-conditions';
const PRIVACY_POLICY_URL = '$DOMAIN_URL/page/privacy-policy';
const INQUIRY_SUPPORT_EMAIL = 'demo@gmail.com';

/// You can add help line number here for contact. It's demo number
const HELP_LINE_NUMBER = '+15265897485';

///firebase configs
//Please do configure Default Firebase options lib/firebase_options.dart

//ADs
//Live keys
// //Android
// const INTERSTITIAL_AD_ID = "";
// const NATIVE_AD_ID = "";
// const BANNER_AD_ID = "";
// const OPEN_AD_ID = "";
// const REWARDED_AD_ID = "";
// const REWARDINTERSTITIAL_AD_ID = "";
// //IOS
// const IOS_INTERSTITIAL_AD_ID = "";
// const IOS_NATIVE_AD_ID = "";
// const IOS_BANNER_AD_ID = "";
// const IOS_OPEN_AD_ID = "";
// const IOS_REWARDED_AD_ID = "";
// const IOS_REWARDINTERSTITIAL_AD_ID = "";

//Test keys
////Android
const INTERSTITIAL_AD_ID = "ca-app-pub-3940256099942544/1033173712";
const NATIVE_AD_ID = "ca-app-pub-3940256099942544/2247696110";
const BANNER_AD_ID = "ca-app-pub-3940256099942544/6300978111";
const OPEN_AD_ID = "ca-app-pub-3940256099942544/3419835294";
const REWARDED_AD_ID = "ca-app-pub-3940256099942544/5224354917";
const REWARDINTERSTITIAL_AD_ID = "ca-app-pub-3940256099942544/5354046379";
//IOS
const IOS_INTERSTITIAL_AD_ID = "ca-app-pub-3940256099942544/4411468910";
const IOS_NATIVE_AD_ID = "ca-app-pub-3940256099942544/3986624511";
const IOS_BANNER_AD_ID = "ca-app-pub-3940256099942544/2934735716";
const IOS_OPEN_AD_ID = "ca-app-pub-3940256099942544/5575463023";
const IOS_REWARDED_AD_ID = "ca-app-pub-3940256099942544/1712485313";
const IOS_REWARDINTERSTITIAL_AD_ID = "ca-app-pub-3940256099942544/6978759866";

//region PAYMENTS
const String commonSupportedCurrency = 'INR';

//region STRIPE
const STRIPE_URL = 'https://api.stripe.com/v1/payment_intents';
const STRIPE_merchantIdentifier = "merchant.flutter.stripe.test";
const STRIPE_MERCHANT_COUNTRY_CODE = 'IN';
const STRIPE_CURRENCY_CODE = 'USD';
//endregion

/// PAYSTACK
const String payStackCurrency = "NGN";

/// PAYPAl
const String payPalSupportedCurrency = 'USD';

/// Airtel Money Payments
///It Supports ["UGX", "NGN", "TZS", "KES", "RWF", "ZMW", "CFA", "XOF", "XAF", "CDF", "USD", "XAF", "SCR", "MGA", "MWK"]
const airtel_currency_code = "MWK";
const airtel_country_code = "MW";
const AIRTEL_BASE = kDebugMode ? 'https://openapiuat.airtel.africa/' : "https://openapi.airtel.africa";

/// SADAD PAYMENT DETAIL
const SADAD_API_URL = 'https://api-s.sadad.qa';
const SADAD_PAY_URL = "https://d.sadad.qa";

//end region

//Chat Module File Upload Configs
const chatFilesAllowedExtensions = [
  'jpg', 'jpeg', 'png', 'gif', 'webp', // Images
  'pdf', 'txt', // Documents
];

const max_acceptable_file_size = 5; //Size in Mb
