import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stream_transform/stream_transform.dart';

import '../generated/assets.dart';
import '../main.dart';
import '../utils/app_common.dart';
import '../utils/colors.dart';
import '../utils/common_base.dart';
import '../utils/empty_error_state_widget.dart';
import 'loader_widget.dart';

class BSScontroller extends GetxController {
  BSScontroller({this.searchApiCall});

  TextEditingController searchCont = TextEditingController();
  RxBool isSearchText = false.obs;

  StreamController<String> searchStream = StreamController<String>();
  final _scrollController = ScrollController();
  final Function(String)? searchApiCall;

  @override
  void onInit() {
    _scrollController.addListener(() => Get.context != null ? hideKeyboard(Get.context) : null);
    searchStream.stream.debounce(const Duration(seconds: 1)).listen((s) {
      searchApiCall?.call(s);
    });
    super.onInit();
  }

  @override
  void onClose() {
    searchStream.close();
    if (Get.context != null) {
      _scrollController.removeListener(() => hideKeyboard(Get.context));
    }
    super.onClose();
  }
}

class BottomSelectionSheet extends StatelessWidget {
  final String title;
  final String? hintText;
  final String? noDataTitle;
  final String? noDataSubTitle;
  final String? errorText;
  final bool hasError;
  final bool isEmpty;
  final RxBool? isLoading;
  final void Function()? onRetry;
  final TextEditingController? searchTextCont;
  final Function(String)? onChanged;
  final Widget child;
  final bool hideSearchBar;
  final double heightRatio;
  final Function(String)? searchApiCall;
  final double? titlePaddingLeft;
  final double? closeIconPaddingRight;

  const BottomSelectionSheet({
    super.key,
    required this.title,
    this.hintText,
    required this.child,
    this.noDataTitle,
    this.noDataSubTitle,
    this.errorText,
    this.searchTextCont,
    this.hasError = false,
    this.isEmpty = false,
    this.onRetry,
    this.onChanged,
    this.isLoading,
    this.hideSearchBar = true,
    this.heightRatio = 0.80,
    this.searchApiCall,
    this.titlePaddingLeft,
    this.closeIconPaddingRight,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: BSScontroller(searchApiCall: searchApiCall),
      builder: (getxBSSCont) {
        return PopScope(
          canPop: true,
          onPopInvoked: (didPop) {
            handleCloseClick(context, getxBSSCont);
          },
          child: GestureDetector(
            onTap: () => hideKeyboard(context),
            behavior: HitTestBehavior.translucent,
            child: Container(
              width: Get.width,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: Stack(
                children: [
                  ListView(
                    shrinkWrap: true,
                    children: [
                      8.height,
                      AppTextField(
                        controller: getxBSSCont.searchCont,
                        textStyle: secondaryTextStyle(size: 14, color: textPrimaryColorGlobal),
                        textFieldType: TextFieldType.OTHER,
                        onChanged: (p0) {
                          onChanged?.call(p0);
                          getxBSSCont.isSearchText(getxBSSCont.searchCont.text.trim().isNotEmpty);
                          getxBSSCont.searchStream.add(p0);
                        },
                        decoration: inputDecorationWithOutBorder(
                          context,
                          hintText: hintText ?? "Search Here...",
                          prefixIcon: commonLeadingWid(imgPath: Assets.iconsIcSearch, size: 14).paddingAll(12),
                          filled: true,
                          fillColor: context.scaffoldBackgroundColor,
                          suffixIcon: Obx(
                            () => appCloseIconButton(
                              context,
                              onPressed: () {
                                handleCloseClick(context, getxBSSCont);
                              },
                              size: 11,
                            ).visible(getxBSSCont.isSearchText.value),
                          ),
                        ),
                      ).visible(!hideSearchBar),
                      32.height.visible(!hideSearchBar),
                      hasError
                          ? Obx(
                              () => NoDataWidget(
                                title: errorText ?? locale.value.somethingWentWrong,
                                retryText: locale.value.reload,
                                imageWidget: const ErrorStateWidget(),
                                onRetry: isLoading == true.obs ? null : onRetry,
                              ).paddingSymmetric(horizontal: 32),
                            )
                          : isEmpty
                              ? Obx(
                                  () => NoDataWidget(
                                    title: noDataTitle ?? "No Data Found",
                                    subTitle: noDataSubTitle,
                                    titleTextStyle: primaryTextStyle(),
                                    retryText: locale.value.reload,
                                    imageWidget: const EmptyStateWidget(),
                                    onRetry: isLoading == true.obs ? null : onRetry,
                                  ).paddingSymmetric(horizontal: 32),
                                )
                              : child,
                      32.height,
                    ],
                  ).paddingTop(56),
                  Positioned(
                    top: 8,
                    right: 0,
                    left: 0,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              title,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: primaryTextStyle(size: 18),
                            ).paddingOnly(left: titlePaddingLeft ?? 30).expand(),
                            appCloseIconButton(
                              context,
                              onPressed: () {
                                handleCloseClick(context, getxBSSCont);
                                Get.back();
                              },
                              size: 11,
                            ).paddingOnly(right: closeIconPaddingRight ?? 16),
                          ],
                        ),
                        Column(
                          children: [
                            Divider(
                              indent: 3,
                              height: 0,
                              color: isDarkMode.value ? borderColor.withOpacity(0.2) : borderColor.withOpacity(0.5),
                            ),
                            16.height,
                          ],
                        ),
                      ],
                    ),
                  ),
                  Obx(() => const LoaderWidget().center().visible(isLoading == null ? false.obs.value : isLoading!.value)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void handleCloseClick(BuildContext context, BSScontroller getxBSSCont) {
    if (searchApiCall != null && getxBSSCont.isSearchText.value) {
      searchApiCall?.call("");
    }
    hideKeyboard(context);
    getxBSSCont.searchCont.clear();
    getxBSSCont.isSearchText(getxBSSCont.searchCont.text.trim().isNotEmpty);
  }
}

void serviceCommonBottomSheet(BuildContext context, {required Widget child, final Function(dynamic)? onSheetClose}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
    ),
    builder: (context) => child,
  ).then((value) {
    onSheetClose?.call(value);
  });
}
