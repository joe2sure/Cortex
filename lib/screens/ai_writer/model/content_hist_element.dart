import 'package:get/get.dart';

class ContentHistElement {
  RxString title;
  RxString content;

  ContentHistElement({
   required this.title ,
   required this.content,
  });

  factory ContentHistElement.fromJson(Map<String, dynamic> json) {
    return ContentHistElement(
      title: json['title'] is String ? (json['title'] as String).obs : "".obs,
      content: json['content'] is String ? (json['content'] as String).obs : "".obs,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title.value,
      'content': content.value,
    };
  }
}
