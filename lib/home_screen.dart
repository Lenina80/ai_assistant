import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ChatPage(),
    );
  }
}

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Message> messages = [];
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        messages.add(Message(_controller.text, true)); // true для сообщений пользователя
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Telegram Style Chat"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Align(
                  alignment: message.isSender ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: message.isSender ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(messages[index].text,
                      style: TextStyle(
                        color: message.isSender ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Сообщение',
                      hintText: 'Введите ваше сообщение здесь...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Message {
  String text;
  bool isSender;

  Message(this.text, this.isSender);
}
