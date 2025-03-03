// ignore_for_file: body_might_complete_normally_catch_error, depend_on_referenced_packages

import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:path/path.dart' as path;
import 'package:country_picker/country_picker.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import '../components/new_update_dialog.dart';
import '../configs.dart';
import '../generated/assets.dart';
import '../main.dart';
import '../screens/auth/sign_in_sign_up/signin_screen.dart';
import '../screens/home/services/home_api_service.dart';
import 'api_end_points.dart';
import 'app_common.dart';
import 'colors.dart';
import 'constants.dart';
import 'local_storage.dart';

Widget get commonDivider => Column(
      children: [
        Divider(
          indent: 3,
          height: 1,
          color: isDarkMode.value ? borderColor.withOpacity(0.1) : borderColor.withOpacity(0.5),
        ).paddingSymmetric(horizontal: 16),
      ],
    );

void handleRate() async {
  if (isAndroid) {
    if (getStringAsync(APP_PLAY_STORE_URL).isNotEmpty) {
      commonLaunchUrl(getStringAsync(APP_PLAY_STORE_URL), launchMode: LaunchMode.externalApplication);
    } else {
      commonLaunchUrl('${getSocialMediaLink(LinkProvider.PLAY_STORE)}${await getPackageName()}', launchMode: LaunchMode.externalApplication);
    }
  } else if (isIOS) {
    if (APP_APPSTORE_URL.isNotEmpty) {
      commonLaunchUrl(APP_APPSTORE_URL, launchMode: LaunchMode.externalApplication);
    }
  }
}

void hideKeyBoardWithoutContext() {
  SystemChannels.textInput.invokeMethod('TextInput.hide');
}

void toggleThemeMode({required int themeId}) {
  if (themeId == THEME_MODE_SYSTEM) {
    Get.changeThemeMode(ThemeMode.system);
    isDarkMode(Get.isPlatformDarkMode);
  } else if (themeId == THEME_MODE_LIGHT) {
    Get.changeThemeMode(ThemeMode.light);
    isDarkMode(false);
  } else if (themeId == THEME_MODE_DARK) {
    Get.changeThemeMode(ThemeMode.dark);
    isDarkMode(true);
  }
  setValueToLocal(SettingsLocalConst.THEME_MODE, themeId);
  log('ISDARKMODE toggleDarkLightSwitch: $themeId');
  log('ISDARKMODE.VALUE: ${isDarkMode.value}');
  chnageSystemNavigationTheme();
}

void chnageSystemNavigationTheme() {
  if (isDarkMode.value) {
    textPrimaryColorGlobal = Colors.white;
    textSecondaryColorGlobal = Colors.white70;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Get.context != null ? scaffoldDarkColor : transparentColor,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
  } else {
    textPrimaryColorGlobal = primaryTextColor;
    textSecondaryColorGlobal = secondaryTextColor;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Get.context != null ? white : transparentColor,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
  }
}

List<LanguageDataModel> languageList() {
  return [
    LanguageDataModel(id: 1, name: 'English', languageCode: 'en', fullLanguageCode: 'en-US', flag: Assets.flagsIcUs),
    LanguageDataModel(id: 2, name: 'Hindi', languageCode: 'hi', fullLanguageCode: 'hi-IN', flag: Assets.flagsIcIn),
    LanguageDataModel(id: 3, name: 'Arabic', languageCode: 'ar', fullLanguageCode: 'ar-AR', flag: Assets.flagsIcAr),
    LanguageDataModel(id: 4, name: 'French', languageCode: 'fr', fullLanguageCode: 'fr-FR', flag: Assets.flagsIcFr),
    LanguageDataModel(id: 4, name: 'German', languageCode: 'de', fullLanguageCode: 'de-DE', flag: Assets.flagsIcDe),
  ];
}

Widget appCloseIconButton(BuildContext context, {required void Function() onPressed, double size = 12}) {
  return IconButton(
    iconSize: size,
    padding: EdgeInsets.zero,
    onPressed: onPressed,
    icon: Container(
      padding: EdgeInsets.all(size - 8),
      decoration: boxDecorationDefault(color: context.cardColor, borderRadius: BorderRadius.circular(size - 4), border: Border.all(color: isDarkMode.value ? lightPrimaryColor : black)),
      child: Icon(
        Icons.close_rounded,
        color: isDarkMode.value ? lightPrimaryColor : black,
        size: size,
      ),
    ),
  );
}

Widget commonLeadingWid({required String imgPath, Color? color, double size = 20}) {
  return Image.asset(
    imgPath,
    width: size,
    height: size,
    color: color,
    fit: BoxFit.contain,
    errorBuilder: (context, error, stackTrace) => Icon(
      Icons.now_wallpaper_outlined,
      size: size,
      color: color ?? appColorSecondary,
    ),
  );
}

Future<void> commonLaunchUrl(String address, {LaunchMode launchMode = LaunchMode.inAppWebView}) async {
  await launchUrl(Uri.parse(address), mode: launchMode).catchError((e) {
    toast('${locale.value.invalidUrl}: $address');
  });
}

void viewFiles(String url) {
  if (url.isNotEmpty) {
    commonLaunchUrl(url, launchMode: LaunchMode.externalApplication);
  }
}

void launchCall(String? url) {
  if (url.validate().isNotEmpty) {
    if (isIOS) {
      commonLaunchUrl('tel://${url!}', launchMode: LaunchMode.externalApplication);
    } else {
      commonLaunchUrl('tel:${url!}', launchMode: LaunchMode.externalApplication);
    }
  }
}

void launchMap(String? url) {
  if (url.validate().isNotEmpty) {
    commonLaunchUrl(Constants.googleMapPrefix + url!, launchMode: LaunchMode.externalApplication);
  }
}

void launchMail(String url) {
  if (url.validate().isNotEmpty) {
    launchUrl(mailTo(to: []), mode: LaunchMode.externalApplication);
  }
}

String parseHtmlString(String? htmlString) {
  return parse(parse(htmlString).body!.text).documentElement!.text;
}

///
/// Date format extension for format datetime in different formats,
/// e.g. 1) dd-MM-yyyy, 2) yyyy-MM-dd, etc...
///
extension DateData on String {
  /// Formats the given [DateTime] object in the [dd-MM-yy] format.
  ///
  /// Returns a string representing the formatted date.
  DateTime get dateInyyyyMMddFormat {
    try {
      return DateFormat(DateFormatConst.yyyy_MM_dd).parse(this);
    } catch (e) {
      return DateTime.now();
    }
  }

  String get dateInMMMMDyyyyFormat {
    try {
      return DateFormat(DateFormatConst.MMMM_D_yyyy).format(dateInyyyyMMddHHmmFormat);
    } catch (e) {
      return this;
    }
  }

  String get dateInEEEEDMMMMAtHHmmAmPmFormat {
    try {
      return DateFormat(DateFormatConst.EEEE_D_MMMM_At_HH_mm_a).format(dateInyyyyMMddHHmmFormat);
    } catch (e) {
      return this;
    }
  }

  String get dateInDMMMMyyyyFormat {
    try {
      return DateFormat(DateFormatConst.D_MMMM_yyyy).format(dateInyyyyMMddHHmmFormat);
    } catch (e) {
      return this;
    }
  }

  String get dayFromDate {
    try {
      return dateInyyyyMMddHHmmFormat.day.toString();
    } catch (e) {
      return "";
    }
  }

  String get monthMMMFormat {
    try {
      return dateInyyyyMMddHHmmFormat.month.toMonthName(isHalfName: true);
    } catch (e) {
      return "";
    }
  }

  String get dateInMMMMDyyyyAtHHmmAmPmFormat {
    try {
      return DateFormat(DateFormatConst.MMMM_D_yyyy_At_HH_mm_a).format(dateInyyyyMMddHHmmFormat);
    } catch (e) {
      return this;
    }
  }

  String get dateInddMMMyyyyHHmmAmPmFormat {
    try {
      return DateFormat(DateFormatConst.dd_MMM_yyyy_HH_mm_a).format(dateInyyyyMMddHHmmFormat);
    } catch (e) {
      try {
        return "$dateInyyyyMMddHHmmFormat";
      } catch (e) {
        return this;
      }
    }
  }

  DateTime get dateInyyyyMMddHHmmFormat {
    try {
      if (isNotEmpty) {
        return DateFormat(DateFormatConst.yyyy_MM_dd_HH_mm).parse(this);
      } else {
        return DateTime.now();
      }
    } catch (e) {
      try {
        return DateFormat(DateFormatConst.yyyy_MM_dd_HH_mm).parse(DateTime.parse(this).toString()); //TODO: toLocal() Removed for UTC Time
      } catch (e) {
        log('dateInyyyyMMddHHmmFormat Error in $this: $e');
        return DateTime.now();
      }
    }
  }

  DateTime get dateInHHmm24HourFormat {
    return DateFormat(DateFormatConst.HH_mm24Hour).parse(this);
  }

  String get timeInHHmmAmPmFormat {
    try {
      return DateFormat(DateFormatConst.HH_mm12Hour).format(dateInyyyyMMddHHmmFormat);
    } catch (e) {
      return this;
    }
  }

  TimeOfDay get timeOfDay24Format {
    return TimeOfDay.fromDateTime(DateFormat(DateFormatConst.yyyy_MM_dd_HH_mm).parse(this));
  }

  bool get isValidTime {
    return DateTime.tryParse("1970-01-01 $this") != null;
  }

  bool get isValidDateTime {
    return DateTime.tryParse(this) != null;
  }

  bool get isAfterCurrentDateTime {
    return dateInyyyyMMddHHmmFormat.isAfter(DateTime.now());
  }

  bool get isToday {
    try {
      return "$dateInyyyyMMddFormat" == DateTime.now().formatDateYYYYmmdd();
    } catch (e) {
      return false;
    }
  }

  Duration toDuration() {
    final parts = split(':');
    try {
      if (parts.length == 2) {
        final hours = int.parse(parts[0]);
        final minutes = int.parse(parts[1]);
        return Duration(hours: hours, minutes: minutes);
      } else {
        return Duration.zero;
      }
    } catch (e) {
      return Duration.zero;
    }
  }

  String toFormattedDuration({bool showFullTitleHoursMinutes = false}) {
    try {
      final duration = toDuration();
      final hours = duration.inHours;
      final minutes = duration.inMinutes.remainder(60);

      String formattedDuration = '';
      if (hours > 0) {
        formattedDuration += "$hours ${showFullTitleHoursMinutes ? 'hour' : 'hr'} ";
      }
      if (minutes > 0) {
        formattedDuration += '$minutes ${showFullTitleHoursMinutes ? 'minute' : 'min'}';
      }
      return formattedDuration.trim();
    } catch (e) {
      return "";
    }
  }
}

extension DateExtension on DateTime {
  /// Formats the given [DateTime] object in the [dd-MM-yy] format.
  ///
  /// Returns a string representing the formatted date.
  String formatDateDDMMYY() {
    final formatter = DateFormat(DateFormatConst.DD_MM_YY);
    return formatter.format(this);
  }

  /// Formats the given [DateTime] object in the [DateFormatConst.yyyy_MM_dd] format.
  ///
  /// Returns a string representing the formatted date.
  String formatDateYYYYmmdd() {
    final formatter = DateFormat(DateFormatConst.yyyy_MM_dd);
    return formatter.format(this);
  }

  /// Formats the given [DateTime] object in the [DateFormatConst.yyyy_MM_dd_HH_mm] format.
  ///
  /// Returns a string representing the formatted date.
  String formatDateYYYYmmddHHmm() {
    final formatter = DateFormat(DateFormatConst.yyyy_MM_dd_HH_mm);
    return formatter.format(this);
  }

  /// Formats the given [DateTime] object in the [DateFormatConst.yyyy_MM_dd]+[DateFormatConst.HH_mm12Hour] format.
  ///
  /// Returns a string representing the formatted date.
  String formatDateddmmYYYYHHmmAMPM() {
    final formatter = DateFormat(DateFormatConst.DD_MM_YY);
    final timeInAMPM = DateFormat(DateFormatConst.HH_mm12Hour);
    return "${formatter.format(this)} ${timeInAMPM.format(this)}";
  }

  /*  /// Formats the given [DateTime] object in the [DateFormatConst.yyyy_MM_dd]+[DateFormatConst.HH_mm_a] format.
  ///
  /// Returns a string representing the formatted date.
  String formatDateddmmYYYYHHmmAMPM() {
    final formatter = DateFormat("dd-MM-yyyy");
    final timeInAMPM = DateFormat(DateFormatConst.HH_mm_a);
    return "${formatter.format(this)} ${timeInAMPM.format(this)}";
  } */

  /// Formats the given [DateTime] object in the [DateFormatConst.HH_mm12Hour] format.
  ///
  /// Returns a string representing the formatted date.
  String formatTimeHHmmAMPM() {
    final formatter = DateFormat(DateFormatConst.HH_mm12Hour);
    return formatter.format(this);
  }

  /// Returns Time Ago
  String get timeAgoWithLocalization => formatTime(millisecondsSinceEpoch);
}

/// Splits a date string in the format "dd/mm/yyyy" into its constituent parts and returns a [DateTime] object.
///
/// If the input string is not a valid date format, this method returns `null`.
///
/// Example usage:
///
/// ```dart
/// DateTime? myDate = getDateTimeFromAboveFormat('27/04/2023');
/// if (myDate != null) {
///   print(myDate); // Output: 2023-04-27 00:00:00.000
/// }
/// ```
///
DateTime? getDateTimeFromAboveFormat(String date) {
  if (date.isValidDateTime) {
    return DateTime.tryParse(date);
  } else {
    List<String> dateParts = date.split('/');
    if (dateParts.length != 3) {
      log('getDateTimeFromAboveFormat => Invalid date format => DATE: $date');
      return null;
    }
    int day = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int year = int.parse(dateParts[2]);
    return DateTime.tryParse('$year-$month-$day');
  }
}

extension TimeExtension on TimeOfDay {
  /// Formats the given [TimeOfDay] object in the [DateFormatConst.HH_mm24Hour] format.
  ///
  /// Returns a string representing the formatted time.
  String formatTimeHHmm24Hour() {
    final timeIn24Hour = DateFormat(DateFormatConst.HH_mm24Hour);
    final tempDateTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, hour, minute);
    return timeIn24Hour.format(tempDateTime);
  }

  /// Formats the given [TimeOfDay] object in the [DateFormatConst.yyyy_MM_dd]+[DateFormatConst.HH_mm12Hour] format.
  ///
  /// Returns a string representing the formatted time.
  String formatTimeHHmmAMPM() {
    final timeInAMPM = DateFormat(DateFormatConst.HH_mm12Hour);
    final tempDateTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, hour, minute);
    return timeInAMPM.format(tempDateTime);
  }
}

TextStyle get appButtonTextStyleGray => secondaryTextStyle(color: appColorSecondary, size: 14);

TextStyle get appButtonTextStyleWhite => secondaryTextStyle(color: Colors.white, size: 14);

TextStyle get appButtonPrimaryColorText => secondaryTextStyle(color: appColorPrimary);

TextStyle get appButtonFontColorText => secondaryTextStyle(color: Colors.grey, size: 14);

InputDecoration inputDecoration(
  BuildContext context, {
  Widget? prefixIcon,
  BoxConstraints? prefixIconConstraints,
  Widget? suffixIcon,
  String? labelText,
  String? hintText,
  double? borderRadius,
  bool? filled,
  bool? alignLabelWithHint,
  Color? fillColor,
  InputBorder? border,
  InputBorder? enabledBorder,
  InputBorder? focusedErrorBorder,
  InputBorder? errorBorder,
  InputBorder? disabledBorder,
}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.only(left: 12, bottom: 10, top: 10, right: 10),
    labelText: labelText,
    hintText: hintText,
    hintStyle: secondaryTextStyle(size: 12),
    labelStyle: secondaryTextStyle(size: 12),
    alignLabelWithHint: alignLabelWithHint ?? true,
    prefixIcon: prefixIcon,
    prefixIconConstraints: prefixIconConstraints,
    suffixIcon: suffixIcon,
    disabledBorder: OutlineInputBorder(borderRadius: radius(), borderSide: const BorderSide(color: Colors.transparent, width: 0.0)),
    border: border ?? OutlineInputBorder(borderRadius: radius(), borderSide: const BorderSide(color: Colors.transparent, width: 0.0)),
    enabledBorder: border ?? OutlineInputBorder(borderRadius: radius(), borderSide: const BorderSide(color: Colors.transparent, width: 0.0)),
    focusedErrorBorder: OutlineInputBorder(borderRadius: radius(), borderSide: const BorderSide(color: Colors.red, width: 0.0)),
    errorBorder: OutlineInputBorder(borderRadius: radius(), borderSide: const BorderSide(color: Colors.red, width: 1.0)),
    focusedBorder: OutlineInputBorder(borderRadius: radius(), borderSide: const BorderSide(color: appColorPrimary, width: 0.0)),
    filled: filled,
    fillColor: fillColor ?? context.cardColor,
  );
}

InputDecoration inputDecorationWithOutBorder(BuildContext context, {Widget? prefixIcon, Widget? suffixIcon, String? labelText, String? hintText, double? borderRadius, bool? filled, Color? fillColor}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.only(left: 12, bottom: 10, top: 10, right: 10),
    labelText: labelText,
    hintText: hintText,
    hintStyle: secondaryTextStyle(size: 12),
    labelStyle: secondaryTextStyle(size: 12),
    alignLabelWithHint: true,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    enabledBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: Colors.red, width: 0.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: Colors.red, width: 1.0),
    ),
    errorMaxLines: 2,
    border: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
    ),
    errorStyle: primaryTextStyle(color: Colors.red, size: 12),
    focusedBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: appColorPrimary, width: 0.0),
    ),
    filled: filled,
    fillColor: fillColor,
  );
}

Widget backButton({Object? result}) {
  return IconButton(
    onPressed: () {
      Get.back(result: result);
    },
    icon: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.grey, size: 20),
  );
}

extension WidgetExt on Widget {
  Container shadow() {
    return Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: this);
  }

  Widget position({
    bool? expand,
    double? size,
    double? left,
    double? right,
    double? bottom,
    double? top,
    double? height,
    double? width,
    Alignment? alignment,
  }) {
    if (alignment != null) {
      return Align(alignment: alignment, child: this);
    }
    if (expand ?? false) {
      Positioned(
        height: size,
        bottom: bottom,
        right: right,
        left: left,
        top: top,
        width: Get.width,
        child: this,
      );
    }
    return Positioned(
      height: size ?? height,
      width: size ?? width,
      bottom: bottom,
      right: right,
      left: left,
      top: top,
      child: this,
    );
  }
}

extension StrEtx on String {
  String get formattedHeroTag => isNotEmpty ? substring(0, length >= 50 ? 50 : length) : currentMillisecondsTimeStamp().toString();

  String get firstLetter => isNotEmpty ? this[0] : '';

  Widget iconImage({double? size, Color? color, BoxFit? fit}) {
    return Image.asset(
      this,
      height: size ?? 22,
      width: size ?? 22,
      fit: fit ?? BoxFit.cover,
      color: color ?? (isDarkMode.value ? Colors.white : darkGray),
      errorBuilder: (context, error, stackTrace) {
        return const SizedBox();
      },
    );
  }

  Widget showSvg({double? size, Color? color, double? width, double? height, bool? fit}) {
    if (fit ?? false) {
      return SvgPicture.asset(
        this,
        width: size ?? width ?? 35,
        height: size ?? height ?? 35,
        color: color,
      );
    }
    return SvgPicture.asset(
      this,
      width: size ?? width ?? 35,
      height: size ?? height ?? 35,
      color: color,
      fit: BoxFit.cover,
    );
  }

  String get getFileExtension => path.extension(Uri.parse(this).path);

  String get getFileBasename => path.basename(Uri.parse(this).path);
}

void pickCountry(BuildContext context, {required Function(Country) onSelect}) {
  showCountryPicker(context: context, showPhoneCode: true, onSelect: onSelect);
}

Future<Uint8List> getAssetImageBytes(String imagePath) async {
  ByteData assetData = await rootBundle.load(imagePath);
  return assetData.buffer.asUint8List();
}

Future<String> encodeImage(XFile image) async {
  final bytes = await image.readAsBytes();
  return base64Encode(bytes);
}

Future<List<File>> pickFiles({
  FileType type = FileType.any,
  List<String> allowedExtensions = const [],
  int maxFileSizeMB = 5,
  bool allowMultiple = false,
}) async {
  List<File> filePath0 = [];
  try {
    FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles(
      type: type,
      allowMultiple: allowMultiple,
      withData: true,
      allowedExtensions: allowedExtensions,
      onFileLoading: (FilePickerStatus status) => log("onFileLoading => $status"),
    );

    if (filePickerResult != null) {
      if (Platform.isAndroid) {
        // For Android, just use the PlatformFile directly
        filePath0 = filePickerResult.paths.map((path) => File(path!)).toList();
      } else {
        Directory cacheDir = await getTemporaryDirectory();
        for (PlatformFile file in filePickerResult.files) {
          if (file.bytes != null && file.size <= maxFileSizeMB * 1024 * 1024) {
            String filePath = '${cacheDir.path}/${file.name}';
            File cacheFile = File(filePath);
            await cacheFile.writeAsBytes(file.bytes!.toList());
            filePath0.add(cacheFile);
          } else {
            // File size exceeds the limit
            toast('File size should be less than $maxFileSizeMB MB');
          }
        }
      }
    }
  } on PlatformException catch (e) {
    log('Unsupported operation$e');
  } catch (e) {
    log('pickFiles E: $e');
  }
  return filePath0;
}

Future<bool> downloadAndShareFile({required Uri uri, required String fileName, void Function(File)? onDownloadComplete}) async {
  bool isShareDone = false;
  try {
    if (uri.toString().contains("http")) {
      final savePath = await getFilePath(fileName);
      final file = File(savePath);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        if (onDownloadComplete != null) {
          onDownloadComplete(file);
          return false;
        }
        ShareResult shareResult = await Share.shareXFiles([fileToXFile(file)]);
        isShareDone = shareResult.status == ShareResultStatus.success;
        log('SHARERESULT: $shareResult');
      } else {
        log('RESPONSE.STATUSCODE: ${response.statusCode}');
      }
    } else {
      ShareResult shareResult = await Share.shareXFiles([XFile(uri.toString())]);
      isShareDone = shareResult.status == ShareResultStatus.success;
    }
  } catch (e) {
    log('downloadAndShareFile Error: $e');
  }
  return isShareDone;
}

XFile fileToXFile(File file) {
  return XFile(file.path);
}

//gets the applicationDirectory and path for the to-be downloaded file

// which will be used to save the file to that path in the downloadFile method

Future<String> getFilePath(uniqueFileName) async {
  String path = '';

  Directory dir = await getTemporaryDirectory();

  path = '${dir.path}/$uniqueFileName';

  return path;
}

// Function to extract text from a PDF file using Syncfusion
Future<String> extractTextFromPDF(String filePath) async {
  // Read the file as bytes
  File file = File(filePath);
  Uint8List bytes = await file.readAsBytes();

  // Load the PDF document
  final PdfDocument document = PdfDocument(inputBytes: bytes);

  // Extract text from the PDF document
  String content = PdfTextExtractor(document).extractText();

  // Dispose the document
  document.dispose();

  return content;
}

// Function to read text from a .txt file
Future<String> readTextFile(String filePath) async {
  File file = File(filePath);
  return await file.readAsString();
}

// Unified function to handle both .pdf and .txt files
Future<String> extractTextFromFile(File file) async {
  if (file.path.contains(RegExp(r'\.pdf$', caseSensitive: false))) {
    return await extractTextFromPDF(file.path);
  } else if (file.path.contains(RegExp(r'\.txt$', caseSensitive: false))) {
    return await readTextFile(file.path);
  } else {
    toast('Unsupported file type: ${file.path}');
    return "";
  }
}

void showNewUpdateDialog(BuildContext context, {required int currentAppVersionCode}) async {
  bool canClose = (isAndroid && currentAppVersionCode >= appConfigs.value.androidLatestVersionUpdateCode) || (isIOS && currentAppVersionCode >= appConfigs.value.isoLatestVersionUpdateCode);
  showInDialog(
    context,
    contentPadding: EdgeInsets.zero,
    barrierDismissible: canClose,
    builder: (_) {
      return PopScope(
        canPop: canClose,
        child: NewUpdateDialog(canClose: canClose),
      );
    },
  );
}

Future<void> showForceUpdateDialog(BuildContext context) async {
  if ((isAndroid && appConfigs.value.androidLatestVersionUpdateCode > currentPackageinfo.value.versionCode.validate().toInt()) || (isIOS && appConfigs.value.isoLatestVersionUpdateCode > currentPackageinfo.value.versionCode.validate().toInt())) {
    showNewUpdateDialog(context, currentAppVersionCode: currentPackageinfo.value.versionCode.validate().toInt());
  }
}

void ifNotTester(VoidCallback callback) {
  if (loginUserData.value.email != Constants.DEFAULT_EMAIL) {
    callback.call();
  } else {
    toast(locale.value.demoUserCannotBeGrantedForThis);
  }
}

void doIfLoggedIn(VoidCallback callback) async {
  if (isLoggedIn.value) {
    callback.call();
  } else {
    bool? res = await Get.to(() => SignInScreen());
    log('doIfLoggedIn RES: $res');

    if (res ?? false) {
      callback.call();
    }
  }
}

Future<void> ifNotSubscribed(VoidCallback callback, {required String systemService, String? category}) async {
  if (adsLoader.value) return;
  adsLoader(true);
  if (isPremiumUser.value) {
    /// Check Daily Limit API
    await checkDailyLimitFreeUser(
      () async {
        adsLoader(true);
        await HomeServiceApis.checkUserCurrentSubscriptionLimit(systemService: systemService, category: category).then((res) {
          if (res.status) {
            callback();
          } else {
            // toast(res.message);
            adsController.loadShowAdsManagerRewardedInterstial(dismissCallBack: () async {
              callback();
            });
          }
        }).catchError((e) {
          // toast(e);
          adsController.loadShowAdsManagerRewardedInterstial(dismissCallBack: () async {
            callback();
          });
          log('checkUserCurrentSubscriptionLimit E: $e');
        }).whenComplete(() => adsLoader(false));
      },
      isPremiumUserCallBack: true,
    );
  } else {
    /// Check Daily Limit API
    await checkDailyLimitFreeUser(callback);
  }
}

Future<void> checkDailyLimitFreeUser(VoidCallback callback, {bool isPremiumUserCallBack = false}) async {
  adsLoader(true);
  if (isIqonicProduct) {
    await HomeServiceApis.checkDailyLimitAPi().then((dailyLimit) {
      if (lastRequestTime != DateTime.now().formatDateYYYYmmdd()) {
        setValueToLocal(CheckDailyLimitKeys.lastRequestTime, DateTime.now().formatDateYYYYmmdd());
        setValueToLocal(APIEndPoints.checkDailyLimit, 0);
      }
      if (dailyLimit.status && dailyUsedLimit < dailyAvilableLimit) {
        setValueToLocal(APIEndPoints.checkDailyLimit, dailyUsedLimit + 1);
        log('++++++++++++isPremiumUserCallBack: $isPremiumUserCallBack');
        if (isPremiumUserCallBack) {
          callback();
        } else {
          adsController.loadShowAdsManagerRewardedInterstial(dismissCallBack: () async {
            callback();
          });
        }
      } else {
        toast(locale.value.yourDailyLimitHasBeenReachedPleaseUtilizeTheD);
      }
    }).catchError((e) {
      log('++++++++++++DAILYLIMIT catchError: $e');
      toast(e);
      log('checkDailyLimit E: $e');
    }).whenComplete(() => adsLoader(false));
  } else {
    if (isPremiumUserCallBack) {
      adsLoader(false);
      callback();
    } else {
      adsController.loadShowAdsManagerRewardedInterstial(dismissCallBack: () async {
        callback();
      });
    }
  }
}

getDeviceInfo() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String id = '';
  String phoneCompany = '';
  String deviceModel = '';
  String deviceOS = '';
  try {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      /* dev.log('ANDROIDINFO.TOMAP(): ${jsonEncode(androidInfo.toMap())}'); */
      id = androidInfo.id;

      log('DEVICEID: $id');
      phoneCompany = androidInfo.brand;
      log('PHONECOMPANY: $phoneCompany');
      deviceModel = androidInfo.model;
      log('DEVICEMODEL: $deviceModel');
      deviceOS = androidInfo.version.release;
      log('DEVICEOS: $deviceOS');
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      phoneCompany = iosInfo.model;
      deviceModel = iosInfo.name;
      deviceOS = iosInfo.utsname.version;
      id = iosInfo.identifierForVendor!;
    }
    deviceId(id);
  } catch (e) {
    debugPrint('E: $e');
  }
}

Future<void> fetchRemoteConfigValues() async {
  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(hours: 24),
  ));
  await remoteConfig.fetchAndActivate();
  if ( isIOS && remoteConfig.getBool('hasInAppStoreReview') && remoteConfig.getInt('versionCode') == currentPackageinfo.value.versionCode.validate().toInt()) {
    hasInAppStoreReview(true);
  } else {
    hasInAppStoreReview(false);
  }
  log('remoteConfig value hasInAppStoreReview: ${remoteConfig.getBool('hasInAppStoreReview')}');
  log('remoteConfig value versionCode: ${remoteConfig.getInt('versionCode')}');
  log('hasInAppStoreReview: $hasInAppStoreReview');
}
