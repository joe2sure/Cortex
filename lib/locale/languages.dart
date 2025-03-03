import 'package:flutter/material.dart';

abstract class BaseLanguage {
  static BaseLanguage of(BuildContext context) => Localizations.of<BaseLanguage>(context, BaseLanguage)!;

  String get language;

  String get badRequest;

  String get forbidden;

  String get pageNotFound;

  String get tooManyRequests;

  String get internalServerError;

  String get badGateway;

  String get serviceUnavailable;

  String get gatewayTimeout;

  String get hey;

  String get hello;

  String get thisFieldIsRequired;

  String get contactNumber;

  String get gallery;

  String get camera;

  String get editProfile;

  String get update;

  String get reload;

  String get address;

  String get viewAll;

  String get pressBackAgainToExitApp;

  String get invalidUrl;

  String get cancel;

  String get delete;

  String get deleteAccountConfirmation;

  String get demoUserCannotBeGrantedForThis;

  String get somethingWentWrong;

  String get yourInternetIsNotWorking;

  String get profileUpdatedSuccessfully;

  String get wouldYouLikeToSetProfilePhotoAs;

  String get yourOldPasswordDoesnT;

  String get yourNewPasswordDoesnT;

  String get location;

  String get yes;

  String get submit;

  String get firstName;

  String get lastName;

  String get changePassword;

  String get yourNewPasswordMust;

  String get password;

  String get newPassword;

  String get confirmNewPassword;

  String get email;

  String get mainStreet;

  String get toResetYourNew;

  String get stayTunedNoNew;

  String get noNewNotificationsAt;

  String get signIn;

  String get explore;

  String get settings;

  String get rateApp;

  String get aboutApp;

  String get logout;

  String get rememberMe;

  String get forgotPassword;

  String get forgotPasswordTitle;

  String get registerNow;

  String get createYourAccount;

  String get createYourAccountFor;

  String get signUp;

  String get alreadyHaveAnAccount;

  String get yourPasswordHasBeen;

  String get youCanNowLog;

  String get done;

  String get pleaseAcceptTermsAnd;

  String get deleteAccount;

  String get eG;

  String get merry;

  String get doe;

  String get welcomeBackToThe;

  String get welcomeToThe;

  String get doYouWantToLogout;

  String get appTheme;

  String get guest;

  String get notifications;

  String get newUpdate;

  String get anUpdateTo;

  String get isAvailableGoTo;

  String get later;

  String get closeApp;

  String get updateNow;

  String get signInFailed;

  String get userCancelled;

  String get appleSigninIsNot;

  String get eventStatus;

  String get eventAddedSuccessfully;

  String get notRegistered;

  String get signInWithGoogle;

  String get signInWithApple;

  String get orSignInWith;

  String get ohNoYouAreLeaving;

  String get oldPassword;

  String get oldAndNewPassword;

  String get personalizeYourProfile;

  String get themeAndMore;

  String get showSomeLoveShare;

  String get privacyPolicyTerms;

  String get securelyLogOutOfAccount;

  String get termsOfService;

  String get successfully;

  String get clearAll;

  String get notificationDeleted;

  String get doYouWantToRemoveNotification;

  String get doYouWantToClearAllNotification;

  String get locationPermissionDenied;

  String get enableLocation;

  String get permissionDeniedPermanently;

  String get chooseYourLocation;

  String get setAddress;

  String get sorryUserCannotSignin;

  String get iAgreeToThe;

  String get logIn;

  String get yourGeneratedEnhancedPhotos;

  String get change;

  String get share;

  String get viewLess;

  String get yourGeneratedArts;

  String get doYouReallyWantToClearAllHistory;

  String get clearHistory;

  String get doYouReallyWantToDeleteThisFromYourHistory;

  String get chooseSize;

  String get chooseStyle;

  String get enterPrompt;

  String get typeAnything;

  String get xCartoonArt;

  String get tryNow;

  String get noStyle;

  String get nature;

  String get history;

  String get sketch;

  String get animation;

  String get pleaseWriteAPromptForWhatYouWantToGenerate;

  String get aboutThisArt;

  String get apologiesForTheInconvenienceThisImageCannotBe;

  String get regenerate;

  String get promptUsedInThisArt;

  String get copied;

  String get generate;

  String get watchAnAdToGenerate;

  String get enhanceImage;

  String get watchAnAdToEnhanceImage;

  String get exploreNow;

  String get set;

  String get newChat;

  String get apologiesForTheInconvenienceThisResponseCanno;

  String get typeAMessage;

  String get theUserHasDeniedTheUseOfSpeechRecognition;

  String get recentChats;

  String get welcomeToAiChat;

  String get startAskingYourQueriesToAiByClickingNewChatBu;

  String get exploreMore;

  String get tapToChatWithYourAiAssistant;

  String get chatWithYourPersonalAssistantAndAskMeYourQues;

  String get uploadImage;

  String get description;

  String get tags;

  String get deleteHistory;

  String get before;

  String get after;

  String get enhance;

  String get improveYourPictureQuality;

  String get noteYouCanUploadImageWithJpgPngWebpExtension;

  String get enhancePhoto;

  String get imageIsNotSelectedPleaseSetImageFromGalleryOr;

  String get chooseYourImage;

  String get noteYouCanUploadImageWithJpgPngJpegExtension;

  String get yourGeneratedContent;

  String get responseNotInFormatPleaseTryAgainLater;

  String get somethingWentWrongPleaseTryAgainLater;

  String get transcribe;

  String get reset;

  String get graphicDesignTutorial;

  String get selectLanguage;

  String get copy;

  String get download;

  String get back;

  String get title;

  String get content;

  String get recordAudio;

  String get importAudio;

  String get waitingToRecord;

  String get yourRecentHistory;

  String get purchaseNow;

  String get unlockingLimitlessAiFeatures;

  String get currentPlan;

  String get validTill;

  String get subscriptionHistory;

  String get seeYourSubscriptionHistory;

  String get searchTemplates;

  String get noTemplateFound;

  String get noTemplateAtTheMoment;

  String get experienceAisBrillianceFeatures;

  String get signIN;

  String get orContinueWith;

  String get passwordVerificationMail;

  String get toResetYourNewPasswordPleaseEnterYourEmailAdd;

  String get youHaveBeenMissedForALongTime;

  String get signUP;

  String get createAccountForBetterExperience;

  String get termsConditions;

  String get and;

  String get privacyPolicy;

  String get home;

  String get favorites;

  String get aiChat;

  String get profile;

  String get yourFavourites;

  String get oppsNoFavouriteTemplatesAvailable;

  String get unlockThePowerOfAi;

  String get hiThere;

  String get confirm;

  String get doYouConfirmThisPlan;

  String get payment;

  String get choosePaymentMethod;

  String get chooseYourConvenientPaymentOption;

  String get payNow;

  String get noSubscriptionFound;

  String get youHaventSubscribeAnySubscription;

  String get plan;

  String get type;

  String get amount;

  String get thankYouForYourSubscription;

  String get youllBeUseAllTheMentionFeaturesOfOurVizionAi;

  String get goToHome;

  String get empoweringNyourTomorrowsNworld;

  String get smartFeaturesNunleashingAiNpotential;

  String get innovaMindAiAtNredefiningNintelligence;

  String get slideToSkip;

  String get moreInfo;

  String get ifYouExceedYourPlanLimitYouCanStillAccessAllA;

  String get templates;

  String get apologiesForTheInconveniencePleaseTryAgainAft;

  String get exploreWorld7Wonders;

  String get writeAPythonScriptToAutomateSendingDailyEmail;

  String get writeAThankYouNoteToMyColleague;

  String get showMeACodeSnippetOfAWebsitesStickyHeader;

  String get aiImage;

  String get chooseTagLength;

  String get aiImageToText;

  String get aiWriter;

  String get contentGenerator;

  String get images;

  String get words;

  String get planIsCancel;

  String get userNotCreated;

  String get yourDailyLimitHasBeenReachedPleaseUtilizeTheD;

  String get deleteChatConfirmation;

  String get chatRemoved;

  String get transactionIsInProcess;

  String get enterYourMsisdnHere;

  String get pleaseCheckThePayment;

  String get ambiguous;

  String get success;

  String get incorrectPin;

  String get exceedsWithdrawalAmountLimit;

  String get inProcess;

  String get transactionTimedOut;

  String get notEnoughBalance;

  String get refused;

  String get doNotHonor;

  String get transactionNotPermittedTo;

  String get transactionIdIsInvalid;

  String get errorWhileFetchingEncryption;

  String get transactionExpired;

  String get invalidAmount;

  String get transactionNotFound;

  String get successfullyFetchedEncryptionKey;

  String get theTransactionIsStill;

  String get transactionIsSuccessful;

  String get incorrectPinHasBeen;

  String get theUserHasExceeded;

  String get theAmountUserIs;

  String get userDidnTEnterThePin;

  String get transactionInPendingState;

  String get userWalletDoesNot;

  String get theTransactionWasRefused;

  String get encryptionKeyHasBeen;

  String get transactionHasBeenExpired;

  String get payeeIsAlreadyInitiated;

  String get theTransactionWasNot;

  String get thisIsAGeneric;

  String get theTransactionWasTimed;

  String get xSignatureAndPayloadDid;

  String get couldNotFetchEncryption;

  String get transactionFailed;

  String get transactionCancelled;

  String get restorePurchase;

  String get restorePurchaseMessage;

  String get subscriptionPlan;

  String get cantFindPlan;
}
