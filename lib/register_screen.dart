import 'package:flutter/material.dart';
import 'chat_page.dart'; // Импортируйте файл с экраном чата

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _email, _password;

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      print('Email: $_email, Password: $_password');

      // Переход на экран чата после успешной регистрации
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ChatPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Регистрация'),
      ),
      body: Center(
        child: Card(
          margin: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(labelText: 'Email'),
                      onSaved: (value) {
                        _email = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Введите корректный адрес электронной почты';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(labelText: 'Password'),
                      onSaved: (value) {
                        _password = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty || value.length < 8) {
                          return 'Длина пароля не может быть меньше 8 символов';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _trySubmit,
                      child: Text('Зарегистрироваться'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
