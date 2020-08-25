import 'package:chat_app_flutter/screens/Chats.dart';
import 'package:chat_app_flutter/screens/Login.dart';
import 'package:chat_app_flutter/screens/Register.dart';
import 'package:chat_app_flutter/screens/Welcome.dart';
import 'package:chat_app_flutter/screens/users.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/Welcome',
    routes: {
      '/Welcome' : (context) => WelcomeScreen(),
      '/Login' : (context) => LoginScreen(),
      '/Register' : (context) => RegisterScreen(),
      '/Chats' : (context) => ChatsScreen(),
      '/Users' : (context) => Users(),


    },
  ));
}

