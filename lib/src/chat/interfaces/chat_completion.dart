class ChatCompletionResponse {
  final String id;
  final String object;
  final int created;
  final List<Choice> choices;
  final Usage usage;

  ChatCompletionResponse({
    required this.id,
    required this.object,
    required this.created,
    required this.choices,
    required this.usage,
  });

  ChatCompletionResponse.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        object = json['object'],
        created = json['created'],
        choices =
            (json['choices'] as List).map((e) => Choice.fromJson(e)).toList(),
        usage = Usage.fromJson(json['usage']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'object': object,
        'created': created,
        'choices': choices.map((e) => e.toJson()).toList(),
        'usage': usage.toJson(),
      };
}

class Choice {
  final int index;
  final ChatMessage message;
  final String finishReason;

  Choice({
    required this.index,
    required this.message,
    required this.finishReason,
  });

  Choice.fromJson(Map<String, dynamic> json)
      : index = json['index'],
        message = ChatMessage.fromJson(json['message']),
        finishReason = json['finish_reason'];

  Map<String, dynamic> toJson() => {
        'index': index,
        'message': message.toJson(),
        'finish_reason': finishReason,
      };
}

class ChatMessage {
  final String role;
  final String content;
  final String? name;

  ChatMessage({
    required this.role,
    required this.content,
    this.name,
  });

  ChatMessage.fromJson(Map<String, dynamic> json)
      : role = json['role'],
        content = json['content'],
        name = json['name'];

  Map<String, dynamic> toJson() => name == null
      ? {
          'role': role,
          'content': content,
        }
      : {
          'role': role,
          'content': content,
          'name': name,
        };
}

class Usage {
  final int? promptTokens;
  final int? completionTokens;
  final int? totalTokens;

  Usage({
    required this.promptTokens,
    required this.completionTokens,
    required this.totalTokens,
  });

  Usage.fromJson(Map<String, dynamic> json)
      : promptTokens = json['prompt_tokens'],
        completionTokens = json['completion_tokens'],
        totalTokens = json['total_tokens'];

  Map<String, dynamic> toJson() => {
        'prompt_tokens': promptTokens,
        'completion_tokens': completionTokens,
        'total_tokens': totalTokens,
      };
}

class ChatCompletionParams {
  final String model;
  final List<ChatMessage> messages;

  ChatCompletionParams({
    required this.model,
    required this.messages,
  });

  Map<String, dynamic> toJson() => {
        'model': model,
        'messages': messages.map((e) => e.toJson()).toList(),
      };
}
