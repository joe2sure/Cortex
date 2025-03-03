import 'package:get/get.dart';

class SubscriptionResponseModel {
  List<SubscriptionModel> subscriptionPlanList;

  SubscriptionResponseModel({this.subscriptionPlanList = const <SubscriptionModel>[]});

  factory SubscriptionResponseModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionResponseModel(
      subscriptionPlanList: json['data'] is List ? List<SubscriptionModel>.from(json['data'].map((x) => SubscriptionModel.fromJson(x))) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': subscriptionPlanList.map((e) => e.toJson()).toList(),
    };
  }
}

class SubscriptionModel {
  int id;
  String name;
  String type;
  int duration;
  num amount;
  String identifier;
  int trialPeriod;
  String planLimitation;
  String description;
  int status;
  List<PlanLimits> limits;
  RxBool isPlanSelected = false.obs;
  String appStoreIdentifier;
  String playStoreIdentifier;

  SubscriptionModel(
      {this.id = -1,
      this.name = "",
      this.type = "",
      this.duration = -1,
      this.amount = 0,
      this.identifier = "",
      this.trialPeriod = -1,
      this.planLimitation = "",
      this.description = "",
      this.status = -1,
      this.limits = const <PlanLimits>[],
      this.appStoreIdentifier = "",
      this.playStoreIdentifier = ""});

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'] is int ? json['id'] : -1,
      name: json['name'] is String ? json['name'] : "",
      type: json['type'] is String ? json['type'] : "",
      duration: json['duration'] is int ? json['duration'] : -1,
      amount: json['amount'] is num ? json['amount'] : 0,
      identifier: json['identifier'] is String ? json['identifier'] : "",
      trialPeriod: json['trial_period'] is int ? json['trial_period'] : -1,
      planLimitation: json['planlimitation'] is String ? json['planlimitation'] : "",
      description: json['description'] is String ? json['description'] : "",
      status: json['status'] is int ? json['status'] : -1,
      limits: json['limits'] is List ? List<PlanLimits>.from(json['limits'].map((x) => PlanLimits.fromJson(x))) : [],
      appStoreIdentifier: json['appstore_identifier'] is String ? json['appstore_identifier'] : "",
      playStoreIdentifier: json['playstore_identifier'] is String ? json['playstore_identifier'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'duration': duration,
      'amount': amount,
      'identifier': identifier,
      'trial_period': trialPeriod,
      'planlimitation': planLimitation,
      'description': description,
      'status': status,
      'limits': limits.map((e) => e.toJson()).toList(),
    };
  }
}

class PlanLimits {
  int id;
  int planlimitationId;
  String limitationTitle;
  String limitType;
  String type;
  int limit;
  int remaining;
  String key;
  int status;

  PlanLimits({
    this.id = -1,
    this.planlimitationId = -1,
    this.limitationTitle = "",
    this.limitType = "",
    this.type = "",
    this.limit = 0,
    this.remaining = 0,
    this.key = "",
    this.status = -1,
  });

  factory PlanLimits.fromJson(Map<String, dynamic> json) {
    return PlanLimits(
      id: json['id'] is int ? json['id'] : -1,
      planlimitationId: json['planlimitation_id'] is int ? json['planlimitation_id'] : -1,
      limitationTitle: json['limitation_title'] is String ? json['limitation_title'] : "",
      limitType: json['limit_type'] is String ? json['limit_type'] : "",
      type: json['type'] is String ? json['type'] : "",
      limit: json['limit'] is int ? json['limit'] : 0,
      remaining: json['remaining'] is int
          ? json['remaining'] >= 0
              ? json['remaining']
              : 0
          : 0,
      key: json['key'] is String ? json['key'] : "",
      status: json['status'] is int ? json['status'] : -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'planlimitation_id': planlimitationId,
      'limitation_title': limitationTitle,
      'limit_type': limitType,
      'type': type,
      'limit': limit,
      'remaining': remaining,
      'key': key,
      'status': status,
    };
  }
}
