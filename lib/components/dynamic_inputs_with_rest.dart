import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/components/decimal_input_formater.dart';
import '../screens/ai_writer/model/template_res_model.dart';
import '../utils/app_common.dart';
import '../utils/colors.dart';
import '../utils/common_base.dart';
import 'bottom_selection_widget.dart';
import 'cached_image_widget.dart';

class DynamicInputsWidget extends StatelessWidget {
  final List<DynamicInputModel> inputTypes;

  const DynamicInputsWidget({super.key, required this.inputTypes});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: inputTypes.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        DynamicInputModel inputElement = inputTypes[index];
        switch (inputElement.inputType) {
          case 'single_select':
            return AppTextField(
              title: inputElement.fieldTitle,
              spacingBetweenTitleAndTextFormField: 8,
              textStyle: primaryTextStyle(size: 12),
              controller: inputElement.nameCont,
              textFieldType: TextFieldType.OTHER,
              isValidationRequired: inputElement.isRequired,
              readOnly: true,
              onTap: () async {
                serviceCommonBottomSheet(
                  context,
                  child: BottomSelectionSheet(
                    title: "Choose ${inputElement.fieldTitle}",
                    hintText: "Search for ${inputElement.fieldTitle}",
                    isEmpty: inputElement.optionData.isEmpty,
                    child: AnimatedWrap(
                      runSpacing: 8,
                      spacing: 8,
                      itemCount: inputElement.optionData.length,
                      listAnimationType: ListAnimationType.None,
                      itemBuilder: (_, index) {
                        debugPrint('INPUTELEMENT.SELECTEDCHOICE.VALUE.ID ${inputElement.selectedChoice.value.id}: ${inputElement.selectedChoice.value.id == inputElement.optionData[index].id}');
                        return Obx(
                          () => GestureDetector(
                            onTap: () {
                              inputElement.selectedChoice(inputElement.optionData[index]);
                              inputElement.nameCont.text = inputElement.optionData[index].title;
                              Get.back();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              decoration: boxDecorationDefault(
                                color: inputElement.selectedChoice.value.value == inputElement.optionData[index].value
                                    ? isDarkMode.value
                                        ? appColorPrimary
                                        : lightPrimaryColor
                                    : isDarkMode.value
                                        ? fullDarkCanvasColorDark
                                        : Colors.grey.shade100,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    inputElement.optionData[index].title,
                                    style: secondaryTextStyle(
                                      color: inputElement.selectedChoice.value.value == inputElement.optionData[index].value
                                          ? isDarkMode.value
                                              ? whiteColor
                                              : appColorPrimary
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ).paddingSymmetric(horizontal: 16, vertical: 16),
                  ),
                );
              },
              decoration: inputDecoration(
                context,
                hintText: inputElement.description.isNotEmpty ? inputElement.description : "Choose ${inputElement.fieldTitle}",
                fillColor: context.cardColor,
                filled: true,
                prefixIconConstraints: BoxConstraints.loose(const Size.square(60)),
                prefixIcon: Obx(
                  () => inputElement.selectedChoice.value.icon.isEmpty || inputElement.selectedChoice.value.id.isNegative
                      ? const SizedBox(width: 12)
                      : CachedImageWidget(
                          url: inputElement.selectedChoice.value.icon,
                          height: 35,
                          width: 35,
                          fit: BoxFit.cover,
                          circle: true,
                          usePlaceholderIfUrlEmpty: true,
                        ).paddingOnly(left: 12, top: 8, bottom: 8, right: 12),
                ),
                suffixIcon: Obx(
                  () => (inputElement.disableRemoveBtn || (inputElement.selectedChoice.value.icon.isEmpty && inputElement.selectedChoice.value.id.isNegative)).obs.value
                      ? Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 24,
                          color: darkGray.withOpacity(0.5),
                        )
                      : appCloseIconButton(
                          context,
                          onPressed: () {
                            inputElement.nameCont.clear();
                            inputElement.selectedChoice(OptionData());
                          },
                          size: 11,
                        ),
                ),
              ),
            );
          case 'text_input':
            return AppTextField(
              title: inputElement.fieldTitle,
              spacingBetweenTitleAndTextFormField: 8,
              textStyle: primaryTextStyle(size: 12),
              textFieldType: TextFieldType.NAME,
              isValidationRequired: inputElement.isRequired,
              controller: inputElement.nameCont,
              focus: inputElement.nameFocus,
              decoration: inputDecoration(
                context,
                hintText: inputElement.description.isNotEmpty ? inputElement.description : "Enter ${inputElement.fieldTitle} here...",
                fillColor: context.cardColor,
                filled: true,
              ),
            );
          case 'number_input':
            return AppTextField(
              title: inputElement.fieldTitle,
              spacingBetweenTitleAndTextFormField: 8,
              textStyle: primaryTextStyle(size: 12),
              textFieldType: TextFieldType.NUMBER,
              keyboardType: const TextInputType.numberWithOptions(),
              isValidationRequired: inputElement.isRequired,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9]')),
              ],
              controller: inputElement.nameCont,
              focus: inputElement.nameFocus,
              decoration: inputDecoration(
                context,
                hintText: inputElement.description.isNotEmpty ? inputElement.description : "0",
                fillColor: context.cardColor,
                filled: true,
              ),
            );
          case 'decimal_input':
            return AppTextField(
              title: inputElement.fieldTitle,
              spacingBetweenTitleAndTextFormField: 8,
              textStyle: primaryTextStyle(size: 12),
              textFieldType: TextFieldType.NUMBER,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              isValidationRequired: inputElement.isRequired,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                DecimalTextInputFormatter(decimalRange: 2),
              ],
              controller: inputElement.nameCont,
              focus: inputElement.nameFocus,
              decoration: inputDecoration(
                context,
                hintText: inputElement.description.isNotEmpty ? inputElement.description : "0",
                fillColor: context.cardColor,
                filled: true,
              ),
            );
          case 'textarea':
            return AppTextField(
              title: inputElement.fieldTitle,
              spacingBetweenTitleAndTextFormField: 8,
              textStyle: primaryTextStyle(size: 12),
              textFieldType: TextFieldType.MULTILINE,
              isValidationRequired: inputElement.isRequired,
              minLines: 15,
              maxLines: 15,
              controller: inputElement.nameCont,
              focus: inputElement.nameFocus,
              decoration: inputDecoration(
                context,
                hintText: inputElement.description.isNotEmpty ? inputElement.description : "Enter ${inputElement.fieldTitle} here...",
                fillColor: context.cardColor,
                filled: true,
              ),
            );
          // Add more cases for other input types
          default:
            return const SizedBox.shrink();
        }
      },
      separatorBuilder: (context, index) => 16.height,
    ).paddingSymmetric(horizontal: 16);
  }
}
