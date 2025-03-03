import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecentChatRes {
  bool status;
  List<RecentChatElement> recentChats;
  String message;

  RecentChatRes({
    this.status = false,
    this.recentChats = const <RecentChatElement>[],
    this.message = "",
  });

  factory RecentChatRes.fromJson(Map<String, dynamic> json) {
    return RecentChatRes(
      status: json['status'] is bool ? json['status'] : false,
      recentChats: json['data'] is List ? List<RecentChatElement>.from(json['data'].map((x) => RecentChatElement.fromJson(x))) : [],
      message: json['message'] is String ? json['message'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': recentChats.map((e) => e.toJson()).toList(),
      'message': message,
    };
  }
}

class RecentChatElement {
  int id;
  int userId;
  String title;
  String createdAt;

  TextEditingController editCont = TextEditingController();
  FocusNode editFocus = FocusNode();
  RxBool isTyping = false.obs;
  RxBool showEditbar = false.obs;

  RecentChatElement({
    this.id = -1,
    this.userId = -1,
    this.title = "",
    this.createdAt = "",
  });

  factory RecentChatElement.fromJson(Map<String, dynamic> json) {
    return RecentChatElement(
      id: json['id'] is int ? json['id'] : -1,
      userId: json['user_id'] is int ? json['user_id'] : -1,
      title: json['title'] is String ? json['title'] : "",
      createdAt: json['created_at'] is String ? json['created_at'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'created_at': createdAt,
    };
  }
}
