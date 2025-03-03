import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/utils/colors.dart';

import '../../main.dart';
import '../../open_ai/openai_apis.dart';
import '../../utils/constants.dart';
import '../../utils/getImage.dart';
import '../home/home_controller.dart';
import '../home/model/history_data_model.dart';
import '../home/services/history_api_service.dart';
import '../home/services/home_api_service.dart';
import '../home/services/system_service_helper.dart';
import 'components/img_to_txt_result_screen.dart';
import 'model/image_tags_model.dart';
import 'model/tags_desc_response.dart';

class AiImgToTxtController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController promptCont = TextEditingController();
  FocusNode promptFocus = FocusNode();
  RxBool showGetIdea = false.obs;
  Rx<XFile> pickedImage = XFile("").obs;

  List<ParametersModel> choosePrameters = [
    //TODO String Translation
    ParametersModel(title: locale.value.chooseTagLength, options: [
      OptionElement(id: -1, text: "None"),
      OptionElement(id: 0, text: "Short"),
      OptionElement(id: 1, text: "Medium"),
      OptionElement(id: 2, text: "Long"),
    ]),
    ParametersModel(title: "Choose Tag Style", options: [
      OptionElement(id: -1, text: "None"),
      OptionElement(id: 0, text: "Simple"),
      OptionElement(id: 1, text: "Minimal"),
      OptionElement(id: 2, text: "Creative"),
      OptionElement(id: 3, text: "Friendly"),
    ]),
    ParametersModel(title: "Choose Description Length", options: [
      OptionElement(id: -1, text: "None"),
      OptionElement(id: 0, text: "Short"),
      OptionElement(id: 1, text: "Medium"),
      OptionElement(id: 2, text: "Long"),
    ]),
  ];

  RxList<TagsAndDesCustomResponse> generatedTagsAndDescriptions = <TagsAndDesCustomResponse>[].obs;
  Rx<TagsAndDesCustomResponse> selectedTagsAndDescriptions = TagsAndDesCustomResponse().obs;

  //Get History
  Rx<Future<HistoryResponse>> getHistoryResponseFuture = Future(() => HistoryResponse()).obs;
  Rx<HistoryResponse> historyResponse = HistoryResponse().obs;

  @override
  void onInit() {
    getHistoryList();
    super.onInit();
  }

  /// Get History APi
  Future<void> getHistoryList({bool showLoader = true}) async {
    if (showLoader) {
      isLoading(true);
    }
    await getHistoryResponseFuture(HistoryServiceApis.getUserHistory(type: SystemServiceKeys.aiImageToText)).then((value) {
      historyResponse(value);
    }).catchError((e) {
      log('getHistoryList E: $e');
    }).whenComplete(() => isLoading(false));
  }

  Future<void> generateTagsAndDescFromImage() async {
    if (pickedImage.value.path.isEmpty) {
      toast(locale.value.imageIsNotSelectedPleaseSetImageFromGalleryOr);
      return;
    }
    loginPremiumTesterHandler(
      () async {
        if (isLoading.value) return;
        isLoading(true);

        String selectedParams = "";
        for (var element in choosePrameters) {
          if (!element.selectedOption.value.id.isNegative) {
            selectedParams += "${element.title} = ${element.selectedOption.value.text}";
          }
        }
        log('selectedParamsPARAMS: $selectedParams');
        await HomeServiceApis.uploadImage(files: [pickedImage.value.path]).then((result) async {
          if (result.uploadImage.isNotEmpty) {
            String image = result.uploadImage.first;
            String prompt = '''
Analyze the provided image and generate the tags, description, and image_name ${selectedParams.isNotEmpty ? selectedParams : ""} in the following JSON format:
{
  "image_name": "",
  "tags": [],
  "description": ""
}
''';
            Map<String, dynamic> req = {
              "model": "gpt-4o",
              "max_tokens": 1600,
              "messages": [
                {
                  "role": "user",
                  "content": [
                    {"type": "text", "text": prompt},
                    {
                      "type": "image_url",
                      "image_url": {"url": image, "detail": "high"}
                    }
                  ]
                }
              ],
            };

            OpenAiApis.chatCompletions(request: req).then((response) async {
              if (response.choices.isNotEmpty) {
                dev.log('Image URL: ${response.choices.first.message.content}');
                final convertToJsonRes = response.choices.first.message.content.replaceFirst("```json", "").replaceFirst("```", "");
                if (convertToJsonRes.isJson()) {
                  final res = TagsAndDesCustomResponse.fromJson(jsonDecode(convertToJsonRes));
                  res.reqImageUrl = image;
                  generatedTagsAndDescriptions.add(res);
                  selectedTagsAndDescriptions(res);

                  Get.to(() => ImgToTxtResultScreen(), duration: const Duration(milliseconds: 500));

                  //Custom Api for handling History & Usage Calculation
                  await HomeServiceApis.saveHistoryApi(
                    data: {
                      "request_body": req,
                      "response_body": res,
                    },
                    type: SystemServiceKeys.aiImageToText,
                    wordCount: response.choices.first.message.content.countWords(),
                  );

                  getHistoryList();
                } else {
                  toast(locale.value.yourGeneratedContent);
                }
              }
            }).catchError((e) {
              toast(e.toString());
              log('E: $e');
            }).whenComplete(() => isLoading(false));
          } else {
            toast(locale.value.somethingWentWrongPleaseTryAgainLater);
          }
        });
      },
      checkPremium: true,
      systemService: SystemServiceKeys.aiImageToText,
    );
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

  Future<void> _handleGalleryClick() async {
    Get.back();
    GetImage(ImageSource.gallery, path: (path, name, xFile) async {
      log('Path Gallery : ${path.toString()} name $name');
      pickedImage(xFile);
    });
    /* GetMultipleImage(path: (xFiles) async {
      log('Path Gallery : ${xFiles.length.toString()}');
      final existingNames = pickedImage.map((file) => file.name.trim().toLowerCase()).toSet();
      pickedImages.addAll(xFiles.where((file) => !existingNames.contains(file.name.trim().toLowerCase())));
    }); */
  }

  Future<void> _handleCameraClick() async {
    Get.back();
    GetImage(ImageSource.camera, path: (path, name, xFile) async {
      log('Path Camera : ${path.toString()} name $name');
      pickedImage(xFile);
    });
  }

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      backgroundColor: context.cardColor,
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SettingItemWidget(
              title: locale.value.gallery,
              leading: const Icon(Icons.image, color: appColorPrimary),
              onTap: () async {
                _handleGalleryClick();
              },
            ),
            SettingItemWidget(
              title: locale.value.camera,
              leading: const Icon(Icons.camera, color: appColorPrimary),
              onTap: () {
                _handleCameraClick();
              },
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
            ),
          ],
        ).paddingAll(16.0);
      },
    );
  }
}
