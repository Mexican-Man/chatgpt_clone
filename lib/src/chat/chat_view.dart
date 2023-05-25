import 'package:chatgpt_clone/src/chat/interfaces/chat_completion.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../settings/settings_controller.dart';
import 'chat_service.dart';

class ChatView extends StatefulWidget {
  ChatView({
    super.key,
    required this.controller,
  });

  final SettingsController controller;

  @override
  // ignore: no_logic_in_create_state
  State<ChatView> createState() => _ChatViewState(controller: controller);
}

class _ChatViewState extends State<ChatView> {
  final SettingsController controller;
  final ScrollController scrollController = ScrollController();
  final TextEditingController textEditingController = TextEditingController();

  _ChatViewState({required this.controller});

  @override
  void initState() {
    super.initState();

    // If API key is not set, show dialog instructing user to set it
    Future.delayed(const Duration(seconds: 1), () {
      if (controller.openAIKey == '') {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('API Key Not Set'),
                  content: const Text(
                      'Please set your OpenAI API key in the settings page.'),
                  actions: [
                    TextButton(
                      onPressed: () => {
                        Navigator.pop(context),
                        Navigator.pushNamed(context, '/settings')
                      },
                      child: const Text('OK'),
                    )
                  ],
                ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OpenAI?>(
        create: (context) => controller.openAI,
        child: Builder(
            builder: (context) => Scaffold(
                  bottomNavigationBar: BottomAppBar(
                    child: Center(
                      child: Container(
                        constraints: const BoxConstraints(
                          maxWidth: 1000,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextField(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Start Typing Here',
                                  ),
                                  controller: textEditingController,
                                  onSubmitted: (value) => {
                                        Provider.of<OpenAI?>(context,
                                                listen: false)
                                            ?.send(ChatMessage(
                                                role: 'user',
                                                content: textEditingController
                                                    .text)),
                                        setState(() {
                                          textEditingController.clear();
                                        })
                                      }),
                            ),
                            IconButton(
                                onPressed: () {
                                  Provider.of<OpenAI?>(context, listen: false)
                                      ?.send(ChatMessage(
                                          role: 'user',
                                          content: textEditingController.text));
                                  setState(() {
                                    textEditingController.clear();
                                  });
                                },
                                icon: const Icon(Icons.send, size: 30))
                          ],
                        ),
                      ),
                    ),
                  ),
                  appBar: AppBar(
                    title: const Text('Chat Bot'),
                    actions: [
                      // Go to settings page
                      IconButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/settings'),
                          icon: const Icon(Icons.settings))
                    ],
                  ),
                  body: Center(
                    child: SizedBox(
                      width: 1000,
                      child: Consumer<OpenAI?>(
                        builder: (context, dataClass, child) => Scrollbar(
                          controller: scrollController,
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: dataClass?.messages.length,
                            itemBuilder: (context, index) => ListTile(
                              title: Text(
                                  dataClass?.messages[index].content ?? ''),
                              subtitle:
                                  Text(dataClass?.messages[index].role ?? ''),
                              shape: const Border(
                                  bottom: BorderSide(color: Colors.grey)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )));
  }
}
