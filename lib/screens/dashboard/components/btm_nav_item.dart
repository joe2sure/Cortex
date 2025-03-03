import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:rive/rive.dart';
import 'package:Cortex/utils/colors.dart';
import '../../../components/app_shader_widget.dart';
import 'animated_bar.dart';
import '../model/menu.dart';

class BtmNavItem extends StatelessWidget {
  const BtmNavItem({super.key, required this.navBar, required this.press, required this.riveOnInit, required this.selectedNav});

  final RMenu navBar;
  final VoidCallback press;
  final ValueChanged<Artboard> riveOnInit;
  final RMenu selectedNav;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 36,
            width: 36,
            child: AppShaderWidget(
              color: selectedNav == navBar ? appColorSecondary : white.withOpacity(0.5),
              child: RiveAnimation.asset(
                navBar.rive.src,
                artboard: navBar.rive.artboard,
                onInit: riveOnInit,
              ),
            ),
          ),
          AnimatedBar(isActive: selectedNav == navBar).paddingTop(1),
        ],
      ),
    );
  }
}
