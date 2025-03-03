class SubscriptionPlanReq {
  String planId;
  String userId;
  String identifier;
  String paymentStatus;
  String paymentType;
  String transactionId;
  String appStoreIdentifier;
  String playStoreIdentifier;
  String gateway;
  String paymentBy;
  String gatewayMode;
  String activeInAppIdentifier;

  SubscriptionPlanReq({
    this.planId = "",
    this.userId = "",
    this.identifier = "",
    this.paymentStatus = "",
    this.paymentType = "",
    this.transactionId = "",
    this.appStoreIdentifier = "",
    this.playStoreIdentifier = "",
    this.gateway="",
    this.gatewayMode="",
    this.paymentBy="",
    this.activeInAppIdentifier="",
  });

  factory SubscriptionPlanReq.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanReq(
      planId: json['plan_id'] is String ? json['plan_id'] : "",
      userId: json['user_id'] is String ? json['user_id'] : "",
      identifier: json['identifier'] is String ? json['identifier'] : "",
      paymentStatus: json['payment_status'] is String ? json['payment_status'] : "",
      paymentType: json['payment_type'] is String ? json['payment_type'] : "",
      transactionId: json['transaction_id'] is String ? json['transaction_id'] : "",
      appStoreIdentifier: json['appstore_identifier'] is String ? json['appstore_identifier'] : "",
      playStoreIdentifier: json['playstore_identifier'] is String ? json['playstore_identifier'] : "",
      gateway: json['gateway'] is String ? json['gateway']:"",
      paymentBy: json['payment_by'] is String ? json['payment_by']:"",
      gatewayMode: json['gateway_mode'] is String ? json['gateway_mode']:"",
      activeInAppIdentifier: json['active_subscription_identifier'] is String ? json['active_subscription_identifier']:"",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plan_id': planId,
      'user_id': userId,
      'identifier': identifier,
      'payment_status': paymentStatus,
      'payment_type': paymentType,
      'transaction_id': transactionId,
      'appstore_identifier':appStoreIdentifier,
      'playstore_identifier':playStoreIdentifier,
      'gateway':gateway,
      'payment_by':paymentBy,
      'gateway_mode':gatewayMode,
      'active_subscription_identifier':activeInAppIdentifier,
    };
  }
}
