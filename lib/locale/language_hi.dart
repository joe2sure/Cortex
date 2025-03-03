import 'languages.dart';

class LanguageHi extends BaseLanguage {
  @override
  String get language => 'भाषा';

  @override
  String get badRequest => '400 गलत अनुरोध';

  @override
  String get forbidden => '403 निषिद्ध';

  @override
  String get pageNotFound => '404 पृष्ठ नहीं मिला';

  @override
  String get tooManyRequests => '429: बहुत सारे अनुरोध';

  @override
  String get internalServerError => '500 आंतरिक सर्वर त्रुटि';

  @override
  String get badGateway => '502 खराब गेटवे';

  @override
  String get serviceUnavailable => '503 सेवा उपलब्ध नहीं';

  @override
  String get gatewayTimeout => '504 गेटवे समय समाप्त';

  @override
  String get hey => 'अरे';

  @override
  String get hello => 'नमस्ते';

  @override
  String get thisFieldIsRequired => 'यह फ़ील्ड आवश्यक है';

  @override
  String get contactNumber => 'संपर्क संख्या';

  @override
  String get gallery => 'गैलरी';

  @override
  String get camera => 'कैमरा';

  @override
  String get editProfile => 'प्रोफ़ाइल संपादित करें';

  @override
  String get update => 'अद्यतन';

  @override
  String get reload => 'पुनः लोड करें';

  @override
  String get address => 'पता';

  @override
  String get viewAll => 'सभी को देखें';

  @override
  String get pressBackAgainToExitApp => 'एग्जिट ऐप के लिए फिर से वापस दबाएं';

  @override
  String get invalidUrl => 'असामान्य यूआरएल';

  @override
  String get cancel => 'रद्द करना';

  @override
  String get delete => 'मिटाना';

  @override
  String get deleteAccountConfirmation => 'आपका खाता स्थायी रूप से हटा दिया जाएगा। आपका डेटा फिर से बहाल नहीं किया जाएगा।';

  @override
  String get demoUserCannotBeGrantedForThis => 'इस कार्रवाई के लिए डेमो उपयोगकर्ता प्रदान नहीं किया जा सकता है';

  @override
  String get somethingWentWrong => 'कुछ गलत हो गया';

  @override
  String get yourInternetIsNotWorking => 'आपका इंटरनेट काम नहीं कर रहा है';

  @override
  String get profileUpdatedSuccessfully => 'प्रोफाइल को सफलतापूर्वक अपडेट किया गया';

  @override
  String get wouldYouLikeToSetProfilePhotoAs => 'क्या आप इस चित्र को अपनी प्रोफ़ाइल फोटो के रूप में सेट करना चाहेंगे?';

  @override
  String get yourOldPasswordDoesnT => 'आपका पुराना पासवर्ड सही नहीं है!';

  @override
  String get yourNewPasswordDoesnT => 'आपका नया पासवर्ड पुष्टि पासवर्ड से मेल नहीं खाता है!';

  @override
  String get location => 'जगह';

  @override
  String get yes => 'हाँ';

  @override
  String get submit => 'जमा करना';

  @override
  String get firstName => 'पहला नाम';

  @override
  String get lastName => 'उपनाम';

  @override
  String get changePassword => 'पासवर्ड बदलें';

  @override
  String get yourNewPasswordMust => 'आपका नया पासवर्ड आपके पिछले पासवर्ड से अलग होना चाहिए';

  @override
  String get password => 'पासवर्ड';

  @override
  String get newPassword => 'नया पासवर्ड';

  @override
  String get confirmNewPassword => 'नए पासवर्ड की पुष्टि करें';

  @override
  String get email => 'ईमेल';

  @override
  String get mainStreet => 'मुख्य मार्ग';

  @override
  String get toResetYourNew => 'अपना नया पासवर्ड रीसेट करने के लिए कृपया अपना ईमेल पता दर्ज करें';

  @override
  String get stayTunedNoNew => 'बने रहें! कोई नए संदेश नहीं।';

  @override
  String get noNewNotificationsAt => 'इस समय कोई नई सूचनाएं नहीं हैं। अपडेट होने पर हम आपको पोस्ट करते रहेंगे।';

  @override
  String get signIn => 'दाखिल करना';

  @override
  String get explore => 'अन्वेषण करना';

  @override
  String get settings => 'समायोजन';

  @override
  String get rateApp => 'एप्प का मूल्यांकन';

  @override
  String get aboutApp => 'ऐप के बारे में';

  @override
  String get logout => 'लॉग आउट';

  @override
  String get rememberMe => 'मुझे याद करो';

  @override
  String get forgotPassword => 'पासवर्ड भूल गए?';

  @override
  String get forgotPasswordTitle => 'पासवर्ड भूल गए';

  @override
  String get registerNow => 'अभी पंजीकरण करें';

  @override
  String get createYourAccount => 'अपना खाता बनाएं';

  @override
  String get createYourAccountFor => 'बेहतर अनुभव के लिए अपना खाता बनाएं';

  @override
  String get signUp => 'साइन अप करें';

  @override
  String get alreadyHaveAnAccount => 'क्या आपके पास पहले से एक खाता मौजूद है?';

  @override
  String get yourPasswordHasBeen => 'आपका पासवर्ड सफलतापूर्वक रीसेट कर दिया गया है';

  @override
  String get youCanNowLog => 'अब आप अपने नए पासवर्ड के साथ अपने नए खाते में लॉग इन कर सकते हैं';

  @override
  String get done => 'हो गया';

  @override
  String get pleaseAcceptTermsAnd => 'कृपया नियम और शर्तें स्वीकार करें';

  @override
  String get deleteAccount => 'खाता हटा दो';

  @override
  String get eG => 'उदा।';

  @override
  String get merry => 'प्रमुदित';

  @override
  String get doe => 'हरिणी';

  @override
  String get welcomeBackToThe => 'वापस आपका स्वागत है';

  @override
  String get welcomeToThe => 'आपका स्वागत है';

  @override
  String get doYouWantToLogout => 'क्या आप लॉगआउट करना चाहते हैं?';

  @override
  String get appTheme => 'ऐप थीम';

  @override
  String get guest => 'अतिथि';

  @override
  String get notifications => 'अधिसूचना';

  @override
  String get newUpdate => 'नई अपडेट';

  @override
  String get anUpdateTo => 'के लिए एक अद्यतन';

  @override
  String get isAvailableGoTo => 'उपलब्ध है। प्ले स्टोर पर जाएं और ऐप का नया संस्करण डाउनलोड करें।';

  @override
  String get later => 'बाद में';

  @override
  String get closeApp => 'बंद अनुप्रयोग';

  @override
  String get updateNow => 'अभी अद्यतन करें';

  @override
  String get signInFailed => 'भाग लेना विफल हुआ';

  @override
  String get userCancelled => 'उपयोगकर्ता रद्द कर दिया';

  @override
  String get appleSigninIsNot => 'आपके डिवाइस के लिए Apple साइनइन उपलब्ध नहीं है';

  @override
  String get eventStatus => 'घटना स्थिति';

  @override
  String get eventAddedSuccessfully => 'घटना ने सफलतापूर्वक जोड़ा';

  @override
  String get notRegistered => 'पंजीकृत नहीं है?';

  @override
  String get signInWithGoogle => 'Google के साथ साइन इन करें';

  @override
  String get signInWithApple => 'Apple के साथ साइन इन करें';

  @override
  String get orSignInWith => 'या के साथ साइन इन करें';

  @override
  String get ohNoYouAreLeaving => 'अरे नहीं, आप जा रहे हैं!';

  @override
  String get oldPassword => 'पुराना पासवर्ड';

  @override
  String get oldAndNewPassword => 'पुराना और नया पासवर्ड समान हैं।';

  @override
  String get personalizeYourProfile => 'अपनी प्रोफ़ाइल को निजीकृत करें';

  @override
  String get themeAndMore => 'थीम और अधिक';

  @override
  String get showSomeLoveShare => 'कुछ प्यार दिखाओ, साझा करें!';

  @override
  String get privacyPolicyTerms => 'गोपनीयता नीति, नियम और शर्तें';

  @override
  String get securelyLogOutOfAccount => 'सुरक्षित रूप से खाते से बाहर लॉग आउट करें';

  @override
  String get termsOfService => 'सेवा की शर्तें';

  @override
  String get successfully => 'सफलतापूर्वक';

  @override
  String get clearAll => 'सभी साफ करें';

  @override
  String get notificationDeleted => 'अधिसूचना हटा दी गई';

  @override
  String get doYouWantToRemoveNotification => 'क्या आप अधिसूचना निकालना चाहते हैं';

  @override
  String get doYouWantToClearAllNotification => 'क्या आप अधिसूचना को स्पष्ट करना चाहते हैं';

  @override
  String get locationPermissionDenied => 'स्थान की अनुमति से वंचित';

  @override
  String get enableLocation => 'स्थान सक्षम करें';

  @override
  String get permissionDeniedPermanently => 'अनुमति ने स्थायी रूप से इनकार किया';

  @override
  String get chooseYourLocation => 'अपना स्थान चुनें';

  @override
  String get setAddress => 'सेट पता';

  @override
  String get sorryUserCannotSignin => 'क्षमा करें उपयोगकर्ता साइन इन नहीं कर सकता';

  @override
  String get iAgreeToThe => 'मैं करने के लिए सहमत हूं';

  @override
  String get logIn => 'लॉग इन करें';

  @override
  String get yourGeneratedEnhancedPhotos => "आपकी उत्पन्न बढ़ी हुई तस्वीरें";

  @override
  String get change => "परिवर्तन";

  @override
  String get share => "शेयर करना";

  @override
  String get viewLess => "कम देखें";

  @override
  String get yourGeneratedArts => "आपकी उत्पन्न कला";

  @override
  String get doYouReallyWantToClearAllHistory => "क्या आप वास्तव में सभी इतिहास को साफ करना चाहते हैं?";

  @override
  String get clearHistory => "इतिहास मिटा दें!";

  @override
  String get doYouReallyWantToDeleteThisFromYourHistory => "क्या आप वास्तव में इसे अपने इतिहास से हटाना चाहते हैं?";

  @override
  String get chooseSize => "नाप चुनें";

  @override
  String get chooseStyle => "शैली चुनें";

  @override
  String get enterPrompt => "प्रॉम्प्ट दर्ज करें";

  @override
  String get typeAnything => "कुछ भी टाइप करें ...";

  @override
  String get xCartoonArt => "3 डी कार्टून कला";

  @override
  String get tryNow => "अब कोशिश करो";

  @override
  String get noStyle => "कोई शैली नहीं";

  @override
  String get nature => "प्रकृति";

  @override
  String get history => "इतिहास";

  @override
  String get sketch => "स्केच";

  @override
  String get animation => "एनिमेशन";

  @override
  String get pleaseWriteAPromptForWhatYouWantToGenerate => "कृपया आप जो उत्पन्न करना चाहते हैं, उसके लिए एक संकेत लिखें।";

  @override
  String get aboutThisArt => "इस कला के बारे में";

  @override
  String get apologiesForTheInconvenienceThisImageCannotBe => "असुविधा के लिए क्षमा याचना।इस छवि को पुनर्जीवित नहीं किया जा सकता है।";

  @override
  String get regenerate => "पुन: उत्पन्न करें";

  @override
  String get promptUsedInThisArt => "इस कला में इस्तेमाल किया";

  @override
  String get copied => "कॉपी किया गया";

  @override
  String get generate => "उत्पन्न";

  @override
  String get watchAnAdToGenerate => "उत्पन्न करने के लिए एक विज्ञापन देखें";

  @override
  String get enhanceImage => "छवि को बढ़ाएं";

  @override
  String get watchAnAdToEnhanceImage => "छवि को बढ़ाने के लिए एक विज्ञापन देखें";

  @override
  String get exploreNow => "अब अन्वेषण करें";

  @override
  String get set => "तय करना";

  @override
  String get newChat => "नई चैट";

  @override
  String get apologiesForTheInconvenienceThisResponseCanno => "असुविधा के लिए क्षमा याचना।इस प्रतिक्रिया को पुनर्जीवित नहीं किया जा सकता है।";

  @override
  String get typeAMessage => "एक संदेश लिखें...";

  @override
  String get theUserHasDeniedTheUseOfSpeechRecognition => "उपयोगकर्ता ने भाषण मान्यता के उपयोग से इनकार किया है";

  @override
  String get recentChats => "हाल की चैट";

  @override
  String get welcomeToAiChat => "AI चैट में आपका स्वागत है";

  @override
  String get startAskingYourQueriesToAiByClickingNewChatBu => "नए चैट बटन पर क्लिक करके एआई से अपने प्रश्न पूछना शुरू करें";

  @override
  String get exploreMore => "और ज्यादा खोजें";

  @override
  String get tapToChatWithYourAiAssistant => "अपने AI सहायक के साथ चैट करने के लिए टैप करें";

  @override
  String get chatWithYourPersonalAssistantAndAskMeYourQues => "अपने निजी सहायक के साथ चैट करें और मुझसे अपना प्रश्न या अनुरोध पूछें और मैं आपको सबसे अच्छा सटीक उत्तर दूंगा।";

  @override
  String get uploadImage => "तस्विर अपलोड करना";

  @override
  String get description => "विवरण";

  @override
  String get tags => "टैग";

  @override
  String get deleteHistory => "हिस्ट्री हटाएं!";

  @override
  String get before => "पहले";

  @override
  String get after => "बाद";

  @override
  String get enhance => "बढ़ाना";

  @override
  String get improveYourPictureQuality => "अपनी तस्वीर की गुणवत्ता में सुधार करें";

  @override
  String get noteYouCanUploadImageWithJpgPngWebpExtension => "नोट: आप \"JPG\", \"PNG\", \"WebP\" एक्सटेंशन के साथ छवि अपलोड कर सकते हैं";

  @override
  String get enhancePhoto => "फोटो बढ़ाएं";

  @override
  String get imageIsNotSelectedPleaseSetImageFromGalleryOr => "छवि का चयन नहीं किया गया है !!!कृपया गैलरी या कैमरे से छवि सेट करें";

  @override
  String get chooseYourImage => "अपनी छवि चुनें";

  @override
  String get noteYouCanUploadImageWithJpgPngJpegExtension => "नोट: आप \"JPG\", \"PNG\", \"JPEG\" एक्सटेंशन के साथ छवि अपलोड कर सकते हैं";

  @override
  String get yourGeneratedContent => "आपकी उत्पन्न सामग्री";

  @override
  String get responseNotInFormatPleaseTryAgainLater => "प्रतिक्रिया प्रारूप में नहीं, कृपया बाद में पुनः प्रयास करें";

  @override
  String get somethingWentWrongPleaseTryAgainLater => "कुछ गलत हो गया है। कृपया बाद में दोबारा प्रयास करें";

  @override
  String get transcribe => "लिप्यंतरित";

  @override
  String get reset => "रीसेट";

  @override
  String get graphicDesignTutorial => "ग्राफिक डिजाइन ट्यूटोरियल";

  @override
  String get selectLanguage => "भाषा चुने";

  @override
  String get copy => "प्रतिलिपि";

  @override
  String get download => "डाउनलोड करना";

  @override
  String get back => "पीछे";

  @override
  String get title => "शीर्षक";

  @override
  String get content => "सामग्री";

  @override
  String get recordAudio => "ध्वनि रिकॉर्ड करें";

  @override
  String get importAudio => "आयात ऑडियो";

  @override
  String get waitingToRecord => "रिकॉर्ड करने की प्रतीक्षा कर रहा है";

  @override
  String get yourRecentHistory => "आपका हालिया इतिहास";

  @override
  String get purchaseNow => "अब खरीदें";

  @override
  String get unlockingLimitlessAiFeatures => "असीम एआई सुविधाओं को अनलॉक करना";

  @override
  String get currentPlan => "वर्तमान योजना";

  @override
  String get validTill => "तक मान्य";

  @override
  String get subscriptionHistory => "सदस्यता इतिहास";

  @override
  String get seeYourSubscriptionHistory => "अपना सदस्यता इतिहास देखें";

  @override
  String get searchTemplates => "खोज टेम्पलेट्स…।";

  @override
  String get noTemplateFound => "कोई टेम्पलेट नहीं मिला";

  @override
  String get noTemplateAtTheMoment => "फिलहाल कोई टेम्पलेट नहीं";

  @override
  String get experienceAisBrillianceFeatures => "एआई की प्रतिभा और सुविधाओं का अनुभव करें";

  @override
  String get signIN => "दाखिल करना";

  @override
  String get orContinueWith => "या के साथ जारी रखें";

  @override
  String get passwordVerificationMail => "पासवर्ड सत्यापन मेल";

  @override
  String get toResetYourNewPasswordPleaseEnterYourEmailAdd => "अपना नया पासवर्ड रीसेट करने के लिए कृपया अपना ईमेल पता दर्ज करें";

  @override
  String get youHaveBeenMissedForALongTime => "आप लंबे समय से चूक गए हैं";

  @override
  String get signUP => "साइन अप करें";

  @override
  String get createAccountForBetterExperience => "बेहतर अनुभव के लिए खाता बनाएँ";

  @override
  String get termsConditions => "नियम एवं शर्तें";

  @override
  String get and => "और";

  @override
  String get privacyPolicy => "गोपनीयता नीति";

  @override
  String get home => "घर";

  @override
  String get favorites => "पसंदीदा";

  @override
  String get aiChat => "ऐ चैट";

  @override
  String get profile => "प्रोफ़ाइल";

  @override
  String get yourFavourites => "आपका पसंदीदा";

  @override
  String get oppsNoFavouriteTemplatesAvailable => "Opps!कोई पसंदीदा टेम्प्लेट उपलब्ध नहीं है";

  @override
  String get unlockThePowerOfAi => "एआई की शक्ति को अनलॉक करें";

  @override
  String get hiThere => "नमस्ते!वहाँ";

  @override
  String get confirm => "पुष्टि करना";

  @override
  String get doYouConfirmThisPlan => "क्या आप इस योजना की पुष्टि करते हैं?";

  @override
  String get payment => "भुगतान";

  @override
  String get choosePaymentMethod => "भुगतान का तरीका चुनें";

  @override
  String get chooseYourConvenientPaymentOption => "अपना सुविधाजनक भुगतान विकल्प चुनें।";

  @override
  String get payNow => "अब भुगतान करें";

  @override
  String get noSubscriptionFound => "कोई सदस्यता नहीं मिली";

  @override
  String get youHaventSubscribeAnySubscription => "आपने किसी भी सदस्यता की सदस्यता नहीं ली है";

  @override
  String get plan => "योजना";

  @override
  String get type => "प्रकार";

  @override
  String get amount => "मात्रा";

  @override
  String get thankYouForYourSubscription => "आपकी सदस्यता के लिए धन्यवाद!";

  @override
  String get youllBeUseAllTheMentionFeaturesOfOurVizionAi => "आप हमारे विजियन एआई के सभी उल्लेख सुविधाओं का उपयोग करेंगे।";

  @override
  String get goToHome => "घर जाओ";

  @override
  String get empoweringNyourTomorrowsNworld => "अपने कल की दुनिया को सशक्त बनाना";

  @override
  String get smartFeaturesNunleashingAiNpotential => "स्मार्ट फीचर्स  nunleashing ai  npotential";

  @override
  String get innovaMindAiAtNredefiningNintelligence => "नोवा माइंड: एआई एट  nredefining  nintelligence";

  @override
  String get slideToSkip => "छोड़ने के लिए स्लाइड करना";

  @override
  String get moreInfo => "और जानकारी";

  @override
  String get ifYouExceedYourPlanLimitYouCanStillAccessAllA => "यदि आप अपनी योजना सीमा से अधिक हैं, तो आप अभी भी सभी AI उपकरणों तक पहुंच सकते हैं, लेकिन आपको विज्ञापनों के साथ प्रस्तुत किया जाएगा।";

  @override
  String get templates => "टेम्पलेट्स";

  @override
  String get apologiesForTheInconveniencePleaseTryAgainAft => "असुविधा के लिए क्षमा याचना।कृपया कुछ समय बाद फिर से प्रयास करें।";

  @override
  String get exploreWorld7Wonders => "दुनिया के 7 चमत्कार का अन्वेषण करें";

  @override
  String get writeAPythonScriptToAutomateSendingDailyEmail => "दैनिक ईमेल रिपोर्ट भेजने के लिए एक पायथन स्क्रिप्ट लिखें";

  @override
  String get writeAThankYouNoteToMyColleague => "मेरे सहयोगी को धन्यवाद नोट लिखें";

  @override
  String get showMeACodeSnippetOfAWebsitesStickyHeader => "मुझे एक वेबसाइट के चिपचिपे हेडर का एक कोड स्निपेट दिखाएं";

  @override
  String get aiImage => "ऐ छवि";

  @override
  String get chooseTagLength => "टैग लंबाई चुनें";

  @override
  String get aiImageToText => "पाठ के लिए ऐ छवि";

  @override
  String get aiWriter => "एआई लेखक";

  @override
  String get contentGenerator => "सामग्री जनरेटर";

  @override
  String get images => "इमेजिस";

  @override
  String get words => "शब्द";

  @override
  String get planIsCancel => "योजना रद्द है";

  @override
  String get userNotCreated => "उपयोगकर्ता नहीं बनाया गया";

  @override
  String get yourDailyLimitHasBeenReachedPleaseUtilizeTheD => "आपकी दैनिक सीमा हो गई है।कृपया कल डेमो संस्करण का उपयोग करें।";

  @override
  String get deleteChatConfirmation => 'क्या आप इस चैट को अपने इतिहास से हटाना चाहते हैं?';

  @override
  String get chatRemoved => 'आपके इतिहास से चैट हटा दी गई.';

  @override
  String get transactionIsInProcess => 'लेन-देन प्रक्रिया में है...';

  @override
  String get enterYourMsisdnHere => 'यहां अपना एमएसआईएसडीएन दर्ज करें';

  @override
  String get pleaseCheckThePayment => 'कृपया जांच लें कि भुगतान अनुरोध आपके नंबर पर भेजा गया है';

  @override
  String get ambiguous => 'अस्पष्ट';

  @override
  String get success => 'सफलता';

  @override
  String get incorrectPin => 'ग़लत पिन';

  @override
  String get exceedsWithdrawalAmountLimit => 'निकासी राशि सीमा से अधिक / निकासी राशि सीमा से अधिक';

  @override
  String get inProcess => 'प्रक्रिया में';

  @override
  String get transactionTimedOut => 'लेन-देन का समय समाप्त हो गया';

  @override
  String get notEnoughBalance => 'पर्याप्त संतुलन नहीं';

  @override
  String get refused => 'अस्वीकार करना';

  @override
  String get doNotHonor => 'सम्मान मत कर';

  @override
  String get transactionNotPermittedTo => 'भुगतानकर्ता को लेनदेन की अनुमति नहीं है';

  @override
  String get transactionIdIsInvalid => 'लेन-देन आईडी अमान्य है';

  @override
  String get errorWhileFetchingEncryption => 'एन्क्रिप्शन कुंजी लाते समय त्रुटि';

  @override
  String get transactionExpired => 'लेन-देन समाप्त हो गया';

  @override
  String get invalidAmount => 'अवैध राशि';

  @override
  String get transactionNotFound => 'लेनदेन नहीं मिला';

  @override
  String get successfullyFetchedEncryptionKey => 'एन्क्रिप्शन कुंजी सफलतापूर्वक प्राप्त की गई';

  @override
  String get theTransactionIsStill => 'लेन-देन अभी भी संसाधित हो रहा है और अस्पष्ट स्थिति में है। कृपया लेन-देन की स्थिति जानने के लिए लेन-देन संबंधी पूछताछ करें।';

  @override
  String get transactionIsSuccessful => 'लेन-देन सफल है';

  @override
  String get incorrectPinHasBeen => 'ग़लत पिन दर्ज किया गया है';

  @override
  String get theUserHasExceeded => 'उपयोगकर्ता ने अपने वॉलेट द्वारा अनुमत लेनदेन सीमा पार कर ली है';

  @override
  String get theAmountUserIs => 'उपयोगकर्ता जिस राशि को स्थानांतरित करने का प्रयास कर रहा है वह अनुमत न्यूनतम राशि से कम है';

  @override
  String get userDidnTEnterThePin => 'उपयोगकर्ता ने पिन दर्ज नहीं किया';

  @override
  String get transactionInPendingState => 'लेनदेन लंबित स्थिति में. कृपया कुछ देर बाद जांचें';

  @override
  String get userWalletDoesNot => 'उपयोगकर्ता के वॉलेट में देय राशि को कवर करने के लिए पर्याप्त धन नहीं है';

  @override
  String get theTransactionWasRefused => 'लेन-देन से इनकार कर दिया गया';

  @override
  String get encryptionKeyHasBeen => 'एन्क्रिप्शन कुंजी सफलतापूर्वक प्राप्त कर ली गई है';

  @override
  String get transactionHasBeenExpired => 'लेन-देन समाप्त हो गया है';

  @override
  String get payeeIsAlreadyInitiated => 'भुगतानकर्ता पहले से ही मंथन के लिए शुरू किया गया है या प्रतिबंधित है या एयरटेल मनी प्लेटफॉर्म पर पंजीकृत नहीं है';

  @override
  String get theTransactionWasNot => 'लेन-देन नहीं मिला.';

  @override
  String get thisIsAGeneric => 'यह एक सामान्य इनकार है जिसके कई संभावित कारण हैं';

  @override
  String get theTransactionWasTimed => 'लेन-देन का समय समाप्त हो गया था.';

  @override
  String get xSignatureAndPayloadDid => 'एक्स-हस्ताक्षर और पेलोड मेल नहीं खाते';

  @override
  String get couldNotFetchEncryption => 'एन्क्रिप्शन कुंजी नहीं लायी जा सकी';

  @override
  String get transactionFailed => 'लेन - देन विफल';

  @override
  String get transactionCancelled => 'लेन-देन रद्द कर दिया गया';

  @override
  String get restorePurchase => 'सदस्यता बहाल करें';

  @override
  String get restorePurchaseMessage => 'ऐसा लगता है कि आपकी सदस्यता बदल गई है. क्या आप अपनी सदस्यता बहाल करना चाहेंगे?';

  @override
  String get subscriptionPlan => 'सदस्यता योजना';

  @override
  String get cantFindPlan => 'में उत्पाद नहीं मिल सका';
}
