import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:photo_view/photo_view.dart';
import 'package:Cortex/open_ai/models/v1_images_generation_res.dart';
import 'package:Cortex/screens/ai_art_generator/art_gen_controller.dart';
import 'package:Cortex/utils/app_common.dart';
import 'package:Cortex/utils/common_base.dart';
import '../../../components/loader_widget.dart';
import '../../../components/report_flag_bottom_sheet.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants.dart';

class ViewArtImg extends StatelessWidget {
  ViewArtImg({super.key});

  final ArtGenController artGenController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Stack(
          children: [
            Center(
              child: SizedBox(
                width: Get.width,
                child: imgUrl.value.startsWith(r"http")
                    ? PhotoView(
                        backgroundDecoration: BoxDecoration(color: isDarkMode.value ? black : appScreenBackground),
                        imageProvider: NetworkImage(imgUrl.value),
                        // Replace this with your image path
                        initialScale: PhotoViewComputedScale.contained,
                        minScale: PhotoViewComputedScale.contained,
                        scaleStateChangedCallback: (value) {
                          debugPrint('scaleStateChangedCallback:$value ');
                        },

                        errorBuilder: (context, error, stackTrace) => PlaceHolderWidget(),
                        heroAttributes: PhotoViewHeroAttributes(tag: imgUrl),
                      )
                    : imgUrl.value.startsWith(r"assets/")
                        ? PhotoView(
                            backgroundDecoration: BoxDecoration(color: isDarkMode.value ? black : appScreenBackground),
                            imageProvider: AssetImage(imgUrl.value),
                            // Replace this with your image path
                            initialScale: PhotoViewComputedScale.contained,
                            minScale: PhotoViewComputedScale.contained,
                            scaleStateChangedCallback: (value) {
                              debugPrint('scaleStateChangedCallback:$value ');
                            },

                            errorBuilder: (context, error, stackTrace) => PlaceHolderWidget(),
                            heroAttributes: PhotoViewHeroAttributes(tag: imgUrl),
                          )
                        : PhotoView(
                            backgroundDecoration: BoxDecoration(color: isDarkMode.value ? black : appScreenBackground),
                            imageProvider: FileImage(File(imgUrl.value)),
                            // Replace this with your image path
                            initialScale: PhotoViewComputedScale.contained,
                            minScale: PhotoViewComputedScale.contained,
                            scaleStateChangedCallback: (value) {
                              debugPrint('scaleStateChangedCallback:$value ');
                            },

                            errorBuilder: (context, error, stackTrace) => PlaceHolderWidget(),
                            heroAttributes: PhotoViewHeroAttributes(tag: imgUrl),
                          ),
              ),
            ),
            Positioned(
              top: 50,
              left: 16,
              right: 16,
              child: SizedBox(
                width: Get.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: bodyWhite,
                        size: 28,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        doIfLoggedIn(() {
                          Get.bottomSheet(
                            ReportAndFlagListBottomSheet(
                              reasons: reportReasons,
                              historyId: histID.toString(),
                              systemService: SystemServiceKeys.aiArtGenerator,
                            ),
                            isScrollControlled: true,
                          );
                        });
                      },
                      icon: const Icon(
                        Icons.flag_outlined,
                        color: bodyWhite,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 54,
              width: Get.width,
              child: IconButton(
                onPressed: () {
                  artGenController.handleInfoClickInViewArtImg(context);
                },
                icon: const Icon(
                  Icons.info_outline,
                  color: bodyWhite,
                  size: 32,
                ),
              ),
            ),
            Obx(
              () => Center(
                child: Container(
                  height: Get.height,
                  width: Get.width,
                  padding: EdgeInsets.symmetric(horizontal: Get.width * 0.1, vertical: Get.height * 0.1),
                  color: Colors.black.withOpacity(0.4),
                  alignment: Alignment.center,
                  child: const SparkleLoderWidget(),
                ),
              ).visible(artGenController.isLoading.value),
            )
          ],
        ),
      ),
    );
  }

  V1ImageGenerationResponse get imgGenDetail => V1ImageGenerationResponse.fromJson(artGenController.selectedHistoryElement.value.historyData.responseBody is Map ? artGenController.selectedHistoryElement.value.historyData.responseBody : {});

  RxString get imgUrl => (artGenController.selectedHistoryElement.value.histroyImage.isNotEmpty ? artGenController.selectedHistoryElement.value.histroyImage.first : "").obs;
  int get histID => artGenController.selectedHistoryElement.value.id;
}
