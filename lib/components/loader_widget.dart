import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:rive/rive.dart';
import 'package:Cortex/utils/app_common.dart';

import '../generated/assets.dart';
import 'app_shader_widget.dart';

class LoaderWidget extends StatelessWidget {
  final bool isBlurBackground;
  final Color? loaderColor;

  const LoaderWidget({super.key, this.loaderColor, this.isBlurBackground = false});

  @override
  Widget build(BuildContext context) {
    return isBlurBackground
        ? AbsorbPointer(
            child: SizedBox(
              height: Get.height,
              width: Get.width,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0, tileMode: TileMode.mirror),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: Get.height * 0.1,
                      child: AppShaderWidget(
                        color: isDarkMode.value ? white : null,
                        child: const RiveAnimation.asset(
                          Assets.riveLoadingAnimation,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: Get.height * 0.1,
                child: AppShaderWidget(
                  color: isDarkMode.value ? white : null,
                  child: const RiveAnimation.asset(
                    Assets.riveLoadingAnimation,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ],
          );
  }
}

class SparkleLoderWidget extends StatelessWidget {
  const SparkleLoderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShaderWidget(
      mode: AppShaderMode.secondary,
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              2,
              (i) => Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  2,
                  (j) => Lottie.asset(
                    Assets.lottieSparkles,
                    height: Get.height * 0.08,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                2,
                (i) => Lottie.asset(
                  Assets.lottieSparkles,
                  height: Get.height * 0.08,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ).paddingSymmetric(horizontal: 36),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                2,
                (i) => Lottie.asset(
                  Assets.lottieSparkles,
                  height: Get.height * 0.08,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ).paddingSymmetric(vertical: 36),
          )
        ],
      ),
    );
  }
}
