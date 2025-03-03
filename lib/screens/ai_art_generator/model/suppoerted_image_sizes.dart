class SuppoertedImageSizes {
  List<ImageSize> imageSizes;

  SuppoertedImageSizes({
    this.imageSizes = const <ImageSize>[],
  });

  factory SuppoertedImageSizes.fromJson(Map<String, dynamic> json) {
    return SuppoertedImageSizes(
      imageSizes: json['supported_sizes'] is List
          ? List<ImageSize>.from(
              json['supported_sizes'].map((x) => ImageSize.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'supported_sizes': imageSizes.map((e) => e.toJson()).toList(),
    };
  }
}

class ImageSize {
  int id;
  String size;

  ImageSize({
    this.id = -1,
    this.size = "",
  });

  factory ImageSize.fromJson(Map<String, dynamic> json) {
    return ImageSize(
      id: json['id'] is String ? json['id'] : -1,
      size: json['size'] is String ? json['size'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'size': size,
    };
  }
}
