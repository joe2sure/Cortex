class VerifyTransactionResponse {
  TransactionData? transactionData;
  String? message;
  String? status;

  VerifyTransactionResponse({this.transactionData, this.message, this.status});

  factory VerifyTransactionResponse.fromJson(Map<String, dynamic> json) {
    return VerifyTransactionResponse(
      transactionData: json['data'] != null ? TransactionData.fromJson(json['data']) : null,
      message: json['message'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    if (transactionData != null) {
      data['data'] = transactionData!.toJson();
    }
    return data;
  }
}

class TransactionData {
  num? accountId;
  num? amount;
  num? amountSettled;
  num? appFee;
  String? authModel;
  Card? card;
  num? chargedAmount;
  String? createdAt;
  String? currency;
  Customer? customer;
  String? deviceFingerprint;
  String? flwRef;
  num? id;
  String? ip;
  num? merchantFee;
  Meta? meta;
  String? narration;
  String? paymentType;
  String? processorResponse;
  String? status;
  String? txRef;

  TransactionData({
    this.accountId,
    this.amount,
    this.amountSettled,
    this.appFee,
    this.authModel,
    this.card,
    this.chargedAmount,
    this.createdAt,
    this.currency,
    this.customer,
    this.deviceFingerprint,
    this.flwRef,
    this.id,
    this.ip,
    this.merchantFee,
    this.meta,
    this.narration,
    this.paymentType,
    this.processorResponse,
    this.status,
    this.txRef,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      accountId: json['account_id'],
      amount: json['amount'],
      amountSettled: json['amount_settled'],
      appFee: json['app_fee'],
      authModel: json['auth_model'],
      card: json['card'] != null ? Card.fromJson(json['card']) : null,
      chargedAmount: json['charged_amount'],
      createdAt: json['created_at'],
      currency: json['currency'],
      customer: json['customer'] != null ? Customer.fromJson(json['customer']) : null,
      deviceFingerprint: json['device_fingerprint'],
      flwRef: json['flw_ref'],
      id: json['id'],
      ip: json['ip'],
      merchantFee: json['merchant_fee'],
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
      narration: json['narration'],
      paymentType: json['payment_type'],
      processorResponse: json['processor_response'],
      status: json['status'],
      txRef: json['tx_ref'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['account_id'] = accountId;
    data['amount'] = amount;
    data['amount_settled'] = amountSettled;
    data['app_fee'] = appFee;
    data['auth_model'] = authModel;
    data['charged_amount'] = chargedAmount;
    data['created_at'] = createdAt;
    data['currency'] = currency;
    data['device_fingerprint'] = deviceFingerprint;
    data['flw_ref'] = flwRef;
    data['id'] = id;
    data['ip'] = ip;
    data['merchant_fee'] = merchantFee;
    data['narration'] = narration;
    data['payment_type'] = paymentType;
    data['processor_response'] = processorResponse;
    data['status'] = status;
    data['tx_ref'] = txRef;
    if (card != null) {
      data['card'] = card!.toJson();
    }
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    if (meta != null) {
      data['meta'] = meta!.toJson();
    }
    return data;
  }
}

class Customer {
  String? createdAt;
  String? email;
  int? id;
  String? name;
  String? phoneNumber;

  Customer({this.createdAt, this.email, this.id, this.name, this.phoneNumber});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      createdAt: json['created_at'],
      email: json['email'],
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phone_number'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['created_at'] = createdAt;
    data['email'] = email;
    data['id'] = id;
    data['name'] = name;
    data['phone_number'] = phoneNumber;
    return data;
  }
}

class Meta {
  String? checkoutInitAddress;

  Meta({this.checkoutInitAddress});

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      checkoutInitAddress: json['__CheckoutInitAddress'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['__CheckoutInitAddress'] = checkoutInitAddress;
    return data;
  }
}

class Card {
  String? country;
  String? expiry;
  String? first_6digits;
  String? issuer;
  String? last_4digits;
  String? token;
  String? type;

  Card({this.country, this.expiry, this.first_6digits, this.issuer, this.last_4digits, this.token, this.type});

  factory Card.fromJson(Map<String, dynamic> json) {
    return Card(
      country: json['country'],
      expiry: json['expiry'],
      first_6digits: json['first_6digits'],
      issuer: json['issuer'],
      last_4digits: json['last_4digits'],
      token: json['token'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['country'] = country;
    data['expiry'] = expiry;
    data['first_6digits'] = first_6digits;
    data['issuer'] = issuer;
    data['last_4digits'] = last_4digits;
    data['token'] = token;
    data['type'] = type;
    return data;
  }
}
