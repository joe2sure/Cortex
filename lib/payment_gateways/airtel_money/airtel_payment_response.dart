/// data : {"transaction":{"id":"1957556726783556754636369","status":"Success."}}
/// status : {"response_code":"DP00800001006","code":"200","success":true,"result_code":"ESB000010","message":"Success."}
library;

class AirtelPaymentResponse {
  AirtelPaymentResponse({
      Data? data, 
      AirtelResonseStatus? status,}){
    _data = data;
    _status = status;
}

  AirtelPaymentResponse.fromJson(dynamic json) {
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _status = json['status'] != null ? AirtelResonseStatus.fromJson(json['status']) : null;
  }
  Data? _data;
  AirtelResonseStatus? _status;
AirtelPaymentResponse copyWith({  Data? data,
  AirtelResonseStatus? status,
}) => AirtelPaymentResponse(  data: data ?? _data,
  status: status ?? _status,
);
  Data? get data => _data;
  AirtelResonseStatus? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    if (_status != null) {
      map['status'] = _status?.toJson();
    }
    return map;
  }

}

/// response_code : "DP00800001006"
/// code : "200"
/// success : true
/// result_code : "ESB000010"
/// message : "Success."

class AirtelResonseStatus {
  AirtelResonseStatus({
      String? responseCode, 
      String? code, 
      bool? success, 
      String? resultCode, 
      String? message,}){
    _responseCode = responseCode;
    _code = code;
    _success = success;
    _resultCode = resultCode;
    _message = message;
}

  AirtelResonseStatus.fromJson(dynamic json) {
    _responseCode = json['response_code'];
    _code = json['code'];
    _success = json['success'];
    _resultCode = json['result_code'];
    _message = json['message'];
  }
  String? _responseCode;
  String? _code;
  bool? _success;
  String? _resultCode;
  String? _message;
AirtelResonseStatus copyWith({  String? responseCode,
  String? code,
  bool? success,
  String? resultCode,
  String? message,
}) => AirtelResonseStatus(  responseCode: responseCode ?? _responseCode,
  code: code ?? _code,
  success: success ?? _success,
  resultCode: resultCode ?? _resultCode,
  message: message ?? _message,
);
  String? get responseCode => _responseCode;
  String? get code => _code;
  bool? get success => _success;
  String? get resultCode => _resultCode;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['response_code'] = _responseCode;
    map['code'] = _code;
    map['success'] = _success;
    map['result_code'] = _resultCode;
    map['message'] = _message;
    return map;
  }

}

/// transaction : {"id":"1957556726783556754636369","status":"Success."}

class Data {
  Data({
      Transaction? transaction,}){
    _transaction = transaction;
}

  Data.fromJson(dynamic json) {
    _transaction = json['transaction'] != null ? Transaction.fromJson(json['transaction']) : null;
  }
  Transaction? _transaction;
Data copyWith({  Transaction? transaction,
}) => Data(  transaction: transaction ?? _transaction,
);
  Transaction? get transaction => _transaction;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_transaction != null) {
      map['transaction'] = _transaction?.toJson();
    }
    return map;
  }

}

/// id : "1957556726783556754636369"
/// status : "Success."

class Transaction {
  Transaction({
      String? id, 
      String? status,}){
    _id = id;
    _status = status;
}

  Transaction.fromJson(dynamic json) {
    _id = json['id'];
    _status = json['status'];
  }
  String? _id;
  String? _status;
Transaction copyWith({  String? id,
  String? status,
}) => Transaction(  id: id ?? _id,
  status: status ?? _status,
);
  String? get id => _id;
  String? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['status'] = _status;
    return map;
  }

}