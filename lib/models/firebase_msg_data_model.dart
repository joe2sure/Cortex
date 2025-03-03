class FirebaseMsgData {
  FirebaseMsgData({
    required this.title,
    required this.discription,
    required this.date,
  });

  String title;
  String discription;
  String date;

  factory FirebaseMsgData.fromJson(Map<String, dynamic> json) => FirebaseMsgData(
        title: json["title"] ?? '',
        discription: json["discription"] ?? '',
        date: json["date"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "discription": discription,
        "date": date,
      };
}
