import 'package:chat_app_flutter/widgets/auth/Logout.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_flutter/widgets/messages/newMessageField.dart';
import 'package:chat_app_flutter/widgets/messages/messages.dart';
import 'contacts.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    Map _userData = ModalRoute.of(context).settings.arguments;
    String _username = _userData['username'];
    String _userImage = _userData['userImage'];

    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  alignment: Alignment.centerLeft,
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/Contacts');
                  }),
              SizedBox(
                width: 5,
              ),
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(_userImage),
              ),
              SizedBox(width: 10),
              Text(
                '$_username',
                style: TextStyle(fontFamily: 'futurist', fontSize: 25),
              ),
            ],
          ),
          actions: [Logout()],
        ),
        body: Container(
          child: Column(
            children: [Expanded(child: Messages()), NewMessage()],
          ),
        ));
  }
}
