class GeneratedImagesModel {
  List<GeneratedImage> generatedImage;

  GeneratedImagesModel({
    this.generatedImage = const <GeneratedImage>[],
  });

  factory GeneratedImagesModel.fromJson(Map<String, dynamic> json) {
    return GeneratedImagesModel(
      generatedImage: json['generated_images'] is List ? List<GeneratedImage>.from(json['generated_images'].map((x) => GeneratedImage.fromJson(x))) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'supported_sizes': generatedImage.map((e) => e.toJson()).toList(),
    };
  }
}

class GeneratedImage {
  int id;
  int created;
  String revisedPrompt;
  List<String> urls;

  GeneratedImage({
    this.id = -1,
    this.created = -1,
    this.revisedPrompt = "",
    required this.urls,
  });

  factory GeneratedImage.fromJson(Map<String, dynamic> json) {
    return GeneratedImage(
      id: json['id'] is String ? json['id'] : -1,
      created: json['created'] is int ? json['created'] : -1,
      revisedPrompt: json['revised_prompt'] is String ? json['revised_prompt'] : "",
      urls: json['url'] is List ? List<String>.from(json['url'].map((x) => x)) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created': created,
      'revised_prompt': revisedPrompt,
      'url': urls.map((e) => e).toList(),
    };
  }
}
