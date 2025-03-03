import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:rive/rive.dart';
import 'package:Cortex/configs.dart';
import 'package:Cortex/generated/assets.dart';
import '../components/app_scaffold.dart';
import '../utils/colors.dart';
import 'splash_controller.dart';

class SplashScreen extends StatelessWidget {
  final SplashScreenController splashController = Get.put(SplashScreenController());
  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      hideAppBar: true,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(color: canvasColor),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: Get.height * 0.15,
                child: const RiveAnimation.asset(
                  Assets.riveLoadingAnimation,
                  fit: BoxFit.fitHeight,
                ),
              ),
              Text(
                APP_NAME,
                style: boldTextStyle(color: white, size: 28),
              )
            ],
          )
        ],
      ),
    );
  }
}
