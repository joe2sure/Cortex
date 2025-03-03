class ImageGenReq {
  String model;
  String prompt;
  int n;
  String size;

  ImageGenReq({
    this.model = "dall-e-3",
    required this.prompt,
    this.n = 1,
    this.size = "1024x1024",
  });

  factory ImageGenReq.fromJson(Map<String, dynamic> json) {
    return ImageGenReq(
      model: json['model'] is String ? json['model'] : "dall-e-3",
      prompt: json['prompt'] is String ? json['prompt'] : "",
      n: json['n'] is int ? json['n'] : 1,
      size: json['size'] is String ? json['size'] : "1024x1024",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'model': model,
      'prompt': prompt,
      'n': n,
      'size': size,
    };
  }
}
