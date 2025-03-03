class V1ChatCompletionResponse {
  String id;
  String object;
  int created;
  String model;
  List<Choices> choices;
  Usage usage;
  String systemFingerprint;

  V1ChatCompletionResponse({
    this.id = "",
    this.object = "",
    this.created = -1,
    this.model = "",
    this.choices = const <Choices>[],
    required this.usage,
    this.systemFingerprint = "",
  });

  factory V1ChatCompletionResponse.fromJson(Map<String, dynamic> json) {
    return V1ChatCompletionResponse(
      id: json['id'] is String ? json['id'] : "",
      object: json['object'] is String ? json['object'] : "",
      created: json['created'] is int ? json['created'] : -1,
      model: json['model'] is String ? json['model'] : "",
      choices: json['choices'] is List ? List<Choices>.from(json['choices'].map((x) => Choices.fromJson(x))) : [],
      usage: json['usage'] is Map ? Usage.fromJson(json['usage']) : Usage(),
      systemFingerprint: json['system_fingerprint'] is String ? json['system_fingerprint'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'object': object,
      'created': created,
      'model': model,
      'choices': choices.map((e) => e.toJson()).toList(),
      'usage': usage.toJson(),
      'system_fingerprint': systemFingerprint,
    };
  }
}

class Choices {
  int index;
  ResponseMessage message;
  dynamic logprobs;
  String finishReason;

  Choices({
    this.index = -1,
    required this.message,
    this.logprobs,
    this.finishReason = "",
  });

  factory Choices.fromJson(Map<String, dynamic> json) {
    return Choices(
      index: json['index'] is int ? json['index'] : -1,
      message: json['message'] is Map
          ? ResponseMessage.fromJson(json['message'])
          : json['delta'] is Map
              ? ResponseMessage.fromJson(json['delta'])
              : ResponseMessage(),
      logprobs: json['logprobs'],
      finishReason: json['finish_reason'] is String ? json['finish_reason'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'message': message.toJson(),
      'logprobs': logprobs,
      'finish_reason': finishReason,
    };
  }
}

class ResponseMessage {
  String role;
  String content;

  ResponseMessage({
    this.role = "",
    this.content = "",
  });

  factory ResponseMessage.fromJson(Map<String, dynamic> json) {
    return ResponseMessage(
      role: json['role'] is String ? json['role'] : "",
      content: json['content'] is String ? json['content'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'content': content,
    };
  }
}

class Usage {
  int promptTokens;
  int completionTokens;
  int totalTokens;

  Usage({
    this.promptTokens = -1,
    this.completionTokens = -1,
    this.totalTokens = -1,
  });

  factory Usage.fromJson(Map<String, dynamic> json) {
    return Usage(
      promptTokens: json['prompt_tokens'] is int ? json['prompt_tokens'] : -1,
      completionTokens: json['completion_tokens'] is int ? json['completion_tokens'] : -1,
      totalTokens: json['total_tokens'] is int ? json['total_tokens'] : -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prompt_tokens': promptTokens,
      'completion_tokens': completionTokens,
      'total_tokens': totalTokens,
    };
  }
}
