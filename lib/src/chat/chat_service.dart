import 'dart:convert';

import 'package:chatgpt_clone/src/chat/interfaces/chat_completion.dart';
import 'package:chatgpt_clone/src/chat/interfaces/chat_models.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

const domain = "https://api.openai.com";
const compatModels = [
  "gpt-4",
  "gpt-4-0314",
  "gpt-4-32k",
  "gpt-4-32k-0314",
  "gpt-3.5-turbo",
  "gpt-3.5-turbo-0301"
];

class OpenAI with ChangeNotifier {
  late List<ChatMessage> messages;
  late String _apiKey;
  late String _model;

  OpenAI({required String apiKey, required String model}) {
    _apiKey = apiKey;
    _model = model;
    messages = [];
  }

  send(ChatMessage message) async {
    messages.add(message);
    notifyListeners();

    ChatCompletionParams params = ChatCompletionParams(
      model: _model,
      messages: messages,
    );

    var client = http.Client();
    var url = Uri.parse("$domain/v1/chat/completions");

    final bodySerialized = params.toJson();
    bodySerialized.removeWhere((key, value) => value == null);
    final body = jsonEncode(bodySerialized);

    var response = await client.post(url, body: body, headers: {
      "Authorization": 'Bearer $_apiKey',
      "Content-Type": "application/json",
    });

    if (response.statusCode == 200) {
      final completionResponse =
          ChatCompletionResponse.fromJson(jsonDecode(response.body));
      messages.add(ChatMessage(
        role: "assistant",
        content: completionResponse.choices[0].message.content,
      ));
      notifyListeners();
      return;
    }

    throw Exception('Request failed with status: ${response.statusCode}.');
  }

  Future<List<String>> listModels() async {
    var client = http.Client();
    var url = Uri.parse("$domain/v1/models");

    var response = await client.get(url, headers: {
      "Authorization": 'Bearer $_apiKey',
      "Content-Type": "application/json",
    });

    if (response.statusCode == 200) {
      final listOfModels =
          ModelsCompletionResponse.fromJson(jsonDecode(response.body));
      return listOfModels.data
          .map((e) => e.id)
          .where((element) => compatModels.contains(element))
          .toList();
    }
    // TODO handle error properly

    throw Exception('Request failed with status: ${response.statusCode}.');
  }
}
