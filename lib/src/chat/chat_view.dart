import 'package:flutter/material.dart';
import 'chat_service.dart';

class ChatView extends StatelessWidget {
  final OpenAI _openAI = OpenAI();

  ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomAppBar(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 1000,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Start Typing Here',
                      ),
                    ),
                  ),
                  IconButton(onPressed: null, icon: Icon(Icons.send, size: 30))
                ],
              ),
            ),
          ),
        ),
        appBar: AppBar(
          title: const Text('Item Details'),
        ),
        body: Center(
          child: SizedBox(
            width: 1000,
            child: ListView.builder(
              itemCount: _openAI.messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_openAI.messages[index].text),
                  subtitle: Text(_openAI.messages[index].user),
                  shape: const Border(bottom: BorderSide(color: Colors.grey)),
                );
              },
            ),
          ),
        ));
  }
}
