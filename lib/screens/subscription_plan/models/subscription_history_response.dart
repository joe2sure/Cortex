import 'subscription_plan_model.dart';

class SubscriptionHistoryResponse {
  bool status;
  List<SubscriptionHistoryData> data;
  String message;

  SubscriptionHistoryResponse({
    this.status = false,
    this.data = const <SubscriptionHistoryData>[],
    this.message = "",
  });

  factory SubscriptionHistoryResponse.fromJson(Map<String, dynamic> json) {
    return SubscriptionHistoryResponse(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is List ? List<SubscriptionHistoryData>.from(json['data'].map((x) => SubscriptionHistoryData.fromJson(x))) : [],
      message: json['message'] is String ? json['message'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((e) => e.toJson()).toList(),
      'message': message,
    };
  }
}

class SubscriptionHistoryData {
  int id;
  int planId;
  int userId;
  String startDate;
  String endDate;
  String status;
  num amount;
  String name;
  String identifier;
  String type;
  int duration;
  String planType;
  int paymentId;
  int createdBy;
  int updatedBy;
  int deletedBy;
  String deletedAt;
  String createdAt;
  String updatedAt;
  List<PlanLimits> limits;
  List<PlanLimits> remainingLimits;

  String activeRevenueCatIdentifier;

  SubscriptionHistoryData({
    this.id = -1,
    this.planId = -1,
    this.userId = -1,
    this.startDate = "",
    this.endDate = "",
    this.status = "",
    this.amount = 0,
    this.name = "",
    this.identifier = "",
    this.type = "",
    this.duration = 0,
    this.planType = "",
    this.paymentId = -1,
    this.createdBy = -1,
    this.updatedBy = -1,
    this.deletedBy = -1,
    this.deletedAt = "",
    this.createdAt = "",
    this.updatedAt = "",
    this.limits = const <PlanLimits>[],
    this.remainingLimits = const <PlanLimits>[],
    this.activeRevenueCatIdentifier = '',
  });

  factory SubscriptionHistoryData.fromJson(Map<String, dynamic> json) {
    return SubscriptionHistoryData(
      id: json['id'] is int ? json['id'] : -1,
      planId: json['plan_id'] is int ? json['plan_id'] : -1,
      userId: json['user_id'] is int ? json['user_id'] : -1,
      startDate: json['start_date'] is String ? json['start_date'] : "",
      endDate: json['end_date'] is String ? json['end_date'] : "",
      status: json['status'] is String ? json['status'] : "",
      amount: json['amount'] is num ? json['amount'] : 0,
      name: json['name'] is String ? json['name'] : "",
      identifier: json['identifier'] is String ? json['identifier'] : "",
      type: json['type'] is String ? json['type'] : "",
      duration: json['duration'] is int ? json['duration'] : 0,
      planType: json['plan_type'] is String ? json['plan_type'] : "",
      paymentId: json['payment_id'] is int ? json['payment_id'] : -1,
      createdBy: json['created_by'] is int ? json['created_by'] : -1,
      updatedBy: json['updated_by'] is int ? json['updated_by'] : -1,
      deletedBy: json['deleted_by'] is int ? json['updated_by'] : -1,
      deletedAt: json['deleted_at'] is String ? json['deleted_at'] : "",
      createdAt: json['created_at'] is String ? json['created_at'] : "",
      updatedAt: json['updated_at'] is String ? json['updated_at'] : "",
      limits: json['limits'] is List ? List<PlanLimits>.from(json['limits'].map((x) => PlanLimits.fromJson(x))) : [],
      remainingLimits: json['planlimits'] is List ? List<PlanLimits>.from(json['planlimits'].map((x) => PlanLimits.fromJson(x))) : [],
      activeRevenueCatIdentifier: json['active_subscription_identifier'] is String ? json['active_subscription_identifier'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plan_id': planId,
      'user_id': userId,
      'start_date': startDate,
      'end_date': endDate,
      'status': status,
      'amount': amount,
      'name': name,
      'identifier': identifier,
      'type': type,
      'duration': duration,
      'plan_type': planType,
      'payment_id': paymentId,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'deleted_by': deletedBy,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'limits': limits.map((e) => e.toJson()).toList(),
      'planlimits': remainingLimits.map((e) => e.toJson()).toList(),
      'active_subscription_identifier' : activeRevenueCatIdentifier,
    };
  }
}
