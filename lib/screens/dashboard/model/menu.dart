import 'package:Cortex/generated/assets.dart';

import 'rive_model.dart';

class RMenu {
  final String title;
  final RiveModel rive;

  RMenu({required this.title, required this.rive});
}

List<RMenu> sidebarMenus = [
  RMenu(
    title: "Home",
    rive: RiveModel(src: Assets.riveBottombarIcons, artboard: "HOME", stateMachineName: "HOME_interactivity"),
  ),
  RMenu(
    title: "Search",
    rive: RiveModel(src: Assets.riveBottombarIcons, artboard: "SEARCH", stateMachineName: "SEARCH_Interactivity"),
  ),
  RMenu(
    title: "Favorites",
    rive: RiveModel(src: Assets.riveBottombarIcons, artboard: "LIKE/STAR", stateMachineName: "STAR_Interactivity"),
  ),
  RMenu(
    title: "Help",
    rive: RiveModel(src: Assets.riveBottombarIcons, artboard: "CHAT", stateMachineName: "CHAT_Interactivity"),
  ),
];
List<RMenu> sidebarMenus2 = [
  RMenu(
    title: "History",
    rive: RiveModel(src: Assets.riveBottombarIcons, artboard: "TIMER", stateMachineName: "TIMER_Interactivity"),
  ),
  RMenu(
    title: "Notifications",
    rive: RiveModel(src: Assets.riveBottombarIcons, artboard: "BELL", stateMachineName: "BELL_Interactivity"),
  ),
];
