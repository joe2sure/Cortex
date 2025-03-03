import 'home_detail_res.dart';

class CustomTemplateRes {
  bool status;
  List<CustomTemplate> data;
  String message;

  CustomTemplateRes({
    this.status = false,
    required this.data,
    this.message = "",
  });

  factory CustomTemplateRes.fromJson(Map<String, dynamic> json) {
    return CustomTemplateRes(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is List ? List<CustomTemplate>.from(json['data'].map((x) => CustomTemplate.fromJson(x))) : [],
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
