class OpenAI {
  List<Message> _messages = [];

  OpenAI() {
    _messages = [];

    // Populate test data
    _messages.add(Message("Hello", "user", DateTime.now()));
    _messages.add(Message("Hi", "bot", DateTime.now()));
    _messages.add(Message("How are you?", "user", DateTime.now()));
    _messages.add(Message("I'm good, how are you?", "bot", DateTime.now()));
  }

  send(Message message) {
    _messages.add(message);

    // TODO send message to OpenAI
  }

  get messages => _messages;
}

class Message {
  String text;
  String user;
  DateTime time;

  Message(this.text, this.user, this.time);
}
