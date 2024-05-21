import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Message> messages = [];
  final TextEditingController _controller = TextEditingController();

  Future<String> getChatGPTResponse(String prompt) async {
    final apiKey = 'sk-proj-uzAGXqQyQ44zOj9ASLO4T3BlbkFJ111sUJsFHCJmC7ZHmCrg';
    const int maxRetries = 3;
    int retryCount = 0;
    String errorMessage = '';

    while (retryCount < maxRetries) {
      try {
        print('Attempt $retryCount: Sending request to OpenAI...');

        final response = await http.post(
          Uri.parse('https://api.openai.com/v1/chat/completions'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $apiKey',
          },
          body: jsonEncode({
            'model': 'gpt-3.5-turbo',
            'messages': [
              {'role': 'user', 'content': prompt}
            ]
          }),
        );

        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final reply = data['choices'][0]['message']['content'];
          return reply;
        } else {
          errorMessage = 'Failed to load response: ${response.statusCode}';
          print(errorMessage);
        }
      } catch (e) {
        errorMessage = 'Error occurred: $e';
        print(errorMessage);
      }

      retryCount++;
      await Future.delayed(Duration(seconds: 2)); // Пауза перед повторной попыткой
    }

    throw Exception(errorMessage);
  }

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      setState(() {
        messages.add(Message(_controller.text, true)); // Добавление сообщения пользователя
      });

      final userMessage = _controller.text;
      _controller.clear();

      // Получение ответа от ChatGPT
      try {
        final response = await getChatGPTResponse(userMessage);
        setState(() {
          messages.add(Message(response, false)); // Добавление ответа от ChatGPT
        });
      } catch (e) {
        print('Exception: $e');
        setState(() {
          messages.add(Message('Ошибка при получении ответа: $e', false));
        });
      }
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
                    child: Text(
                      messages[index].text,
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



