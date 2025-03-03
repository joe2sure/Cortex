class V1ImageGenerationResponse {
  int created;
  List<ResponseData> responseData;

  V1ImageGenerationResponse({
    this.created = -1,
    this.responseData = const <ResponseData>[],
  });

  factory V1ImageGenerationResponse.fromJson(Map<String, dynamic> json) {
    return V1ImageGenerationResponse(
      created: json['created'] is int ? json['created'] : -1,
      responseData: json['data'] is List
          ? List<ResponseData>.from(json['data'].map((x) => ResponseData.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'created': created,
      'data': responseData.map((e) => e.toJson()).toList(),
    };
  }
}

class ResponseData {
  String revisedPrompt;
  String url;

  ResponseData({
    this.revisedPrompt = "",
    this.url = "",
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
      revisedPrompt:
          json['revised_prompt'] is String ? json['revised_prompt'] : "",
      url: json['url'] is String ? json['url'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'revised_prompt': revisedPrompt,
      'url': url,
    };
  }
}
