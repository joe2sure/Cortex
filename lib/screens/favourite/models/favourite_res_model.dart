import 'package:get/get.dart';
import '../../home/model/home_detail_res.dart';

class FavResponse {
  bool status;
  List<FavData> data;
  String message;

  FavResponse({
    this.status = false,
    this.data = const <FavData>[],
    this.message = "",
  });

  factory FavResponse.fromJson(Map<String, dynamic> json) {
    return FavResponse(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is List ? List<FavData>.from(json['data'].map((x) => FavData.fromJson(x))) : [],
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

class FavData {
  int id;
  int userId;
  CustomTemplate templateData;
  String createdAt;
  String updatedAt;
  String deletedAt;

  FavData({
    this.id = -1,
    this.userId = -1,
    required this.templateData,
    this.createdAt = "",
    this.updatedAt = "",
    this.deletedAt = "",
  });

  factory FavData.fromJson(Map<String, dynamic> json) {
    return FavData(
      id: json['id'] is int ? json['id'] : -1,
      userId: json['user_id'] is int ? json['user_id'] : -1,
      templateData: json['template_data'] is Map ? CustomTemplate.fromJson(json['template_data']) : CustomTemplate(inWishList: false.obs),
      createdAt: json['created_at'] is String ? json['created_at'] : "",
      updatedAt: json['updated_at'] is String ? json['updated_at'] : "",
      deletedAt: json['deleted_at'] is String ? json['deleted_at'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'template_data': templateData.toJson(),
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
