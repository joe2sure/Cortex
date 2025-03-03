/// token_type : "bearer"
/// access_token : "BnA29vSqR0szmmGLC6k4AHDDobmtprY9"
/// expires_in : 180
library;

class AirtelAuthModel {
  AirtelAuthModel({
    String? tokenType,
    String? accessToken,
    num? expiresIn,
  }) {
    _tokenType = tokenType;
    _accessToken = accessToken;
    _expiresIn = expiresIn;
  }

  AirtelAuthModel.fromJson(dynamic json) {
    _tokenType = json['token_type'];
    _accessToken = json['access_token'];
    _expiresIn = json['expires_in'];
  }
  String? _tokenType;
  String? _accessToken;
  num? _expiresIn;
  Future<AirtelAuthModel> copyWith({
    String? tokenType,
    String? accessToken,
    num? expiresIn,
  }) async {
    return AirtelAuthModel(
      tokenType: tokenType ?? _tokenType,
      accessToken: accessToken ?? _accessToken,
      expiresIn: expiresIn ?? _expiresIn,
    );
  }

  String? get tokenType => _tokenType;
  String? get accessToken => _accessToken;
  num? get expiresIn => _expiresIn;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token_type'] = _tokenType;
    map['access_token'] = _accessToken;
    map['expires_in'] = _expiresIn;
    return map;
  }
}
