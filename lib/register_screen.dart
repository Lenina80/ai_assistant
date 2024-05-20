import 'package:ai_assistant/auth.dart';
import 'package:flutter/material.dart';
import 'chat_page.dart'; // Импортируйте файл с экраном чата

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _email, _password;

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
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        _formKey.currentState!.save();
                        final credential = await signUpWithEmailAndPassword("$_email", "$_password");
                        if (credential != null) {
                          // User signed up successfully
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => ChatPage()),
                          );
                        } else {
                          // Handle sign up error
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Error auth with email'),
                          )
                          );
                        }
                      },
                      child: Text('Sing Up'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        _formKey.currentState!.save();
                        final credential = await signInWithEmailAndPassword("$_email", "$_password");
                        if (credential != null) {
                          // User signed in successfully
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => ChatPage()),
                          );
                        } else {
                          // Handle sign in error
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Error login with email'),
                          )
                          );
                        }
                      },
                      child: Text('Sign In'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final credential = await signInWithGoogle();
                        if (credential != null) {
                          print('Success login with Goggle');// User signed in with Google
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Success login with Goggle'),
                          )
                          );
                          // Переход на экран чата после успешной регистрации
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => ChatPage()),
                          );
                        } else {
                          print('Error login with Goggle');// Handle sign in error or inform user Google sign-in not supported
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Error login with Goggle'),
                          )
                          );
                        }
                      },
                      child: Text("Sign In with Google"),
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
