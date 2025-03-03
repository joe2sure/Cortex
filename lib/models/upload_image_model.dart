class UploadImageModel {
  bool status;
  List<String> uploadImage;
  String message;

  UploadImageModel({
    this.status = false,
    this.uploadImage = const <String>[],
    this.message = "",
  });

  factory UploadImageModel.fromJson(Map<String, dynamic> json) {
    return UploadImageModel(
      status: json['status'] is bool ? json['status'] : false,
      uploadImage: json['upload_image'] is List ? List<String>.from(json['upload_image'].map((x) => x)) : [],
      message: json['message'] is String ? json['message'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'upload_image': uploadImage.map((e) => e).toList(),
      'message': message,
    };
  }
}
