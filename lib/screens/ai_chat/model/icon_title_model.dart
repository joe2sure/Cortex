import '../../../generated/assets.dart';

class IconTitleModel {
  String icon;
  String title;

  IconTitleModel({required this.icon, required this.title});
}

List<IconTitleModel> getExploreMoreList() {
  List<IconTitleModel> temp = [
    IconTitleModel(icon: Assets.imagesSubAiWriter, title: 'AI Writer'),
    IconTitleModel(icon: Assets.imagesSubAiArtGeneratir, title: 'AI Art Generator'),
    IconTitleModel(icon: Assets.imagesSubAiSpeechToText, title: 'AI Speech To Text'),
  ];

  return temp;
}
