
class ReportFlagElement {
  int id;
  String reason;

  ReportFlagElement({
    this.id = -1,
    this.reason = "",
  });

  factory ReportFlagElement.fromJson(Map<String, dynamic> json) {
    return ReportFlagElement(
      id: json['id'] is int ? json['id'] : -1,
      reason: json['reason'] is String ? json['reason'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': reason,
    };
  }
}
