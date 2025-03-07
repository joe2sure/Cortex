import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../configs.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

class AppLogoWidget extends StatelessWidget {
  const AppLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Constants.appLogoSize,
      width: Constants.appLogoSize,
      alignment: Alignment.center,
      decoration: boxDecorationDefault(
        shape: BoxShape.circle,
        color: appColorPrimary,
      ),
      child: Text(APP_NAME.toUpperCase(), style: boldTextStyle(color: white, letterSpacing: 10)),
    );
  }
}
