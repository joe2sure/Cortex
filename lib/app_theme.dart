import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import '../utils/colors.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: appScreenBackground,
    primaryColor: appColorPrimary,
    primaryColorDark: appColorPrimary,
    useMaterial3: true,
    hoverColor: Colors.white54,
    dividerColor: const Color(0xFF626E8A),
    fontFamily: GoogleFonts.instrumentSans().fontFamily,
    drawerTheme: const DrawerThemeData(backgroundColor: appScreenBackground),
    appBarTheme: AppBarTheme(
      surfaceTintColor: appLayoutBackground,
      color: appLayoutBackground,
      iconTheme: const IconThemeData(color: textPrimaryColor),
      titleTextStyle: TextStyle(
        color: canvasColor,
        fontFamily: GoogleFonts.instrumentSans().fontFamily,
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
    ),
    tabBarTheme: const TabBarTheme(indicator: UnderlineTabIndicator(borderSide: BorderSide(color: Color(0xFFB6D5EF), width: 3))),
    textSelectionTheme: const TextSelectionThemeData(cursorColor: appColorSecondary, selectionHandleColor: Colors.transparent),
    cardTheme: const CardTheme(color: Colors.white),
    cardColor: appSectionBackground,
    iconTheme: const IconThemeData(color: textPrimaryColor),
    bottomSheetTheme: const BottomSheetThemeData(backgroundColor: whiteColor),
    textTheme: const TextTheme(
      labelLarge: TextStyle(color: appColorPrimary),
      titleLarge: TextStyle(color: textPrimaryColor),
      titleSmall: TextStyle(color: textSecondaryColor),
    ),
    //visualDensity: VisualDensity.adaptivePlatformDensity,
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.all(appColorPrimary),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
      TargetPlatform.macOS: OpenUpwardsPageTransitionsBuilder(),
    }),
    colorScheme: const ColorScheme.light(primary: appColorPrimary, error: Colors.red),
  ).copyWith(
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: appColorPrimary),
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: appScreenBackgroundDark,
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      surfaceTintColor: appScreenBackgroundDark,
      color: appScreenBackgroundDark,
      iconTheme: const IconThemeData(color: whiteColor),
      titleTextStyle: TextStyle(
        color: whiteTextColor,
        fontFamily: GoogleFonts.instrumentSans().fontFamily,
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
    ),
    primaryColor: appColorPrimary,
    dividerColor: canvasColor,
    primaryColorDark: appColorPrimary,
    textSelectionTheme: const TextSelectionThemeData(cursorColor: appColorPrimary, selectionHandleColor: Colors.transparent),
    hoverColor: Colors.black12,
    fontFamily: GoogleFonts.instrumentSans().fontFamily,
    drawerTheme: const DrawerThemeData(backgroundColor: fullDarkCanvasColorDark),
    bottomSheetTheme: const BottomSheetThemeData(backgroundColor: appBackgroundColorDark),
    primaryTextTheme: TextTheme(titleLarge: primaryTextStyle(color: Colors.black), labelSmall: primaryTextStyle(color: Colors.black)),
    cardTheme: const CardTheme(color: cardBackgroundBlackDark),
    cardColor: cardBackgroundBlackDark,
    iconTheme: const IconThemeData(color: whiteColor),
    textTheme: const TextTheme(
      labelLarge: TextStyle(color: appColorPrimary),
      titleLarge: TextStyle(color: textPrimaryColor),
      titleSmall: TextStyle(color: textSecondaryColor),
    ),
    tabBarTheme: const TabBarTheme(indicator: UnderlineTabIndicator(borderSide: BorderSide(color: Colors.white))),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.all(appColorPrimary),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
      TargetPlatform.macOS: OpenUpwardsPageTransitionsBuilder(),
    }),
    colorScheme: const ColorScheme.dark(
      primary: appBackgroundColorDark,
      onPrimary: cardBackgroundBlackDark,
      secondary: whiteColor,
      error: Color(0xFFCF6676),
    ),
  ).copyWith(
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: appColorPrimary),
  );
}
