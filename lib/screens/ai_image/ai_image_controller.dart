import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/generated/assets.dart';
import 'package:Cortex/utils/colors.dart';
import 'package:Cortex/utils/common_base.dart';

import '../../main.dart';
import '../../utils/constants.dart';
import '../../utils/getImage.dart';
import '../home/home_controller.dart';
import '../home/model/history_data_model.dart';
import '../home/services/history_api_service.dart';
import '../home/services/home_api_service.dart';
import '../home/services/system_service_helper.dart';
import 'component/view_enhanced_img_component.dart';
import 'service/ai_image_service.dart';

class AiImageController extends GetxController {
  TextEditingController promptCont = TextEditingController();

  FocusNode promptFocus = FocusNode();

  RxBool isLoading = false.obs;
  RxBool showSparkleLoader = false.obs;
  RxBool openResult = false.obs;

  Rx<XFile> pickedImage = XFile("").obs;

  RxString generatedImage = "".obs;

  RxDouble sliderPosition = 0.5.obs;

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
    await getHistoryResponseFuture(HistoryServiceApis.getUserHistory(type: SystemServiceKeys.aiImage)).then((value) {
      historyResponse(value);
      if (historyResponse.value.data.isNotEmpty && openResult.value) {
        openResult(false);
        sliderPosition.value = 0.5;
        Get.to(
          () => ViewEnhancedImgComponent(historyElement: historyResponse.value.data.first),
          duration: const Duration(milliseconds: 500),
        );
      }
    }).catchError((e) {
      log('getHistoryList E: $e');
    }).whenComplete(() => isLoading(false));
  }

  Future<void> clearUserHistory({int? historyId, String? serviceType}) async {
    isLoading(true);
    await HistoryServiceApis.clearUserHistory(historyId: historyId, serviceType: serviceType).then((res) {
      toast(res.message);
      if (historyId != null) {
        historyResponse.value.data.removeWhere((element) => element.id == historyId);
      } else if (serviceType != null) {
        getHistoryList(showLoader: false);
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

  Future<void> handleFaceEnhancerClick() async {
    if (pickedImage.value.path.isEmpty) {
      toast(locale.value.imageIsNotSelectedPleaseSetImageFromGalleryOr);
      return;
    }
    loginPremiumTesterHandler(
      () {
        isLoading(true);
        showSparkleLoader(true);
        Image2ImageApis.processImage(
          paths: [pickedImage.value.path],
        ).then((res) async {
          generatedImage(res);

          await HomeServiceApis.uploadImage(files: [pickedImage.value.path]).then((result) async {
            ///Custom Api for handling History & Usage Calculation
            await HomeServiceApis.saveHistoryApi(
              data: {
                "request_body": result.toJson(),
                "response_body": {},
              },
              files: [res],
              type: SystemServiceKeys.aiImage,
              imageCount: 1,
            );
            openResult(true);
            getHistoryList();
          }).whenComplete(() {
            isLoading(false);
            showSparkleLoader(false);
          });
        }).catchError((e) {
          toast(e.toString());
          log('E: $e');
        }).whenComplete(() {
          isLoading(false);
          showSparkleLoader(false);
        });
      },
      checkPremium: true,
      systemService: SystemServiceKeys.aiImage,
    );
  }

  Future<void> _handleGalleryClick() async {
    Get.back();
    GetImage(ImageSource.gallery, path: (path, name, xFile) async {
      log('Path Gallery : ${path.toString()} name $name');
      pickedImage(xFile);
    });
  }

  Future<void> _handleCameraClick() async {
    Get.back();
    GetImage(ImageSource.camera, path: (path, name, xFile) async {
      log('Path Camera : ${path.toString()} name $name');
      pickedImage(xFile);
    });
  }

  void showBottomSheet(BuildContext context) {
    doIfLoggedIn(() {
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
                leading:commonLeadingWid(imgPath: Assets.iconsIcCamera, color: appColorPrimary),
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
    });
  }
}
