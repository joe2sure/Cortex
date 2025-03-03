import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:record/record.dart';
import 'package:rive/rive.dart' as rive;
import 'package:Cortex/components/cached_image_widget.dart';
import 'package:Cortex/generated/assets.dart';
import '../../main.dart';
import '../../utils/common_base.dart';
import '../../utils/constants.dart';
import '../home/services/system_service_helper.dart';
import 'component/v2t_history_widget.dart';
import 'v2t_gen_controller.dart';
import '../../components/app_scaffold.dart';
import '../../components/app_shader_widget.dart';
import '../../utils/app_common.dart';
import '../../utils/colors.dart';

class V2TScreen extends StatelessWidget {
  V2TScreen({super.key});

  final V2TController v2TController = Get.put(V2TController());

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBartitleText: getSystemServicebyKey(type: SystemServiceKeys.aiVoiceToText).name.isNotEmpty ? getSystemServicebyKey(type: SystemServiceKeys.aiVoiceToText).name : 'AI Voice To Text',
      isLoading: v2TController.isLoading,
      body: Obx(
        () => SizedBox(
          height: Get.height,
          width: Get.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: Get.width,
                color: appColorPrimary,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        chooseAudioSource(
                          title: locale.value.recordAudio,
                          onTap: handleMicClick,
                          icon: Obx(
                            () => rive.RiveAnimation.asset(
                              Assets.riveVoiceAssistantAnimation,
                              fit: BoxFit.contain,
                              controllers: v2TController.riveContList,
                            ).visible(v2TController.riveContList.isNotEmpty),
                          ),
                        ).expand(),
                        16.width,
                        chooseAudioSource(
                          title: locale.value.importAudio,
                          onTap: v2TController.handleFilesPickerClick,
                          icon: Image.asset(
                            Assets.imagesImportAudio,
                            fit: BoxFit.contain,
                            height: 30,
                            width: 30,
                          ),
                        ).expand(),
                      ],
                    ).paddingSymmetric(horizontal: 16, vertical: 20),
                    Obx(
                      () => SizedBox(
                        height: 50,
                        width: Get.width - 32,
                        child: DropdownButtonFormField<String>(
                          icon: const SizedBox.shrink(),
                          isExpanded: true,
                          borderRadius: radius(),
                          dropdownColor: context.cardColor,
                          value: v2TController.selectedLanguage.value,
                          decoration: inputDecoration(context,
                              fillColor: isDarkMode.value ? fullDarkCanvasColorDark : cardLightColor,
                              filled: true,
                              alignLabelWithHint: true,
                              suffixIcon: const CachedImageWidget(url: Assets.iconsIcDropDown, height: 16, width: 16).paddingAll(16)),
                          onChanged: (lan) {
                            log(lan);
                            v2TController.selectedLanguage(lan);
                          },
                          items: supportedLanguagesMap.entries.map((entry) {
                            return DropdownMenuItem(
                              value: entry.key, // Using entry.key as the value for language code
                              child: Text(entry.value, style: primaryTextStyle(), overflow: TextOverflow.ellipsis),
                            );
                          }).toList(),
                        ),
                      ),
                    ).paddingSymmetric(vertical: 8),
                    Obx(
                      () => AppButton(
                        height: 52,
                        width: Get.width / 3,
                        elevation: 0,
                        color: appColorSecondary,
                        onTap: () {
                          if (v2TController.audioRecordState.value != RecordState.stop) {
                            v2TController.stop();
                            v2TController.voiceAssistantDialogAling(false);
                          } else {
                            v2TController.voiceAssistantDialogAling(true);
                            v2TController.start();
                          }
                        },
                        child: Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(v2TController.audioRecordState.value != RecordState.stop ? Icons.stop_rounded : Icons.play_arrow, color: white),
                              4.width,
                              Text(
                                v2TController.audioRecordState.value != RecordState.stop
                                    ? "$minutes : $seconds"
                                    : v2TController.pathOfRecorderding.value.split("/").isNotEmpty
                                        ? v2TController.pathOfRecorderding.value.split("/").last
                                        : '',
                                style: primaryTextStyle(size: 14, weight: FontWeight.w600, color: black),
                              ),
                            ],
                          ),
                        ),
                      ).paddingSymmetric(horizontal: 20, vertical: 30).visible(v2TController.audioRecordState.value != RecordState.stop),
                    ),
                  ],
                ).paddingSymmetric(vertical: 30),
              ),
              V2THistoryWidget().expand(),
            ],
          ),
        ),
      ),
    );
  }

  Widget chooseAudioSource({required void Function() onTap, required Widget icon, required String title}) {
    return GestureDetector(
      onTap: () {
        doIfLoggedIn(() {
          onTap.call();
        });
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: boxDecorationWithRoundedCorners(borderRadius: BorderRadius.circular(8), backgroundColor: isDarkMode.value ? fullDarkCanvasColorDark : canvasColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 80,
              width: 80,
              alignment: Alignment.center,
              decoration: boxDecorationDefault(shape: BoxShape.circle, color: fullDarkCanvasColor),
              child: AppShaderWidget(
                mode: AppShaderMode.secondary,
                child: icon,
              ),
            ).paddingBottom(20),
            Text(
              title,
              style: primaryTextStyle(size: 14, weight: FontWeight.w600, color: whiteTextColor),
            )
          ],
        ),
      ),
    );
  }

  void handleMicClick() {
    if (v2TController.audioRecordState.value != RecordState.stop) {
      v2TController.stop();
      v2TController.voiceAssistantDialogAling(false);
    } else {
      v2TController.voiceAssistantDialogAling(true);
      v2TController.start();
    }
  }

  Widget voiceAssCustomDialog(BuildContext context) {
    return Positioned(
      child: SizedBox(
        height: Get.height,
        width: Get.width,
        child: GestureDetector(
          onTap: () {
            v2TController.voiceAssistantDialogAling(!v2TController.voiceAssistantDialogAling.value);
          },
          child: AnimatedContainer(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black54.withOpacity(0.4),
            ),
            margin: EdgeInsets.all(v2TController.voiceAssistantDialogAling.value ? 0 : Get.height),
            duration: Duration(milliseconds: v2TController.voiceAssistantDialogAling.value ? 10 : 550),
            height: Get.height,
            width: Get.width,
            child: Material(
              color: transparentColor,
              child: AnimatedContainer(
                alignment: Alignment.center,
                onEnd: () {
                  v2TController.onVoiceAssistantDialogOpened(!v2TController.onVoiceAssistantDialogOpened.value);
                },
                margin: EdgeInsets.all(v2TController.voiceAssistantDialogAling.value ? 0 : Get.height * 0.80),
                duration: const Duration(milliseconds: 550),
                height: Get.height * 0.45,
                width: Get.width * 0.75,
                child: Obx(
                  () => const Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      /* Positioned(

                        child: ,
                      ), */
                    ],
                  ).visible(v2TController.onVoiceAssistantDialogOpened.value),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildText() {
    if (v2TController.audioRecordState.value != RecordState.stop) {
      return _buildTimer();
    }

    return Text(locale.value.waitingToRecord);
  }

  String get minutes => _formatNumber(v2TController.recordDuration.value ~/ 60);

  String get seconds => _formatNumber(v2TController.recordDuration.value % 60);

  Widget _buildTimer() {
    return Text(
      '$minutes : $seconds',
      style: const TextStyle(color: Colors.red),
    );
  }

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0$numberStr';
    }

    return numberStr;
  }
}

class TooltipShapeBorder extends ShapeBorder {
  final double arrowWidth;
  final double arrowHeight;
  final double arrowArc;
  final double radius;

  const TooltipShapeBorder({
    this.radius = 0.0,
    this.arrowWidth = 20.0,
    this.arrowHeight = 10.0,
    this.arrowArc = 0.0,
  }) : assert(arrowArc <= 1.0 && arrowArc >= 0.0);

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.only(bottom: arrowHeight);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path();

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    rect = Rect.fromPoints(rect.topLeft, rect.bottomRight - Offset(0, arrowHeight));
    double x = arrowWidth, y = arrowHeight, r = 1 - arrowArc;
    return Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)))
      ..moveTo(rect.bottomCenter.dx + x / 2, rect.bottomCenter.dy)
      ..relativeLineTo(-x / 2 * r, y * r)
      ..relativeQuadraticBezierTo(-x / 2 * (1 - r), y * (1 - r), -x * (1 - r), 0)
      ..relativeLineTo(-x / 2 * r, -y * r);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}
