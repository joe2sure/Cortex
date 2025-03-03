class ImageStyles {
  List<ImgStyleElement> imageStyles;

  ImageStyles({
    this.imageStyles = const <ImgStyleElement>[],
  });

  factory ImageStyles.fromJson(Map<String, dynamic> json) {
    return ImageStyles(
      imageStyles: json['image_styles'] is List ? List<ImgStyleElement>.from(json['image_styles'].map((x) => ImgStyleElement.fromJson(x))) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image_styles': imageStyles.map((e) => e.toJson()).toList(),
    };
  }
}

class ImgStyleElement {
  int id;
  String style;
  String image;

  ImgStyleElement({
    this.id = -1,
    this.style = "",
    this.image = "",
  });

  factory ImgStyleElement.fromJson(Map<String, dynamic> json) {
    return ImgStyleElement(
      id: json['id'] is String ? json['id'] : -1,
      style: json['style'] is String ? json['style'] : "",
      image: json['image'] is String ? json['image'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'style': style,
      'image': image,
    };
  }
}
