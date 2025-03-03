import '../../../generated/assets.dart';
import '../../../main.dart';

class ExploreMoreModel {
  String icon;
  String title;

  ExploreMoreModel({required this.icon, required this.title});
}

List<ExploreMoreModel> getExploreMoreList() {
  List<ExploreMoreModel> temp = [];

  temp.add(ExploreMoreModel(icon: Assets.iconsIcExplore, title: locale.value.exploreWorld7Wonders));
  temp.add(ExploreMoreModel(icon: Assets.iconsIcPython, title: locale.value.writeAPythonScriptToAutomateSendingDailyEmail));
  temp.add(ExploreMoreModel(icon: Assets.iconsIcEditPrompt, title: locale.value.writeAThankYouNoteToMyColleague));
return temp;
}
