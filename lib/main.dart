import 'package:chat_app_flutter/screens/Login.dart';
import 'package:chat_app_flutter/screens/Register.dart';
import 'package:chat_app_flutter/screens/Welcome.dart';
import 'package:chat_app_flutter/screens/contacts.dart';
import 'package:chat_app_flutter/screens/chat_screen.dart';
import 'package:chat_app_flutter/screens/splach_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterChat',
      routes: {
        '/Contacts': (context) => ContactsScreen(),
        '/Welcome': (context) => WelcomeScreen(),
        '/Login': (context) => LoginScreen(),
        '/Register': (context) => RegisterScreen(),
        '/PrivateChat': (context) => ChatScreen(),
      },
      home: StreamBuilder(
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (ctx, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return SplachScreen();
            }
            if (userSnapshot.hasData) {
              return ContactsScreen();
            }
            return WelcomeScreen();
          }),
    );
  }
}
