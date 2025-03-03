import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/components/app_scaffold.dart';
import 'package:Cortex/generated/assets.dart';
import 'package:Cortex/utils/common_base.dart';

import '../../components/cached_image_widget.dart';
import '../../components/common_file_placeholders.dart';
import '../../components/loader_widget.dart';
import '../../main.dart';
import '../../utils/animated_list_reverse_paginated.dart';
import '../../utils/app_common.dart';
import '../../utils/colors.dart';
import '../../utils/empty_error_state_widget.dart';
import '../../utils/zoom_image_screen.dart';
import 'ai_chat_controller.dart';
import 'component/answer_component.dart';
import 'component/question_component.dart';
import 'voice_search_component.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  final AiChatController aiChatController = Get.put(AiChatController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppScaffold(
        appBartitleText: aiChatController.recentChatElement.value.title,
        isLoading: aiChatController.isLoading,
        body: Obx(
          () => SnapHelperWidget(
            future: aiChatController.getMessagesResponseFuture.value,
            errorBuilder: (error) {
              return NoDataWidget(
                title: error,
                retryText: locale.value.reload,
                imageWidget: const ErrorStateWidget(),
                onRetry: () {
                  aiChatController.page(1);
                  aiChatController.getMessageList();
                },
              ).paddingSymmetric(horizontal: 32);
            },
            loadingWidget: aiChatController.isLoading.value ? const Offstage() : const LoaderWidget(),
            onSuccess: (recentChatRes) {
              return Column(
                children: [
                  SingleChildScrollView(
                    controller: aiChatController.scrollController,
                    child: Obx(() => AnimatedListViewReversePaginated(
                          shrinkWrap: true,
                          itemCount: aiChatController.messageList.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            if (aiChatController.messageList[index].from == loginUserData.value.id) {
                              return QuestionComponent(
                                question: aiChatController.messageList[index],
                              );
                            } else {
                              return AnswerComponent(
                                answer: aiChatController.messageList[index],
                                modelSelectClick: () {
                                  try {
                                    if (aiChatController.messageList[index - 1].images.isEmpty) {
                                      aiChatController.messageList[index].showModelSelection(!aiChatController.messageList[index].showModelSelection.value);
                                    } else {
                                      toast("Image functionality is only supported with GPT-4o. You can't choose another model while using images.");
                                    }
                                  } catch (e) {
                                    log('modelSelectClick E: $e');
                                    aiChatController.messageList[index].showModelSelection(!aiChatController.messageList[index].showModelSelection.value);
                                  }
                                },
                                onRegeneratePressed: () async {
                                  try {
                                    aiChatController.promptCont.text = aiChatController.messageList[index - 1].messageText.value;
                                    aiChatController.promptCont.text = aiChatController.messageList[index - 1].messageText.value;
                                    hideKeyboard(context);
                                    aiChatController.generateContent();
                                  } catch (e) {
                                    log('E: $e');
                                    toast(locale.value.apologiesForTheInconvenienceThisResponseCanno);
                                  }
                                },
                                onSpeakerPressed: () async {
                                  if (aiChatController.isSpeak.value) {
                                    aiChatController.flutterTts.stop();
                                  } else {
                                    aiChatController.chatBotSpeak(text: aiChatController.messageList[index].messageText.value);
                                  }
              
                                  aiChatController.isSpeak.value = !aiChatController.isSpeak.value;
                                },
                                onCopyPressed: () {
                                  if (!aiChatController.showCopied.value) {
                                    aiChatController.messageList[index].messageText.value.copyToClipboard().then((value) {
                                      toast(locale.value.copied);
                                      aiChatController.showCopied(true);
                                      Future.delayed(const Duration(milliseconds: 800), () {
                                        aiChatController.showCopied(false);
                                      });
                                    });
                                  }
                                },
                              );
                            }
                          },
                          onNextPage: () async {
                            if (!aiChatController.isLastPage.value) {
                              aiChatController.page(aiChatController.page.value + 1);
                              aiChatController.getMessageList();
                            }
                          },
                        )),
                  ).expand(),
                  Obx(
                    () => Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                          if (aiChatController.pickedfilePath.value.contains(RegExp(r'\.jpeg|\.jpg|\.gif|\.png|\.bmp'))) {
                            Get.to(() => ZoomImageScreen(index: 0, galleryImages: [aiChatController.pickedfilePath.value]));
                          } else {
                            viewFiles(aiChatController.pickedfilePath.value);
                          }
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: Loader(),
                            ),
                            aiChatController.pickedfilePath.value.contains(RegExp(r'\.jpeg|\.jpg|\.gif|\.png|\.bmp'))
                                ? CachedImageWidget(
                                    url: aiChatController.pickedfilePath.value,
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                    radius: 8,
                                  )
                                : Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: boxDecorationRoundedWithShadow(defaultRadius.toInt(), backgroundColor: context.cardColor),
                                    child: CommonPdfPlaceHolder(
                                      text: "${aiChatController.pickedfilePath.value.getFileExtension.replaceAll(".", "").capitalize} file",
                                      height: 60,
                                      width: 45,
                                      iconSize: 24,
                                      textSize: 10,
                                      fileExt: aiChatController.pickedfilePath.value.getFileExtension,
                                    ),
                                  ),
                            Positioned(
                              top: -20,
                              right: -20,
                              child: appCloseIconButton(
                                size: 10,
                                context,
                                onPressed: () {
                                  aiChatController.pickedfilePath("");
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).paddingSymmetric(horizontal: 16).paddingTop(8).visible(aiChatController.pickedfilePath.value.isNotEmpty),
                  ),
                  SizedBox(
                    child: Row(
                      children: [
                        AppTextField(
                          textFieldType: TextFieldType.MULTILINE,
                          controller: aiChatController.promptCont,
                          focus: aiChatController.promptFocus,
                          cursorColor: appColorPrimary,
                          minLines: 1,
                          onChanged: (p0) {
                            aiChatController.enableSendBtn(p0.trim().isNotEmpty);
                          },
                          suffix: Container(
                            height: 40,
                            width: 40,
                            decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle, backgroundColor: isDarkMode.value ? appScreenBackgroundDark : appScreenBackground),
                            child: Assets.iconsIcMicrophone.iconImage(size: 20, color: appColorPrimary).center(),
                          ).onTap(() {
                            aiChatController.startListening();
                          }).paddingAll(6),
                          decoration: inputDecoration(
                            context,
                            hintText: locale.value.typeAMessage,
                            fillColor: context.cardColor,
                            filled: true,
                            prefixIcon: IconButton(
                              icon: Transform.rotate(
                                angle: -0.75,
                                child: const Icon(Icons.attach_file_outlined, color: appColorPrimary),
                              ),
                              onPressed: () {
                                if (!aiChatController.isLoading.value) {
                                  aiChatController.showBottomSheet(context);
                                }
                              },
                            ),
                          ),
                        ).flexible(),
                        8.width,
                        Obx(
                          () => GestureDetector(
                            onTap: () {

                              hideKeyboard(context);
                              if(aiChatController.promptCont.text.isNotEmpty)
                                {
                                  if (aiChatController.enableSendBtn.value ) {
                                    aiChatController.generateContent();
                                  }
                                }
                              else{
                                toast("Please enter text");// TODO : add languages
                              }

                            },
                            child: Container(

                              width: 52,
                              height: 52,
                              decoration: boxDecorationWithRoundedCorners(backgroundColor: aiChatController.enableSendBtn.value ? appColorPrimary : gray.withOpacity(0.3), boxShape: BoxShape.circle),
                              child:const Icon(Icons.send,color: appSectionBackground)
                            ),
                          ),
                        )
                      ],
                    ),
                  ).paddingSymmetric(horizontal: 16).paddingOnly(top: aiChatController.pickedfilePath.value.isNotEmpty ? 8 : 16, bottom: 16),
                  Obx(() => const VoiceSearchComponent().visible(aiChatController.speechStatus.value))
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
