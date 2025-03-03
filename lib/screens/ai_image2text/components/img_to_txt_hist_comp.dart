import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/components/app_dialog_widget.dart';
import 'package:Cortex/utils/colors.dart';

import '../../../../components/cached_image_widget.dart';
import '../../../generated/assets.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/common_base.dart';
import '../../home/model/history_data_model.dart';
import 'img_to_txt_result_screen.dart';
import '../ai_img_to_txt_controller.dart';
import '../model/tags_desc_response.dart';

class ImgToTxtHistComp extends StatelessWidget {
  final TagsAndDesCustomResponse tAndDResponse;
  final HistoryElement historyElementData;

  ImgToTxtHistComp({super.key, required this.tAndDResponse, required this.historyElementData});

  final AiImgToTxtController aiImgToTxtController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        try {
          Get.find<AiImgToTxtController>().selectedTagsAndDescriptions(tAndDResponse);
          Get.to(() => ImgToTxtResultScreen(), duration: const Duration(milliseconds: 500));
        } catch (e) {
          log('Get.find<AiImgToTxtController E: $e');
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: boxDecorationDefault(color: context.cardColor),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: tAndDResponse.reqImageUrl.isNotEmpty ? tAndDResponse.reqImageUrl : currentMillisecondsTimeStamp().toString(),
              child: Container(
                decoration: boxDecorationDefault(),
                child: CachedImageWidget(
                  url: tAndDResponse.reqImageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  topLeftRadius: defaultRadius.toInt(),
                  bottomLeftRadius: defaultRadius.toInt(),
                  topRightRadius: 0,
                  bottomRightRadius: 0,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                8.height,
                Text(
                  tAndDResponse.tags.join(", "),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: secondaryTextStyle(
                    color: appColorPrimary,
                    fontStyle: FontStyle.italic,
                    fontFamily: GoogleFonts.instrumentSans(fontWeight: FontWeight.w600).fontFamily,
                  ),
                ),
                4.height,
                Hero(
                  tag: tAndDResponse.description.formattedHeroTag,
                  child: Text(
                    tAndDResponse.description,
                    style: primaryTextStyle(decoration: TextDecoration.none),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ).paddingOnly(left: 16).expand(),
            IconButton(
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              onPressed: () {
                showAppDialog(
                  context,
                  buttonColor: appColorPrimary,
                  negativeText: locale.value.cancel,
                  positiveText: locale.value.delete,
                  onConfirm: () {
                    /// Clear History Api
                    aiImgToTxtController.clearUserHistory(historyId: historyElementData.id);
                  },
                  dialogType: AppDialogType.delete,
                  dialogText: locale.value.doYouReallyWantToDeleteThisFromYourHistory,
                  titleText: locale.value.clearHistory,
                );
              },
              icon: commonLeadingWid(imgPath: Assets.iconsIcDelete, color: deleteTextColor, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}
