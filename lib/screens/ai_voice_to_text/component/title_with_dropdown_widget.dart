import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/generated/assets.dart';

import '../../../../utils/app_common.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/common_base.dart';

class TitleWithDropDownWidget extends StatefulWidget {
  final String fieldText;
  final String hintText;
  final List dropDownList;
  final Object? value;
  final Function(dynamic)? onChanged;
  final TextStyle? hintTextStyle;
  const TitleWithDropDownWidget({super.key, required this.dropDownList, this.value, this.onChanged, required this.fieldText, required this.hintText, this.hintTextStyle});

  @override
  State<TitleWithDropDownWidget> createState() => _TitleWithDropDownWidgetState();
}

class _TitleWithDropDownWidgetState extends State<TitleWithDropDownWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.fieldText,
          style: primaryTextStyle(
            size: 14,
            weight: FontWeight.w400,
            color: isDarkMode.value ? whiteTextColor : canvasColor,
          ),
        ),
        10.height,
        DropdownButtonFormField(
          icon: Image.asset(
            Assets.iconsIcDropDown,
            color: bodyWhite,
            height: 10,
            width: 6,
          ),
          decoration: inputDecoration(
            context,
            fillColor: context.cardColor,
            filled: true,
            hintText: widget.hintText,
          ),
          isExpanded: true,
          value: widget.value,
          dropdownColor: context.cardColor,
          items: widget.dropDownList.map((e) {
            return DropdownMenuItem<dynamic>(
              value: e,
              child: Text(e.toString(), style: primaryTextStyle(size: 12, weight: FontWeight.w400), maxLines: 1, overflow: TextOverflow.ellipsis),
            );
          }).toList(),
          onChanged: widget.onChanged,
        ),
      ],
    );
  }
}
