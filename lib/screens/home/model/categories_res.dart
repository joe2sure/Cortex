import 'home_detail_res.dart';

class CategoriesRes {
  bool status;
  List<CategoryElement> data;
  String message;

  CategoriesRes({
    this.status = false,
    required this.data,
    this.message = "",
  });

  factory CategoriesRes.fromJson(Map<String, dynamic> json) {
    return CategoriesRes(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is List ? List<CategoryElement>.from(json['data'].map((x) => CategoryElement.fromJson(x))) : [],
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
