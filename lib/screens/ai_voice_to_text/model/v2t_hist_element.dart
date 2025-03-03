import 'package:get/get.dart';

class V2THistElement {
  RxString title;
  RxString content;

  V2THistElement({
   required this.title ,
   required this.content,
  });

  factory V2THistElement.fromJson(Map<String, dynamic> json) {
    return V2THistElement(
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
