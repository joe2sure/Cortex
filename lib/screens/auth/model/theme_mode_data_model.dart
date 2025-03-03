
class ThemeModeData {
  int id;
  String mode;

  ThemeModeData({
    this.id = -1,
    this.mode = "",
  });

  factory ThemeModeData.fromJson(Map<String, dynamic> json) {
    return ThemeModeData(
      id: json['id'] is int ? json['id'] : -1,
      mode: json['mode'] is String ? json['mode'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mode': mode,
    };
  }
}
