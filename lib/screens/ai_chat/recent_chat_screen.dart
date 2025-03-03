import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/app_scaffold.dart';
import '../../components/loader_widget.dart';
import '../../generated/assets.dart';
import '../../main.dart';
import '../../utils/app_common.dart';
import '../../utils/colors.dart';
import '../../utils/common_base.dart';
import '../../utils/constants.dart';
import '../../utils/empty_error_state_widget.dart';
import '../home/services/system_service_helper.dart';
import 'chat_screen.dart';
import 'component/explore_more_component.dart';
import 'component/recent_component.dart';
import 'component/tool_tip_shape_border.dart';
import 'recent_chat_controller.dart';

class RecentChatScreen extends StatelessWidget {
  final bool isFromBottomTab;
  RecentChatScreen({super.key, this.isFromBottomTab = false});

  final RecentChatController recentChatController = Get.put(RecentChatController());

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBartitleText: appBarTitle,
      hasLeadingWidget: !isFromBottomTab,
      isLoading: recentChatController.isLoading,
      actions: [
        TextButton(
          onPressed: () {
            doIfLoggedIn(() {
              Get.to(() => ChatScreen());
            });
          },
          child: Text(
            locale.value.newChat,
            style: primaryTextStyle(
              color: appColorPrimary,
              size: 16,
              fontFamily: GoogleFonts.instrumentSans(fontWeight: FontWeight.w600).fontFamily,
            ),
          ).paddingSymmetric(horizontal: 8),
        )
      ],
      body: Obx(
        () => Stack(
          fit: StackFit.expand,
          children: [
            AnimatedScrollView(
              listAnimationType: ListAnimationType.None,
              children: [
                _buildAIAssistantWidget(context).center(),
                Obx(
                  () => isLoggedIn.value
                      ? SnapHelperWidget(
                          future: recentChatController.getRecentChatsResponseFuture.value,
                          errorBuilder: (error) {
                            return NoDataWidget(
                              title: error,
                              retryText: locale.value.reload,
                              imageWidget: const ErrorStateWidget(),
                              onRetry: () {
                                recentChatController.page(1);
                                recentChatController.recentChatList();
                              },
                            ).paddingSymmetric(horizontal: 32).visible(!recentChatController.isLoading.value);
                          },
                          loadingWidget: recentChatController.isLoading.value ? const Offstage() : const LoaderWidget(),
                          onSuccess: (recentChatRes) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                20.height,
                                Text(locale.value.recentChats, style: primaryTextStyle(size: 18)).paddingSymmetric(horizontal: 16).visible(recentChatController.recentChats.isNotEmpty),
                                AnimatedListView(
                                  shrinkWrap: true,
                                  listAnimationType: ListAnimationType.None,
                                  itemCount: recentChatController.recentChats.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  emptyWidget: NoDataWidget(
                                    title: locale.value.recentChats,
                                    subTitle: locale.value.startAskingYourQueriesToAiByClickingNewChatBu,
                                    titleTextStyle: primaryTextStyle(),
                                    imageWidget: const EmptyStateWidget(),
                                  ).paddingSymmetric(horizontal: 32).paddingBottom(84),
                                  itemBuilder: (context, index) {
                                    return RecentComponent(
                                      recentChatElement: recentChatController.recentChats[index],
                                      onPressed: () => Get.to(() => ChatScreen(), arguments: recentChatController.recentChats[index]),
                                    ).visible(recentChatController.recentChats[index].title.isNotEmpty).paddingSymmetric(vertical: 8, horizontal: 16);
                                  },
                                  onNextPage: () async {
                                    if (!recentChatController.isLastPage.value) {
                                      recentChatController.page(recentChatController.page.value + 1);
                                      recentChatController.recentChatList();
                                    }
                                  },
                                  onSwipeRefresh: () async {
                                    recentChatController.page(1);
                                    return await recentChatController.recentChatList(showLoader: false);
                                  },
                                ),
                              ],
                            );
                          },
                        )
                      : const Offstage(),
                ),
                20.height,
                _buildExploreMoreWidget(context),
                isFromBottomTab ? 85.height : 50.height
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExploreMoreWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(locale.value.exploreMore, style: primaryTextStyle(size: 18)).paddingSymmetric(horizontal: 16),
        8.height,
        HorizontalList(
          itemCount: recentChatController.exploreMoreList.length,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return ExploreMoreComponent(
              exploreMoreItem: recentChatController.exploreMoreList[index],
              onTapCard: () {
                doIfLoggedIn(() {
                  Get.to(() => ChatScreen(), arguments: recentChatController.exploreMoreList[index].title);
                });
              },
            ).paddingOnly(right: index < 4 ? 8 : 16, left: index > 0 ? 8 : 18);
          },
        ),
      ],
    );
  }

  Widget _buildAIAssistantWidget(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            doIfLoggedIn(() {
              /// Start Listening
              recentChatController.startListening();
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Obx(() => Lottie.asset(Assets.lottieVoiceAssistant, height: 230, width: 230).visible(recentChatController.speechStatus.value)),
              Container(
                height: 180,
                width: 180,
                decoration: boxDecorationDefault(color: context.scaffoldBackgroundColor, shape: BoxShape.circle),
              ),
              Image.asset(
                isDarkMode.value ? Assets.imagesVoiceEffectDark : Assets.imagesVoiceEffect,
                fit: BoxFit.cover,
                height: 230,
                width: 230,
              ),
              Positioned(
                top: 20,
                right: 30,
                child: Container(
                  decoration: ShapeDecoration(
                    color: isDarkMode.value ? fullDarkCanvasColorDark : appSectionBackground,
                    shape: const TooltipShapeBorder(arrowArc: 0.3),
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text('${locale.value.hey} ${loginUserData.value.firstName}', style: primaryTextStyle(size: 12, weight: FontWeight.w500, color: isDarkMode.value ? whiteTextColor : canvasColor, fontFamily: GoogleFonts.heebo().fontFamily)),
                ),
              ),
            ],
          ),
        ),
        if (recentChatController.speechStatus.value) 16.height,
        Text(
          locale.value.tapToChatWithYourAiAssistant,
          style: primaryTextStyle(size: 18, weight: FontWeight.w500, color: isDarkMode.value ? whiteTextColor : canvasColor),
        ),
        8.height,
        Text(
          locale.value.chatWithYourPersonalAssistantAndAskMeYourQues,
          textAlign: TextAlign.center,
          style: primaryTextStyle(size: 14, weight: FontWeight.w400, color: appBodyColor),
        ),
        10.height,
      ],
    ).paddingSymmetric(horizontal: 24);
  }

  String get appBarTitle => getSystemServicebyKey(type: SystemServiceKeys.aiChat).name.isNotEmpty ? getSystemServicebyKey(type: SystemServiceKeys.aiChat).name : 'AI Chat';
}
