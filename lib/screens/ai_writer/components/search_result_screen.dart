import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/generated/assets.dart';
import 'package:Cortex/screens/favourite/models/favourite_res_model.dart';
import 'package:Cortex/screens/favourite/services/favourite_services_api.dart';
import 'package:Cortex/utils/colors.dart';
import 'package:Cortex/utils/common_base.dart';
import 'package:Cortex/utils/empty_error_state_widget.dart';
import '../../../utils/app_common.dart';
import '../ai_writer_controller.dart';
import '../content_generator.dart';

class SearchResultComponent extends StatelessWidget {
  final AiWriterController aiWriterController;

  SearchResultComponent({super.key, required this.aiWriterController});

  final RxBool isFavClicked = false.obs;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 16,
      spacing: 16,
      children: aiWriterController.searchedTemplateListResponse.isNotEmpty
          ? aiWriterController.searchedTemplateListResponse.map((data) {
              return GestureDetector(
                onTap: () {
                  Get.to(() => ContentGenScreen(), arguments: data);
                },
                child: Container(
                  width: Get.width / 2 - 24,
                  height: Get.width / 2 - 24,
                  decoration: boxDecoration(color: context.cardColor),
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Assets.iconsIcAiPhotoEnhancer.iconImage(size: 22),
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  doIfLoggedIn(() async {
                                    if (isFavClicked.value) return;
                                    isFavClicked(true);
                                    FavouriteServices.onTapFavourite(favData: FavData(templateData: data)).whenComplete(() => isFavClicked(false));
                                  });
                                },
                                icon: Obx(
                                  () => Icon(
                                    data.inWishList.value ? Icons.star : Icons.star_border_outlined,
                                    color: isDarkMode.value ? appColorSecondary : appColorPrimary,
                                    size: 20,
                                  ),
                                ),
                              )
                            ],
                          ),
                          const Spacer(),
                          Text(data.templateName, style: primaryTextStyle(), maxLines: 2, overflow: TextOverflow.ellipsis),
                          const Spacer(),
                          Text(data.description, style: secondaryTextStyle(), maxLines: 3, overflow: TextOverflow.ellipsis),
                        ],
                      ).paddingAll(16),
                    ],
                  ),
                ),
              );
            }).toList()
          :[!aiWriterController.isLoading.value?SizedBox(
                height: Get.height * 0.7,
                child: NoDataWidget(
                  title: "No data Found", //TODO String Translation
                  imageWidget: const ErrorStateWidget(),
                ).paddingSymmetric(horizontal: 16).center(),
              ): const Offstage()
            ],
    ).paddingSymmetric(horizontal: 16);
  }
}
