import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/generated/assets.dart';
import 'package:Cortex/utils/common_base.dart';

import '../../components/app_scaffold.dart';
import '../../main.dart';
import '../../utils/app_common.dart';
import '../../utils/colors.dart';
import 'component/duration_with_text_component.dart';
import 'component/text_after_icon_component.dart';
import 'component/title_with_dropdown_widget.dart';

class TranscribeScreen extends StatefulWidget {
  const TranscribeScreen({super.key});

  @override
  State<TranscribeScreen> createState() => _TranscribeScreenState();
}

class _TranscribeScreenState extends State<TranscribeScreen> {
  String? selectedLan;
  int? selectedIndex;

  ///Language List
  List<String> languageList = ['English (USA)', 'Dutch'];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBartitleText: locale.value.transcribe,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildPlayAudioWidget(context),
            _buildLanguageSelectionWidget(context),
            _buildTextListWidget(context),
            _buildCommonWidget(context),
          ],
        ).paddingSymmetric(horizontal: 24),
      ),
    );
  }

  Widget _buildPlayAudioWidget(BuildContext context) {
    return Container(
      decoration: boxDecorationWithRoundedCorners(
        backgroundColor: isDarkMode.value ? fullDarkCanvasColorDark : appSectionBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [Text(locale.value.reset, style: secondaryTextStyle(size: 12, color: resetTextColor)).onTap(() {}), Text("Delete", style: secondaryTextStyle(size: 12, color: deleteTextColor)).onTap(() {})],
          ),
          8.height,
          Image.asset(
            Assets.imagesAudioWaveform,
            height: 74,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Assets.iconsIcReverse.iconImage(size: 18, color: appBodyColor),
              Assets.iconsIc10SecReverse.iconImage(size: 22, color: appBodyColor),
              Container(
                height: 27,
                width: 27,
                decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle, backgroundColor: appColorPrimary),
                child: const Icon(
                  Icons.play_arrow_outlined,
                  size: 15,
                  color: appSectionBackground,
                ),
              ),
              Assets.iconsIc10SecForward.iconImage(size: 22, color: appBodyColor),
              Assets.iconsIcForward.iconImage(size: 18, color: appBodyColor)
            ],
          ).paddingSymmetric(horizontal: 50).paddingOnly(top: 20, bottom: 10)
        ],
      ).paddingSymmetric(horizontal: 20, vertical: 20),
    );
  }

  Widget _buildLanguageSelectionWidget(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale.value.graphicDesignTutorial,
          style: primaryTextStyle(size: 18, color: isDarkMode.value ? whiteTextColor : canvasColor),
        ),
        TitleWithDropDownWidget(
          fieldText: locale.value.selectLanguage,
          hintText: "English (USA)",
          value: selectedLan,
          dropDownList: languageList,
          onChanged: (value) {
            hideKeyboard(context);
            selectedLan = value!;
            setState(() {});
          },
        ).paddingSymmetric(vertical: 15),
      ],
    ).paddingSymmetric(vertical: 20);
  }

  Widget _buildTextListWidget(BuildContext context) {
    return Container(
      width: context.width(),
      decoration: boxDecorationWithRoundedCorners(backgroundColor: isDarkMode.value ? fullDarkCanvasColorDark : appSectionBackground, borderRadius: BorderRadius.circular(8)),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: 2,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (context, index) => 20.height,
        itemBuilder: (context, index) => const DurationWithTextComponent(
          time: "00:00 - 00:30",
          text: "Learn essential graphic design skills, including the layout composition, typography, and color theory, through step-by-step tutorials and practical examples, helping you create designs.",
        ),
      ).paddingAll(20),
    );
  }

  Widget _buildCommonWidget(BuildContext context) {
    return Row(
      children: [
        TextAfterIconWidget(
          title: locale.value.copy,
          iconPath: Assets.iconsIcCopy,
          isSelected: selectedIndex == 1,
          onPressed: () {
            setState(() {
              selectedIndex = 1;
            });
          },
        ).expand(),
        15.width,
        TextAfterIconWidget(
          title: locale.value.share,
          iconPath: Assets.iconsIcShare,
          isSelected: selectedIndex == 2,
          onPressed: () {
            setState(() {
              selectedIndex = 2;
            });
          },
        ).expand(),
        15.width,
        TextAfterIconWidget(
          title: locale.value.download,
          iconPath: Assets.iconsIcDownload,
          isSelected: selectedIndex == 3,
          onPressed: () {
            setState(() {
              selectedIndex = 3;
            });
          },
        ).expand()
      ],
    ).paddingSymmetric(vertical: 30);
  }
}
