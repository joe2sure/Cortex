class PicsArtRes {
  String status;
  ResponseData data;

  PicsArtRes({
    this.status = "",
    required this.data,
  });

  factory PicsArtRes.fromJson(Map<String, dynamic> json) {
    return PicsArtRes(
      status: json['status'] is String ? json['status'] : "",
      data: json['data'] is Map ? ResponseData.fromJson(json['data']) : ResponseData(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.toJson(),
    };
  }
}

class ResponseData {
  String id;
  String url;

  ResponseData({
    this.id = "",
    this.url = "",
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
      id: json['id'] is String ? json['id'] : "",
      url: json['url'] is String ? json['url'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
    };
  }
}
