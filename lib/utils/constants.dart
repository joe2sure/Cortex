// ignore_for_file: constant_identifier_names
import 'package:country_picker/country_picker.dart';
import 'package:get/get.dart';
import 'package:Cortex/generated/assets.dart';

import '../main.dart';
import '../models/report_flag_model.dart';
import '../open_ai/models/gpt_model.dart';
import '../screens/ai_chat/model/icon_title_model.dart';

//region Defaults
class Constants {
  static const perPageItem = 20;
  static var labelTextSize = 16;
  static var googleMapPrefix = 'https://www.google.com/maps/search/?api=1&query=';
  static const DEFAULT_EMAIL = 'felix@gmail.com';
  static const DEFAULT_PASS = '12345678';
  static const appLogoSize = 98.0;
  static const DECIMAL_POINT = 2;
}
//endregion

//region DateFormats
class DateFormatConst {
  static const DD_MM_YY = "dd-MM-yy"; //TODO Use to show only in UI
  static const MMMM_D_yyyy = "MMMM d, y"; //TODO Use to show only in UI
  static const D_MMMM_yyyy = "d MMMM, y"; //TODO Use to show only in UI
  static const MMMM_D_yyyy_At_HH_mm_a = "MMMM d, y @ hh:mm a"; //TODO Use to show only in UI
  static const EEEE_D_MMMM_At_HH_mm_a = "EEEE d MMMM @ hh:mm a"; //TODO Use to show only in UI
  static const dd_MMM_yyyy_HH_mm_a = "dd MMM y, hh:mm a"; //TODO Use to show only in UI
  static const yyyy_MM_dd_HH_mm = 'yyyy-MM-dd HH:mm';
  static const yyyy_MM_dd = 'yyyy-MM-dd';
  static const HH_mm12Hour = 'hh:mm a';
  static const HH_mm24Hour = 'HH:mm';
}
//endregion

//region THEME MODE TYPE
const THEME_MODE_LIGHT = 0;
const THEME_MODE_DARK = 1;
const THEME_MODE_SYSTEM = 2;
//endregion

//region Firebase Topic keys
class FirebaseTopicConst {
  static const userApp = 'userApp';
  static const user = 'user';
}
//endregion

//region UserKeys
class UserKeys {
  static String firstName = 'first_name';
  static String lastName = 'last_name';
  static String userType = 'user_type';
  static String username = 'username';
  static String email = 'email';
  static String password = 'password';
  static String mobile = 'mobile';
  static String address = 'address';
  static String displayName = 'display_name';
  static String profileImage = 'profile_image';
  static String loginType = 'login_type';
  static String contactNumber = 'contact_number';

  static String userId = 'user_id';
}
//endregion

//region LOGIN TYPE
class LoginTypeConst {
  static const LOGIN_TYPE_USER = 'user';
  static const LOGIN_TYPE_GOOGLE = 'google';
  static const LOGIN_TYPE_APPLE = 'apple';
}
//endregion

//region SharedPreference Keys
class SharedPreferenceConst {
  static const IS_LOGGED_IN = 'IS_LOGGED_IN';
  static const USER_DATA = 'USER_LOGIN_DATA';
  static const USER_EMAIL = 'USER_EMAIL';
  static const USER_PASSWORD = 'USER_PASSWORD';
  static const FIRST_TIME = 'FIRST_TIME';
  static const IS_REMEMBER_ME = 'IS_REMEMBER_ME';
  static const USER_NAME = 'USER_NAME';
  static const LAST_APP_CONFIGURATION_CALL_TIME = 'LAST_APP_CONFIGURATION_CALL_TIME';
  static const HAS_IN_APP_SDK_INITIALISE_AT_LEASE_ONCE='HAS_IN_APP_SDK_INITIALISE_AT_LEASE_ONCE';

  static const HAS_IN_REVENUE_CAT_LOGIN_DONE_LEASE_ONCE='HAS_IN_REVENUE_CAT_LOGIN_DONE_LEASE_ONCE';
  static const SUBSCRIPTION_ACTIVE='SUBSCRIPTION_ACTIVE';
  static const IS_RESTORE_PURCHASE='IS_RESTORE_PURCHASE';
}
//endregion

//region SettingsLocalConst
class SettingsLocalConst {
  static const THEME_MODE = 'THEME_MODE';
}
//endregion

//region defaultCountry
Country get defaultCountry => Country(
      phoneCode: '91',
      countryCode: 'IN',
      e164Sc: 91,
      geographic: true,
      level: 1,
      name: 'India',
      example: '23456789',
      displayName: 'India (IN) [+91]',
      displayNameNoCountryCode: 'India (IN)',
      e164Key: '91-IN-0',
      fullExampleWithPlusSign: '+919123456789',
    );
//endregion

//region LocatinKeys
class LocatinKeys {
  static const LATITUDE = 'LATITUDE';
  static const LONGITUDE = 'LONGITUDE';
  static const CURRENT_ADDRESS = 'CURRENT_ADDRESS';
  static const ZIP_CODE = 'ZIP_CODE';
}
//endregion

//region Currency position
class CurrencyPosition {
  static const CURRENCY_POSITION_LEFT = 'left';
  static const CURRENCY_POSITION_RIGHT = 'right';
  static const CURRENCY_POSITION_LEFT_WITH_SPACE = 'left_with_space';
  static const CURRENCY_POSITION_RIGHT_WITH_SPACE = 'right_with_space';
}
//endregion

//region Gender TYPE
class FontFamilyConst {
  static const archiaFont = "Archia";
}
//endregion

///Subscription Screen
List<IconTitleModel> buySubTopSliderImages = [
  IconTitleModel(icon: Assets.imagesSubAiWriter, title: 'AI Writer'),
  IconTitleModel(icon: Assets.imagesSubAiArtGeneratir, title: 'AI Art Generator'),
  IconTitleModel(icon: Assets.imagesSubAiSpeechToText, title: 'AI Speech To Text'),
  IconTitleModel(icon: Assets.imagesSubAiWriter, title: 'AI Writer'),
  IconTitleModel(icon: Assets.imagesSubAiArtGeneratir, title: 'AI Art Generator'),
  IconTitleModel(icon: Assets.imagesSubAiSpeechToText, title: 'AI Speech To Text'),
  IconTitleModel(icon: Assets.imagesSubAiWriter, title: 'AI Writer'),
  IconTitleModel(icon: Assets.imagesSubAiArtGeneratir, title: 'AI Art Generator'),
  IconTitleModel(icon: Assets.imagesSubAiSpeechToText, title: 'AI Speech To Text'),
];

List<IconTitleModel> buySubBelowSliderImages = [
  IconTitleModel(icon: Assets.imagesSubAiCreator, title: 'AI Art Avtar Creator'),
  IconTitleModel(icon: Assets.imagesSubAiPhotoEnhancer, title: 'AI Photo Enhancer'),
  IconTitleModel(icon: Assets.imagesSubAiChatbot, title: 'AI Chatbot'),
  IconTitleModel(icon: Assets.imagesSubAiImageTag, title: 'AI Image Tag'),
  IconTitleModel(icon: Assets.imagesSubAiCreator, title: 'AI Art Avtar Creator'),
  IconTitleModel(icon: Assets.imagesSubAiPhotoEnhancer, title: 'AI Photo Enhancer'),
  IconTitleModel(icon: Assets.imagesSubAiChatbot, title: 'AI Chatbot'),
  IconTitleModel(icon: Assets.imagesSubAiImageTag, title: 'AI Image Tag'),
  IconTitleModel(icon: Assets.imagesSubAiCreator, title: 'AI Art Avtar Creator'),
  IconTitleModel(icon: Assets.imagesSubAiPhotoEnhancer, title: 'AI Photo Enhancer'),
  IconTitleModel(icon: Assets.imagesSubAiChatbot, title: 'AI Chatbot'),
  IconTitleModel(icon: Assets.imagesSubAiImageTag, title: 'AI Image Tag'),
];

///Chat Bot Icon List
const chatBotIconList = [Assets.iconsIcRegenerate, Assets.iconsIcSpeaker, Assets.iconsIcCopy];

class AdConstantsKeys {
  static String bannerId = "banner_id";
  static String interstitialId = "interstitial_id";
  static String rewardInterstitialId = "reward_interstitial_id";
  static String rewardedAdId = "rewarded_id";
  static String nativeId = "native_id";
  static String appOpenId = "appOpen_id";
  static String clickEvent = "click_event";
  static String isPremiumUser = "isPremiumUser";
}

class SystemServiceKeys {
  static String all = "all";
  static String aiWriter = "ai_writer";
  static String aiArtGenerator = "ai_art_generator";
  static String aiImage = "ai_image";
  static String aiCode = "ai_code";
  static String aiImageToText = "ai_image_text";
  static String aiChat = "ai_chat";
  static String aiVoiceToText = "ai_voice";
}

class LimitKeys {
  static String imageCount = "image_count";
  static String wordCount = "word_count";
}

//region PaymentMethods Keys
class PaymentMethods {
  static const PAYMENT_METHOD_STRIPE = 'stripe';
  static const PAYMENT_METHOD_RAZORPAY = 'razorpay';
  static const PAYMENT_METHOD_PAYPAL = 'paypal';
  static const PAYMENT_METHOD_PAYSTACK = 'paystack';
  static const PAYMENT_METHOD_FLUTTER_WAVE = 'flutterwave';
  static const PAYMENT_METHOD_AIRTEL = 'airtel';
  static const PAYMENT_METHOD_PHONEPE = 'phonepe';
  static const PAYMENT_METHOD_MIDTRANS = 'midtrans';
  static const PAYMENT_METHOD_SADAD = 'sadad';
  static const PAYMENT_METHOD_CINETPAY = 'cinetpay';
  static const PAYMENT_METHOD_INAPPPURCHASE='in-app-purchase';
}
//endregion

//region PaymentStatus
class PaymentStatus {
  static const PAID = 'paid';
}
//endregion

//region PaymentStatus
class CheckDailyLimitKeys {
  static const lastRequestTime = 'last_request_time';
}
//endregion

//region SUBSCRIPTION PAYMENT STATUS
const SUBSCRIPTION_STATUS_ACTIVE = 'active';
const SUBSCRIPTION_STATUS_INACTIVE = 'inactive';
const FREE = 'free';
//endregion

//region TextCompletionConst
class TextCompletionConst {
  static const int connectTimeOut = 10000;
  static const int receiveTimeOut = 30000;
}
//endregion

//region OpenAi, Cutout pro , Picsart etc. Account Balance Notification Keys
class AdminNotifyKeys {
  static String openAi = "open_ai";
  static String cutoutPro = "cutout_pro";
  static String picsArt = "picsart";
}
//endregion

//region Models Consts
class ModelConstKeys {
  static const String gpt4oMini = "gpt-4o-mini";
  static const String gpt4o = "gpt-4o";
}
//endregion

//region Ai Code Template Const
const aiCodeTemplateId = 9999999;
const aiCodeTemplate = {
  'id': aiCodeTemplateId,
  'template_name': "AI Code",
  'description': "",
  'category_id': null,
  'package_id': null,
  'status': 1,
  'template_image': null,
  'inculde_voice_tone': null,
  "userinput_list": [
    {
      "input_type": "single_select",
      "input_title": "Programming language",
      "description": "",
      "is_required": 1,
      "disable_remove_btn": 1,
      "default_value": "Python",
      "input_tag": "##input-0##",
      "option_data": [
        {'id': 1, 'title': 'Python', 'icon': '', 'value': 'python'},
        {'id': 2, 'title': 'C', 'icon': '', 'value': 'c'},
        {'id': 3, 'title': 'C++', 'icon': '', 'value': 'cpp'},
        {'id': 4, 'title': 'Java', 'icon': '', 'value': 'java'},
        {'id': 5, 'title': 'C#', 'icon': '', 'value': 'csharp'},
        {'id': 6, 'title': 'Visual Basic', 'icon': '', 'value': 'vb'},
        {'id': 7, 'title': 'JavaScript', 'icon': '', 'value': 'javascript'},
        {'id': 8, 'title': 'SQL (Structured Query Language)', 'icon': '', 'value': 'sql'},
        {'id': 9, 'title': 'Assembly', 'icon': '', 'value': 'assembly'},
        {'id': 10, 'title': 'PHP', 'icon': '', 'value': 'php'},
        {'id': 11, 'title': 'R', 'icon': '', 'value': 'r'},
        {'id': 12, 'title': 'Go', 'icon': '', 'value': 'go'},
        {'id': 13, 'title': 'Visual Basic', 'icon': '', 'value': 'vb'},
        {'id': 14, 'title': 'MATLAB', 'icon': '', 'value': 'matlab'},
        {'id': 15, 'title': 'Swift', 'icon': '', 'value': 'swift'},
        {'id': 16, 'title': 'Pascal', 'icon': '', 'value': 'pascal'},
        {'id': 17, 'title': 'Ruby', 'icon': '', 'value': 'ruby'},
        {'id': 18, 'title': 'Perl', 'icon': '', 'value': 'perl'},
        {'id': 19, 'title': 'Objective-C', 'icon': '', 'value': 'objective'},
        {'id': 20, 'title': 'Rust', 'icon': '', 'value': 'rust'},
        {'id': 21, 'title': 'Arduino', 'icon': '', 'value': 'arduino'},
        {'id': 22, 'title': 'SAS', 'icon': '', 'value': 'sas'},
        {'id': 23, 'title': 'Kotlin', 'icon': '', 'value': 'kotlin'},
        {'id': 24, 'title': 'Julia', 'icon': '', 'value': 'julia'},
        {'id': 25, 'title': 'Lua', 'icon': '', 'value': 'lua'},
        {'id': 26, 'title': 'Fortran', 'icon': '', 'value': 'fortran'},
        {'id': 27, 'title': 'COBOL', 'icon': '', 'value': 'cobol'},
        {'id': 28, 'title': 'Lisp', 'icon': '', 'value': 'lisp'},
        {'id': 29, 'title': 'FoxPro', 'icon': '', 'value': 'foxpro'},
        {'id': 30, 'title': 'Ada', 'icon': '', 'value': 'ada'},
        {'id': 31, 'title': 'Dart', 'icon': '', 'value': 'dart'},
        {'id': 32, 'title': 'Scala', 'icon': '', 'value': 'scala'},
        {'id': 33, 'title': 'Prolog', 'icon': '', 'value': 'prolog'},
        {'id': 34, 'title': 'D', 'icon': '', 'value': 'd'},
        {'id': 35, 'title': 'SQL', 'icon': '', 'value': 'sql'},
        {'id': 36, 'title': 'Bash', 'icon': '', 'value': 'bash'},
        {'id': 37, 'title': 'PowerShell', 'icon': '', 'value': 'powershell'},
        {'id': 38, 'title': 'Haskell', 'icon': '', 'value': 'haskell'},
        {'id': 39, 'title': 'CSS', 'icon': '', 'value': 'css'},
        {'id': 40, 'title': 'SQL', 'icon': '', 'value': 'sql'}
      ]
    },
    {
      "input_type": "textarea",
      "input_title": "What do you want to Generate?",
      "description": "",
      "is_required": 1,
      "default_value": "",
      "input_tag": "##input-1##",
    }
  ],
  "custom_prompt": "language ##input-0##\n\nGenerate Code\n\n##input-1##",
  'created_at': null,
  'updated_at': null,
  'deleted_at': null,
  'is_wishlist': false,
};
//endregion

Rx<GPTModel> gpt4oMiniModel = GPTModel(id: -12, title: "GPT-4o Mini", shortName: "4o-mini", slug: ModelConstKeys.gpt4oMini, desc: "Fastest", icon: Assets.iconsGpt4omini).obs;
Rx<GPTModel> gpt4oModel = GPTModel(id: -13, title: "GPT-4o", shortName: "4o", slug: ModelConstKeys.gpt4o, desc: "Smart and fast", icon: Assets.iconsGpt4o).obs;

//region GPT MODELS Keys
List<GPTModel> gptModels = [
  gpt4oMiniModel.value,
  gpt4oModel.value,
];

// region AirtelMoney Const
class AirtelMoneyResponseCodes {
  static const AMBIGUOUS = "DP00800001000";
  static const SUCCESS = "DP00800001001";
  static const INCORRECT_PIN = "DP00800001002";
  static const LIMIT_EXCEEDED = "DP00800001003";
  static const INVALID_AMOUNT = "DP00800001004";
  static const INVALID_TRANSACTION_ID = "DP00800001005";
  static const IN_PROCESS = "DP00800001006";
  static const INSUFFICIENT_BALANCE = "DP00800001007";
  static const REFUSED = "DP00800001008";
  static const DO_NOT_HONOR = "DP00800001009";
  static const TRANSACTION_NOT_PERMITTED = "DP00800001010";
  static const TRANSACTION_TIMED_OUT = "DP00800001024";
  static const TRANSACTION_NOT_FOUND = "DP00800001025";
  static const FORBIDDEN = "DP00800001026";
  static const FETCHED_ENCRYPTION_KEY_SUCCESSFULLY = "DP00800001027";
  static const ERROR_FETCHING_ENCRYPTION_KEY = "DP00800001028";
  static const TRANSACTION_EXPIRED = "DP00800001029";
}

(String, String) getAirtelMoneyReasonTextFromCode(String code) {
  switch (code) {
    case AirtelMoneyResponseCodes.AMBIGUOUS:
      return (locale.value.ambiguous, locale.value.theTransactionIsStill);
    case AirtelMoneyResponseCodes.SUCCESS:
      return (locale.value.success, locale.value.transactionIsSuccessful);
    case AirtelMoneyResponseCodes.INCORRECT_PIN:
      return (locale.value.incorrectPin, locale.value.incorrectPinHasBeen);
    case AirtelMoneyResponseCodes.LIMIT_EXCEEDED:
      return (locale.value.exceedsWithdrawalAmountLimit, locale.value.theUserHasExceeded);
    case AirtelMoneyResponseCodes.INVALID_AMOUNT:
      return (locale.value.invalidAmount, locale.value.theAmountUserIs);
    case AirtelMoneyResponseCodes.INVALID_TRANSACTION_ID:
      return (locale.value.transactionIdIsInvalid, locale.value.userDidnTEnterThePin);
    case AirtelMoneyResponseCodes.IN_PROCESS:
      return (locale.value.inProcess, locale.value.transactionInPendingState);
    case AirtelMoneyResponseCodes.INSUFFICIENT_BALANCE:
      return (locale.value.notEnoughBalance, locale.value.userWalletDoesNot);
    case AirtelMoneyResponseCodes.REFUSED:
      return (locale.value.refused, locale.value.theTransactionWasRefused);
    case AirtelMoneyResponseCodes.DO_NOT_HONOR:
      return (locale.value.doNotHonor, locale.value.thisIsAGeneric);
    case AirtelMoneyResponseCodes.TRANSACTION_NOT_PERMITTED:
      return (locale.value.transactionNotPermittedTo, locale.value.payeeIsAlreadyInitiated);
    case AirtelMoneyResponseCodes.TRANSACTION_TIMED_OUT:
      return (locale.value.transactionTimedOut, locale.value.theTransactionWasTimed);
    case AirtelMoneyResponseCodes.TRANSACTION_NOT_FOUND:
      return (locale.value.transactionNotFound, locale.value.theTransactionWasNot);
    case AirtelMoneyResponseCodes.FORBIDDEN:
      return (locale.value.forbidden, locale.value.xSignatureAndPayloadDid);
    case AirtelMoneyResponseCodes.FETCHED_ENCRYPTION_KEY_SUCCESSFULLY:
      return (locale.value.successfullyFetchedEncryptionKey, locale.value.encryptionKeyHasBeen);
    case AirtelMoneyResponseCodes.ERROR_FETCHING_ENCRYPTION_KEY:
      return (locale.value.errorWhileFetchingEncryption, locale.value.couldNotFetchEncryption);
    case AirtelMoneyResponseCodes.TRANSACTION_EXPIRED:
      return (locale.value.transactionExpired, locale.value.transactionHasBeenExpired);
    default:
      return (locale.value.somethingWentWrong, locale.value.somethingWentWrong);
  }
}
//endregion AirtelMoney

// Open AI currently support the following languages through both the transcriptions and translations endpoint
//For Voice To Text
Map<String, dynamic> supportedLanguagesMap = {
  'af': 'Afrikaans',
  'ar': 'Arabic',
  'hy': 'Armenian',
  'az': 'Azerbaijani',
  'be': 'Belarusian',
  'bs': 'Bosnian',
  'bg': 'Bulgarian',
  'ca': 'Catalan',
  'zh': 'Chinese',
  'hr': 'Croatian',
  'cs': 'Czech',
  'da': 'Danish',
  'nl': 'Dutch',
  'en': 'English',
  'et': 'Estonian',
  'fi': 'Finnish',
  'fr': 'French',
  'gl': 'Galician',
  'de': 'German',
  'el': 'Greek',
  'he': 'Hebrew',
  'hi': 'Hindi',
  'hu': 'Hungarian',
  'is': 'Icelandic',
  'id': 'Indonesian',
  'it': 'Italian',
  'ja': 'Japanese',
  'kn': 'Kannada',
  'kk': 'Kazakh',
  'ko': 'Korean',
  'lv': 'Latvian',
  'lt': 'Lithuanian',
  'mk': 'Macedonian',
  'ms': 'Malay',
  'mr': 'Marathi',
  'mi': 'Maori',
  'ne': 'Nepali',
  'no': 'Norwegian',
  'fa': 'Persian',
  'pl': 'Polish',
  'pt': 'Portuguese',
  'ro': 'Romanian',
  'ru': 'Russian',
  'sr': 'Serbian',
  'sk': 'Slovak',
  'sl': 'Slovenian',
  'es': 'Spanish',
  'sw': 'Swahili',
  'sv': 'Swedish',
  'tl': 'Tagalog',
  'ta': 'Tamil',
  'th': 'Thai',
  'tr': 'Turkish',
  'uk': 'Ukrainian',
  'ur': 'Urdu',
  'vi': 'Vietnamese',
  'cy': 'Welsh',
};

// Report And Flag Constants
List<ReportFlagElement> reportReasons = [
  ReportFlagElement(id: 1, reason: "Abusive or Offensive Content"),
  ReportFlagElement(id: 2, reason: "Hate Speech or Discrimination"),
  ReportFlagElement(id: 3, reason: "Inappropriate or Explicit Content"),
  ReportFlagElement(id: 4, reason: "Sexual or Nudity Content"),
  ReportFlagElement(id: 5, reason: "Misinformation or Misleading Content"),
  ReportFlagElement(id: 6, reason: "Copyright or Intellectual Property Violation"),
  ReportFlagElement(id: 7, reason: "Plagiarism or Unoriginal Content"),
  ReportFlagElement(id: 8, reason: "Spam or Irrelevant Content"),
  ReportFlagElement(id: 9, reason: "Low-Quality or Incorrect Output"),
  ReportFlagElement(id: 10, reason: "Inaccurate Transcription (Voice to Text)"),
  ReportFlagElement(id: 11, reason: "Unethical or Harmful Content"),
  ReportFlagElement(id: 12, reason: "Violation of Terms of Service"),
  ReportFlagElement(id: 13, reason: "Violent or Graphic Content"),
  ReportFlagElement(id: 14, reason: "Harassment or Bullying"),
  ReportFlagElement(id: 15, reason: "Generated Content is Not Useful"),
];
