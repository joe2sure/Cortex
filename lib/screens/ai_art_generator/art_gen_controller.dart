import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/screens/home/services/system_service_helper.dart';

import '../../components/bottom_selection_widget.dart';
import '../../generated/assets.dart';
import '../../main.dart';
import '../../open_ai/models/v1_images_generation_res.dart';
import '../../open_ai/openai_apis.dart';
import '../../utils/app_common.dart';
import '../../utils/colors.dart';
import '../../utils/common_base.dart';
import '../../utils/constants.dart';
import '../home/home_controller.dart';
import '../home/model/history_data_model.dart';
import '../home/services/history_api_service.dart';
import '../home/services/home_api_service.dart';
import 'components/view_img_widget.dart';
import 'model/art_gen_req.dart';
import 'model/generated_images.dart';
import 'model/image_styles_model.dart';
import 'model/suppoerted_image_sizes.dart';

class ArtGenController extends GetxController {
  RxBool isLoading = false.obs;

  //Get History
  Rx<Future<HistoryResponse>> getHistoryResponseFuture = Future(() => HistoryResponse()).obs;
  Rx<HistoryResponse> historyResponse = HistoryResponse().obs;
  Rx<HistoryElement> selectedHistoryElement = HistoryElement(historyData: HistoryData()).obs;

  final RxBool shouldOpenImg = false.obs;
  final RxBool showCopied = false.obs;

  TextEditingController promptCont = TextEditingController();
  FocusNode promptFocus = FocusNode();

  List<ImageSize> supportedSizes = [
    ImageSize(id: 0, size: "1024x1024"),
    ImageSize(id: 1, size: "1792x1024"),
    ImageSize(id: 2, size: "1024x1792"),
  ];
  Rx<ImageSize> selectedImgSize = ImageSize(id: 0, size: "1024x1024").obs;

  List<ImgStyleElement> imageStyles = [
    ImgStyleElement(id: 0, style: locale.value.noStyle, image: Assets.imagesStyleNoStyle),
    ImgStyleElement(id: 1, style: locale.value.nature, image: Assets.imagesStyleNature),
    ImgStyleElement(id: 3, style: locale.value.history, image: Assets.imagesStyleHistory),
    ImgStyleElement(id: 4, style: locale.value.sketch, image: Assets.imagesStyleSketch),
    ImgStyleElement(id: 5, style: locale.value.animation, image: Assets.imagesStyleNature),
  ];
  Rx<ImgStyleElement> selectedStyle = ImgStyleElement(id: 0, style: locale.value.noStyle).obs;

  RxList<GeneratedImage> generatedImage = <GeneratedImage>[].obs;

  @override
  void onInit() {
    getHistoryList();
    super.onInit();
  }

  Future<void> getHistoryList({bool showLoader = true}) async {
    if (showLoader) {
      isLoading(true);
    }
    await getHistoryResponseFuture(HistoryServiceApis.getUserHistory(type: SystemServiceKeys.aiArtGenerator)).then((value) {
      historyResponse(value);
      if (value.data.isNotEmpty) {
        selectedHistoryElement(value.data.first);
      }
      if (shouldOpenImg.value) {
        if (value.data.isNotEmpty) {
          Get.to(
            () => ViewArtImg(),
            duration: const Duration(milliseconds: 500),
          );
        }
        shouldOpenImg(false);
      }
    }).catchError((e) {
      log('getHistoryList E: $e');
    }).whenComplete(() => isLoading(false));
  }

  Future<void> handleClickArtGen() async {
    String userInput = promptCont.text.trim();
    if (userInput.isEmpty) {
      toast(locale.value.pleaseWriteAPromptForWhatYouWantToGenerate);
    } else {
      loginPremiumTesterHandler(
        () async {
          if (isLoading.value) return;
          isLoading(true);
          String prompt = "Generate an Art Image.${selectedStyle.value.id == 0 || selectedStyle.value.style.contains("No Style") ? "" : " Style ${selectedStyle.value.style}. "}$userInput";
          ImageGenReq imageGenReq = ImageGenReq(
            prompt: prompt,
            size: selectedImgSize.value.size,
          );
          await generateArt(imageGenReq);
        },
        checkPremium: true,
        systemService: SystemServiceKeys.aiArtGenerator,
      ).whenComplete(() => isLoading(false));
    }
  }

  Future<void> generateArt(ImageGenReq req) async {
    OpenAiApis.imagesGenerations(request: req.toJson(), type: SystemServiceKeys.aiArtGenerator).then((response) async {
      if (response.responseData.isNotEmpty) {
        generatedImage.add(GeneratedImage(created: response.created, id: generatedImage.length, revisedPrompt: response.responseData.first.revisedPrompt, urls: response.responseData.map((e) => e.url).toList()));
      }
      List<String> downloadedPaths = [];
      for (var element in response.responseData) {
        dev.log('Image URL: ${element.url}');
        await downloadAndShareFile(
          fileName: element.url.toLowerCase().contains(".jpg")
              ? "${currentMillisecondsTimeStamp()}.jpg"
              : element.url.toLowerCase().contains(".webp")
                  ? "${currentMillisecondsTimeStamp()}.webp"
                  : "${currentMillisecondsTimeStamp()}.png",
          uri: Uri.parse(element.url),
          onDownloadComplete: (p0) {
            downloadedPaths.add(p0.path);
            log('downloaded path: ${p0.path}');
          },
        );
      }
      //Custom Api for handling History & Usage Calculation
      await HomeServiceApis.saveHistoryApi(
        data: {
          "request_body": req.toJson(),
          "response_body": response.toJson(),
        },
        files: downloadedPaths,
        type: SystemServiceKeys.aiArtGenerator,
        imageCount: response.responseData.length,
      );
      getHistoryList();
    }).catchError((e) {
      toast(e.toString());
      log('E: $e');
    }).whenComplete(() => isLoading(false));
  }

  Future<void> clearUserHistory({int? historyId, String? serviceType}) async {
    isLoading(true);
    await HistoryServiceApis.clearUserHistory(historyId: historyId, serviceType: serviceType).then((res) {
      toast(res.message);
      if (historyId != null) {
        historyResponse.value.data.removeWhere((element) => element.id == historyId);
      } else if (serviceType != null) {
        getHistoryList();
        try {
          HomeController hCont = Get.find<HomeController>();
          hCont.getDashboardDetail();
        } catch (e) {
          log('hCon E: $e');
        }
      }
    }).catchError((e) {
      toast(e.toString());
      log('deleteRecentChats E: $e');
    }).whenComplete(() => isLoading(false));
  }

  handleInfoClickInViewArtImg(BuildContext context) {
    final res = V1ImageGenerationResponse.fromJson(selectedHistoryElement.value.historyData.responseBody);
    final imgUrl = selectedHistoryElement.value.histroyImage.isNotEmpty ? selectedHistoryElement.value.histroyImage.first : "";
    if (res.responseData.isEmpty) return;

    serviceCommonBottomSheet(
      context,
      child: BottomSelectionSheet(
          title: locale.value.aboutThisArt,
          titlePaddingLeft: 0,
          closeIconPaddingRight: 0,
          child: Column(
            children: [
              8.height,
              Obx(
                () => imgUrl.obs.value.isEmpty
                    ? const Offstage()
                    : Row(
                        children: [
                          AppButton(
                            height: 32,
                            width: Get.width / 3,
                            elevation: 0,
                            color: appColorSecondary,
                            onTap: () async {
                              try {
                                Get.back();
                                promptCont.text = res.responseData.first.revisedPrompt;

                                await handleClickArtGen().then((value) {
                                  debugPrint('+-+-+-+-+--+-+-+');
                                });
                              } catch (e) {
                                debugPrint('E: $e');
                                toast(locale.value.apologiesForTheInconvenienceThisImageCannotBe);
                              }
                            },
                            child: TextIcon(
                              text: locale.value.regenerate,
                              textStyle: boldTextStyle(size: 14, weight: FontWeight.w500, color: canvasColor),
                              prefix: const Icon(Icons.change_circle_outlined, color: canvasColor),
                              useMarquee: true,
                              expandedText: true,
                            ),
                          ).expand(),
                          16.width,
                          AppButton(
                            height: 32,
                            width: Get.width / 3,
                            elevation: 0,
                            color: appColorPrimary,
                            onTap: () async {
                              final isShareDone = await downloadAndShareFile(
                                fileName: imgUrl.toLowerCase().contains(".jpg")
                                    ? "${currentMillisecondsTimeStamp()}.jpg"
                                    : imgUrl.toLowerCase().contains(".webp")
                                        ? "${currentMillisecondsTimeStamp()}.webp"
                                        : "${currentMillisecondsTimeStamp()}.png",
                                uri: Uri.parse(imgUrl),
                              );
                              log('ISSHAREDONE: $isShareDone');
                            },
                            child: TextIcon(
                              text: locale.value.share,
                              textStyle: boldTextStyle(size: 14, weight: FontWeight.w500, color: white),
                              prefix: const Icon(Icons.share_outlined, color: white),
                            ),
                          ).expand(),
                        ],
                      ),
              ),
              8.height,
              Container(
                  padding: const EdgeInsets.only(top: 8),
                  decoration: boxDecorationWithRoundedCorners(
                    borderRadius: BorderRadius.circular(8),
                    backgroundColor: context.cardColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${locale.value.promptUsedInThisArt}:",
                        style: primaryTextStyle(size: 16, fontFamily: fontFamilyBoldGlobal),
                      ),
                      8.height,
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: boxDecorationWithRoundedCorners(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(8),
                          backgroundColor: isDarkMode.value ? appScreenBackgroundDark : appScreenGreyBackground,
                        ),
                        child: Row(
                          children: [
                            SelectableText(
                              res.responseData.first.revisedPrompt,
                              style: primaryTextStyle(size: 14, weight: FontWeight.w600),
                            ).expand(),
                            GestureDetector(
                              onTap: () {
                                res.responseData.first.revisedPrompt.copyToClipboard().then((value) {
                                  showCopied(true);
                                  Future.delayed(const Duration(milliseconds: 800), () {
                                    showCopied(false);
                                  });
                                });
                              },
                              child: Obx(
                                () => showCopied.value
                                    ? Text(
                                        locale.value.copied,
                                        style: secondaryTextStyle(size: 10, color: greenYellow),
                                      )
                                    : const Icon(
                                        Icons.copy,
                                        size: 18,
                                        color: gray,
                                      ),
                              ).paddingAll(2),
                            )
                          ],
                        ),
                      ),
                    ],
                  )),
            ],
          )),
    );
  }
}
