import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TemplateRes {
  bool status;
  List<DynamicInputModel> inputs;
  String prompt;
  String message;
  TemplateRes({
    this.status = false,
    this.inputs = const <DynamicInputModel>[],
    this.prompt = "",
    this.message = "",
  });

  factory TemplateRes.fromJson(Map<String, dynamic> json) {
    return TemplateRes(
      status: json['status'] is bool ? json['status'] : false,
      inputs: json['data'] is List ? List<DynamicInputModel>.from(json['data'].map((x) => DynamicInputModel.fromJson(x))) : [],
      prompt: json['prompt'] is String ? json['prompt'] : "",
      message: json['message'] is String ? json['message'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': inputs.map((e) => e.toJson()).toList(),
      'message': message,
      'prompt': prompt,
    };
  }
}

class DynamicInputModel {
  int index;
  String fieldTitle;
  String inputType;
  String inputTag;
  String description;
  bool isRequired;
  String defaultValue;
  bool disableRemoveBtn;
  List<OptionData> optionData;
  Rx<OptionData> selectedChoice = OptionData().obs;
  TextEditingController nameCont;
  FocusNode nameFocus;

  DynamicInputModel({
    this.index = -1,
    required this.fieldTitle,
    required this.inputType,
    required this.inputTag,
    required this.description,
    required this.isRequired,
    required this.defaultValue,
    required this.disableRemoveBtn,
    required this.optionData,
    required this.nameCont,
    required this.nameFocus,
  });

  factory DynamicInputModel.fromJson(Map<String, dynamic> json) {
    return DynamicInputModel(
      index: json['index'] is int ? json['index'] : -1,
      fieldTitle: json['input_title'] is String ? json['input_title'] : "",
      inputType: json['input_type'] is String ? json['input_type'] : "",
      inputTag: json['input_tag'] is String ? json['input_tag'] : "",
      description: json['description'] is String ? json['description'] : "",
      isRequired: json['is_required'] is bool ? json['is_required'] : json['is_required'] == 1,
      defaultValue: json['default_value'] is String ? json['default_value'] : "",
      disableRemoveBtn: json['disable_remove_btn'] is bool ? json['disable_remove_btn'] : json['disable_remove_btn'] == 1,
      optionData: json['option_data'] is List ? List<OptionData>.from(json['option_data'].map((x) => OptionData.fromJson(x))) : [],
      nameCont: TextEditingController(),
      nameFocus: FocusNode(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'input_title': fieldTitle,
      'input_type': inputType,
      'input_tag': inputTag,
      'description': description,
      'is_required': isRequired,
      'disable_remove_btn': disableRemoveBtn,
      'default_value': defaultValue,
      'option_data': optionData.map((e) => e.toJson()).toList(),
      'name_cont': nameCont.text,
    };
  }
}

class OptionData {
  int id;
  String title;
  String icon;
  String value;

  OptionData({
    this.id = -1,
    this.title = "",
    this.icon = "",
    this.value = "",
  });

  factory OptionData.fromJson(Map<String, dynamic> json) {
    return OptionData(
      id: json['id'] is int ? json['id'] : -1,
      title: json['title'] is String ? json['title'] : "",
      icon: json['icon'] is String ? json['icon'] : "",
      value: json['value'] is String ? json['value'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'icon': icon,
      'value': value,
    };
  }
}
