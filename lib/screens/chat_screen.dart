import 'package:chat_app_flutter/widgets/auth/Logout.dart';
import 'package:flutter/cupertino.dart';
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
    String _friendUid = _userData['friend_id'];


    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(65),
          child: AppBar(
            centerTitle: false,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    alignment: Alignment.bottomLeft,
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Text(
                    '$_username',
                    style: TextStyle(fontFamily: 'futurist', fontSize: 30),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 8),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(_userImage),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(child: Messages(_friendUid)),
              NewMessage(_friendUid)
            ],
          ),
        ));
  }
}
