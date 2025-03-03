class TagsAndDesCustomResponse {
  String imageName;
  List<String> tags;
  String description;
  String reqImageUrl;

  TagsAndDesCustomResponse({
    this.imageName = "",
    this.tags = const <String>[],
    this.description = "",
    this.reqImageUrl = "",
  });

  factory TagsAndDesCustomResponse.fromJson(Map<String, dynamic> json) {
    return TagsAndDesCustomResponse(
      imageName: json['image_name'] is String ? json['image_name'] : "",
      reqImageUrl: json['req_image_url'] is String ? json['req_image_url'] : "",
      tags: json['tags'] is List
          ? List<String>.from(json['tags'].map((x) => x))
          : [],
      description: json['description'] is String ? json['description'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image_name': imageName,
      'req_image_url': reqImageUrl,
      'tags': tags.map((e) => e).toList(),
      'description': description,
    };
  }
}
