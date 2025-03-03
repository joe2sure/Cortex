import 'dart:convert';

class HistoryResponse {
  bool status;
  List<HistoryElement> data;
  String message;

  HistoryResponse({
    this.status = false,
    this.data = const <HistoryElement>[],
    this.message = "",
  });

  factory HistoryResponse.fromJson(Map<String, dynamic> json) {
    return HistoryResponse(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is List ? List<HistoryElement>.from(json['data'].map((x) => HistoryElement.fromJson(x))) : [],
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

class HistoryElement {
  int id;
  int userId;
  String type;
  HistoryData historyData;
  int wordCount;
  int imageCount;
  int templateId;
  List<String> histroyImage;

  HistoryElement({
    this.id = -1,
    this.userId = -1,
    this.type = "",
    required this.historyData,
    this.wordCount = -1,
    this.imageCount = -1,
    this.templateId = -1,
    this.histroyImage = const <String>[],
  });

  factory HistoryElement.fromJson(Map<String, dynamic> json) {
    return HistoryElement(
      id: json['id'] is int ? json['id'] : -1,
      userId: json['user_id'] is int ? json['user_id'] : -1,
      type: json['type'] is String ? json['type'] : "",
      historyData: json['history_data'] is String && jsonDecode(json['history_data']) is Map ? HistoryData.fromJson(jsonDecode(json['history_data'])) : HistoryData(),
      wordCount: json['word_count'] is int ? json['word_count'] : -1,
      imageCount: json['image_count'] is int ? json['image_count'] : -1,
      templateId: json['template_id'] is int ? json['template_id'] : -1,
      histroyImage: json['histroy_image'] is List ? List<String>.from(json['histroy_image'].map((x) => x)) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'history_data': historyData.toJson(),
      'word_count': wordCount,
      'image_count': imageCount,
      'template_id': templateId,
      'histroy_image': histroyImage.map((e) => e).toList(),
    };
  }
}

class HistoryData {
  dynamic requestBody;
  dynamic responseBody;

  HistoryData({
    this.requestBody,
    this.responseBody,
  });

  factory HistoryData.fromJson(Map<String, dynamic> json) {
    // log("HistoryData request_body ===> ${json['request_body']}");
    // log("HistoryData request_body ===> ${json['response_body']}");
    return HistoryData(
      requestBody: json['request_body'],
      responseBody: json['response_body'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'request_body': requestBody,
      'response_body': responseBody,
    };
  }
}
