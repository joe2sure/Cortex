import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/screens/home/model/home_detail_res.dart';
import 'package:stream_transform/stream_transform.dart';
import '../../utils/constants.dart';
import '../home/services/home_api_service.dart';

class AiWriterController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLastPage = false.obs;
  RxInt page = 1.obs;

  Rx<Future<RxList<CustomTemplate>>> getSearchResponseFuture = Future(() => RxList<CustomTemplate>()).obs;
  RxList<CustomTemplate> searchedTemplateListResponse = RxList();

  Rx<Future<RxList<CategoryElement>>> getCategoryListFuture = Future(() => RxList<CategoryElement>()).obs;
  RxList<CategoryElement> categoryListResponse = RxList();
  Rx<CategoryElement> selectedCategory = CategoryElement().obs;

  ///Search
  TextEditingController searchCont = TextEditingController();
  RxBool isSearching = false.obs;
  FocusNode searchFocus = FocusNode();
  StreamController<String> searchStream = StreamController<String>();

  @override
  void onInit() {
    searchStream.stream.debounce(const Duration(seconds: 1)).listen((s) {
      searchTemplate();
    });
    super.onInit();
  }

  @override
  void onReady() {
    getCategories();
    super.onReady();
  }

  Future<void> searchTemplate({bool showLoader = true}) async {
    if (showLoader) {
      isLoading(true);
    }
    await getSearchResponseFuture(HomeServiceApis.getSearchResponse(
      searchString: searchCont.text.trim(),
      templateList: searchedTemplateListResponse,
      page: page.value,
      lastPageCallBack: (p0) {
        isLastPage(p0);
      },
    )).whenComplete(() => isLoading(false));
  }

  ///Get ChooseService List
  Future<void> getCategories({bool showLoader = true}) async {
    if (showLoader) {
      isLoading(true);
    }
    await getCategoryListFuture(HomeServiceApis.getCategoriesApi(systemService: SystemServiceKeys.aiWriter)).then((data) {
      categoryListResponse = data;
      final allCategoryElement = CategoryElement(name: "All", systemService: SystemServiceKeys.aiWriter, type: "all");
      categoryListResponse.insert(0, allCategoryElement);
      selectedCategory(allCategoryElement);
    }).catchError((e) {
      log('E: $e');
    }).whenComplete(() => isLoading(false));
  }
}
