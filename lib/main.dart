import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/locale/language_en.dart';
import 'package:Cortex/firebase_options.dart';

import 'Ads/ads_controller.dart';
import 'app_theme.dart';
import 'configs.dart';
import 'locale/app_localizations.dart';
import 'locale/languages.dart';
import 'screens/splash_screen.dart';
import 'utils/app_common.dart';
import 'utils/colors.dart';
import 'utils/common_base.dart';
import 'utils/constants.dart';
import 'utils/local_storage.dart';
import 'utils/push_notification_service.dart';

AdsController adsController = Get.put(AdsController());

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  log('NOTIFICATIONDATA: ${message.data}');
  log('notification body-->: ${message.notification}');
  log('notification title-->: ${message.notification!.title}');
  log('notification body-->: ${message.notification!.body}');
}

Rx<BaseLanguage> locale = LanguageEn().obs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then((value) {
    PushNotificationService().initFirebaseMessaging();
    if (kReleaseMode) FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  }).catchError(onError);

  await GetStorage.init();
  //
  fontFamilyPrimaryGlobal = GoogleFonts.instrumentSans(fontWeight: FontWeight.w500).fontFamily;
  textPrimarySizeGlobal = 14;
  fontFamilySecondaryGlobal = GoogleFonts.instrumentSans(fontWeight: FontWeight.w400).fontFamily;
  textSecondarySizeGlobal = 12;
  fontFamilyBoldGlobal = GoogleFonts.instrumentSans(fontWeight: FontWeight.w700).fontFamily;
  //
  defaultBlurRadius = 0;
  defaultRadius = 12;
  defaultSpreadRadius = 0;
  appButtonBackgroundColorGlobal = appColorPrimary;
  defaultAppButtonRadius = defaultRadius;
  defaultAppButtonElevation = 0;
  defaultAppButtonTextColorGlobal = Colors.white;

  selectedLanguageCode(getValueFromLocal(SELECTED_LANGUAGE_CODE) ?? DEFAULT_LANGUAGE);

  await initialize(aLocaleLanguageList: languageList(), defaultLanguage: selectedLanguageCode.value);

  BaseLanguage temp = await const AppLocalizations().load(Locale(selectedLanguageCode.value));
  locale = temp.obs;
  locale.value = await const AppLocalizations().load(Locale(selectedLanguageCode.value));

  try {
    final getThemeFromLocal = getValueFromLocal(SettingsLocalConst.THEME_MODE);
    if (getThemeFromLocal is int) {
      toggleThemeMode(themeId: getThemeFromLocal);
    } else {
      toggleThemeMode(themeId: THEME_MODE_DARK);
      // toggleThemeMode(themeId: THEME_MODE_SYSTEM);
    }
  } catch (e) {
    log('getThemeFromLocal from cache E: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    log('Connectivity subscription set');

   Connectivity().onConnectivityChanged.listen((event) async {
      log('CONNECTIVITY: $event');
      getIPAddress(ipAddressFormat: IPAddressFormat.string).then((value) {
        ipAddress(value);
        log('IP_ADDRESS: $ipAddress');
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RestartAppWidget(
      child: Obx(
        () => GetMaterialApp(
          navigatorKey: navigatorKey,
          title: APP_NAME,
          debugShowCheckedModeBanner: false,
          supportedLocales: LanguageDataModel.languageLocales(),
          localizationsDelegates: const [
            AppLocalizations(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) => Locale(selectedLanguageCode.value),
          fallbackLocale: const Locale(DEFAULT_LANGUAGE),
          locale: Locale(selectedLanguageCode.value),
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
          initialBinding: BindingsBuilder(() {
            getDeviceInfo();
            //initialBinding logic
            setStatusBarColor(canvasColor, statusBarIconBrightness: Brightness.light, statusBarBrightness: Brightness.light);
          }),
          home: SplashScreen(),
        ),
      ),
    );
  }
}
