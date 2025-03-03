class CheckDailyLimitModel {
  bool status;
  int data;
  String message;

  CheckDailyLimitModel({
    this.status = false,
    this.data = -1,
    this.message = "",
  });

  factory CheckDailyLimitModel.fromJson(Map<String, dynamic> json) {
    return CheckDailyLimitModel(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is int ? json['data'] : -1,
      message: json['message'] is String ? json['message'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data,
      'message': message,
    };
  }
}