import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:slider_button/slider_button.dart';
import '../../components/cached_image_widget.dart';
import '../../main.dart';
import 'walkthrough_controller.dart';
import '../../utils/colors.dart';

class WalkthroughScreen extends StatelessWidget {
  WalkthroughScreen({super.key});
  final WalkthroughController walkthroughController = Get.put(WalkthroughController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: canvasColor,
      body: Column(
        children: [
          SizedBox(height: Get.height * 0.1),
          CarouselSlider(
            options: CarouselOptions(
                height: Get.height * 0.52,
                viewportFraction: 0.72,
                autoPlay: false,
                enlargeCenterPage: true,
                // enableInfiniteScroll: false,
                enlargeFactor: 0.25,
                onPageChanged: (index, reason) {
                  walkthroughController.currentPage(index);
                }),
            items: walkthroughController.walkthroughDetails.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return ClipRRect(
                    borderRadius: radius(),
                    child: CachedImageWidget(
                      url: i.image.validate(),
                      fit: BoxFit.fill,
                    ),
                  );
                },
              );
            }).toList(),
          ),
          SizedBox(height: Get.height * 0.05),
          Obx(
            () => Center(
              child: Text(
                walkthroughController.walkthroughDetails[walkthroughController.currentPage.value].title ?? "",
                textAlign: TextAlign.center,
                style: secondaryTextStyle(color: bodyDark, size: 34),
              ).paddingSymmetric(horizontal: 32),
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SliderButton(
                width: Get.width * 0.8,
                height: 60,
                shimmer: false,
                buttonColor: appTransparentColor,
                backgroundColor: appSectionBackground,
                action: () {
                  walkthroughController.handleSkip();

                  return Future(() => null);
                },
                alignLabel: Alignment.center,
                label: Text(
                  locale.value.slideToSkip,
                  textAlign: TextAlign.center,
                  style: boldTextStyle(
                    weight: FontWeight.w400,
                    color: black,
                    size: 14,
                  ),
                ),
                icon: Container(
                  margin: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: canvasColor),
                  child: const Center(
                      child: Icon(
                    Icons.double_arrow_sharp,
                    color: appColorSecondary,
                    size: 24,
                  )),
                ),
              ),
            ],
          ).paddingSymmetric(horizontal: 16),
          SizedBox(height: Get.height * 0.02),
        ],
      ),
    );
  }
}
