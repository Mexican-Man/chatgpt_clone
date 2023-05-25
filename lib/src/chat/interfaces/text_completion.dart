class TextCompletionResponse {
  final String id;
  final String object;
  final int created;
  final String model;
  final List<Choice> choices;
  final Usage usage;

  TextCompletionResponse({
    required this.id,
    required this.object,
    required this.created,
    required this.model,
    required this.choices,
    required this.usage,
  });
}

class Choice {
  final String text;
  final int index;
  final dynamic logprobs;
  final String finishReason;

  Choice({
    required this.text,
    required this.index,
    this.logprobs,
    required this.finishReason,
  });
}

class Usage {
  final int promptTokens;
  final int completionTokens;
  final int totalTokens;

  Usage({
    required this.promptTokens,
    required this.completionTokens,
    required this.totalTokens,
  });
}

class TextCompletionParams {
  final String model;
  final String prompt;
  final int maxTokens;
  final int temperature;
  final int topP;
  final int n;
  final bool stream;
  final dynamic logprobs;
  final String stop;

  TextCompletionParams({
    required this.model,
    required this.prompt,
    required this.maxTokens,
    required this.temperature,
    required this.topP,
    required this.n,
    required this.stream,
    this.logprobs,
    required this.stop,
  });
}
