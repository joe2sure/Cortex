import 'package:flutter/material.dart';

/// Model class for walkthrough
class WalkThroughElementModel {
  String? title;
  String? subTitle;
  Color? color;
  Map<String, dynamic>? data;

  /// Can be image url or asset path
  String? image;

  WalkThroughElementModel({
    this.title,
    this.subTitle,
    this.image,
    this.color,
    this.data,
  });
}
