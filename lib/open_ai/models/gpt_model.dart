class GPTModel {
  int id;
  String slug;
  String title;
  String desc;
  String icon;
  String shortName;

  GPTModel({
    this.id = -1,
    this.slug = "",
    this.title = "",
    this.desc = "",
    this.icon = "",
    this.shortName = "",
  });

  factory GPTModel.fromJson(Map<String, dynamic> json) {
    return GPTModel(
      id: json['id'] is int ? json['id'] : -1,
      slug: json['slug'] is String ? json['slug'] : "",
      title: json['title'] is String ? json['title'] : "",
      desc: json['desc'] is String ? json['desc'] : "",
      icon: json['icon'] is String ? json['icon'] : "",
      shortName: json['short_name'] is String ? json['short_name'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'title': title,
      'desc': desc,
      'icon': icon,
      'short_name': shortName,
    };
  }
}
