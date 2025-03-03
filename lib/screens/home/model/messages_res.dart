import 'dart:convert';

import 'package:get/get.dart';

import '../../../open_ai/models/gpt_model.dart';
import '../../../utils/constants.dart';

class MessegesRes {
  bool status;
  List<MessegeElement> data;
  String message;

  MessegesRes({
    this.status = false,
    this.data = const <MessegeElement>[],
    this.message = "",
  });

  factory MessegesRes.fromJson(Map<String, dynamic> json) {
    return MessegesRes(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is List ? List<MessegeElement>.from(json['data'].map((x) => MessegeElement.fromJson(x))) : [],
      message: json['message'] is String ? json['message'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((e) => e.toJson()).toList(),
      'message': message,
    };
  }
}

class MessegeElement {
  int id;
  int chatId;
  int from;
  int to;
  RxString messageText;
  String time;
  int wordCount;
  int imageCount;
  List<String> images;
  String createdAt;

  Rx<GPTModel> selectedModel;
  Rx<GPTModel> currentModel = gpt4oMiniModel;
  RxBool showModelSelection = false.obs;

  MessegeElement({
    this.id = -1,
    this.chatId = -1,
    this.from = -1,
    this.to = -1,
    required this.messageText,
    this.time = "",
    this.wordCount = 0,
    this.imageCount = 0,
    this.images = const <String>[],
    this.createdAt = "",
    required this.selectedModel,
  });

  factory MessegeElement.fromJson(Map<String, dynamic> json) {
    final fromId = json['from'] is int ? json['from'] : -1;
    final selectedModelFromId = gptModels.firstWhere(
      (e) => e.id == fromId,
      orElse: () => gptModels.isNotEmpty ? gptModels.first : gpt4oModel.value,
    );

    return MessegeElement(
      id: json['id'] is int ? json['id'] : -1,
      chatId: json['chat_id'] is int ? json['chat_id'] : -1,
      from: fromId,
      to: json['to'] is int ? json['to'] : -1,
      messageText: json['message_text'] is String ? (json['message_text'] as String).obs : "".obs,
      time: json['time'] is String ? json['time'] : "",
      wordCount: json['word_count'] is int ? json['word_count'] : 0,
      imageCount: json['image_count'] is int ? json['image_count'] : 0,
      images: json['images'] is List ? List<String>.from(json['images'].map((x) => x)) : [],
      createdAt: json['created_at'] is String ? json['created_at'] : "",
      selectedModel: selectedModelFromId.obs,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (!id.isNegative) 'id': id,
      'chat_id': chatId,
      'from': from,
      'to': to,
      'message_text': messageText.value,
      'time': time,
      'word_count': wordCount,
      'image_count': imageCount,
      if (images.isNotEmpty) 'images': jsonEncode(images.map((e) => e).toList()),
      'created_at': createdAt,
    };
  }
}
