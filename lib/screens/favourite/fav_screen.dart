import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/screens/favourite/fav_controller.dart';
import '../../components/app_scaffold.dart';
import '../../components/loader_widget.dart';
import '../../main.dart';
import '../../utils/colors.dart';
import '../../utils/empty_error_state_widget.dart';
import '../ai_writer/content_generator.dart';
import '../home/components/template_component.dart';


class FavouriteScreen extends StatelessWidget {
  FavouriteScreen({super.key});

  final FavController favController = Get.put(FavController());

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBartitleText: locale.value.yourFavourites,
      isLoading: favController.isLoading,
      hasLeadingWidget: false,
      body: RefreshIndicator(
        color: appColorPrimary,
        onRefresh: () async {
          favController.page(1);
          return await favController.favouriteTemplateList();
        },
        child: Obx(
          () => SnapHelperWidget(
            future: favController.getFavouriteListResponseFuture.value,
            errorBuilder: (error) {
              return NoDataWidget(
                title: error,
                retryText: locale.value.reload,
                imageWidget: const ErrorStateWidget(),
                onRetry: () {
                  favController.page(1);
                  favController.favouriteTemplateList(showLoader: true);
                },
              ).paddingSymmetric(horizontal: 32);
            },
            loadingWidget: favController.isLoading.value ? const Offstage() : const LoaderWidget(),
            onSuccess: (favouritesRes) {
              return Obx(
                () => favController.favourites.isEmpty
                    ? NoDataWidget(
                        title: locale.value.oppsNoFavouriteTemplatesAvailable,
                        titleTextStyle: primaryTextStyle(),
                        imageWidget: const EmptyStateWidget(),
                        retryText: locale.value.reload,
                        onRetry: () {
                          favController.page(1);
                          favController.favouriteTemplateList(showLoader: true);
                        },
                      ).visible(!favController.isLoading.value).paddingSymmetric(horizontal: 32).paddingBottom(84)
                    : GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                        ),
                        itemCount: favController.favourites.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Obx(
                            () => GestureDetector(
                              onTap: () {
                                Get.to(() => ContentGenScreen(), arguments: favController.favourites[index].templateData);
                              },
                              child: TemplateComponent(
                                isLoading: favController.isLoading,
                                customTemplate: favController.favourites[index].templateData.obs,
                                onTapCard: () {
                                  Get.to(() => ContentGenScreen(), arguments: favController.favourites[index].templateData);
                                },
                              ),
                            ),
                          );
                        },
                      ).paddingSymmetric(horizontal: 16),
              );
            },
          ),
        ),
      ),
    );
  }
}
