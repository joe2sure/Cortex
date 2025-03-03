import 'package:get/get.dart';

class ParametersModel {
  String title;
  List<OptionElement> options;

  Rx<OptionElement> selectedOption = OptionElement().obs;

  ParametersModel({
    this.title = "",
    this.options = const <OptionElement>[],
  });

  factory ParametersModel.fromJson(Map<String, dynamic> json) {
    return ParametersModel(
      title: json['title'] is String ? json['title'] : "",
      options: json['options'] is List ? List<OptionElement>.from(json['options'].map((x) => OptionElement.fromJson(x))) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'options': options.map((e) => e.toJson()).toList(),
      'selected': selectedOption.value.toJson(),
    };
  }
}

class OptionElement {
  int id;
  String text;
  String value;
  String image;

  OptionElement({
    this.id = -1,
    this.text = "",
    this.value = "",
    this.image = "",
  });

  factory OptionElement.fromJson(Map<String, dynamic> json) {
    return OptionElement(
      id: json['id'] is int ? json['id'] : -1,
      text: json['text'] is String ? json['text'] : "",
      value: json['value'] is String ? json['value'] : "",
      image: json['image'] is String ? json['image'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'value': value,
      'image': image,
    };
  }
}

class ImageTagsModel {
  List<ImageTag> imageTags;

  ImageTagsModel({
    this.imageTags = const <ImageTag>[],
  });

  factory ImageTagsModel.fromJson(Map<String, dynamic> json) {
    return ImageTagsModel(
      imageTags: json['image_tags'] is List ? List<ImageTag>.from(json['image_tags'].map((x) => ImageTag.fromJson(x))) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image_tags': imageTags.map((e) => e.toJson()).toList(),
    };
  }
}

class ImageTag {
  int id;
  String size;

  ImageTag({
    this.id = -1,
    this.size = "",
  });

  factory ImageTag.fromJson(Map<String, dynamic> json) {
    return ImageTag(
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
