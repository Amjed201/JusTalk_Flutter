import 'package:chat_app_flutter/widgets/auth/Logout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'contacts.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('$userNameTitle'),
         actions: [Logout()],
        ),
        body: Container(
          child: Column(
            children: [Expanded(child: PrivateMessages()), NewPrivateMessage()],
          ),
        ));
  }
}

class NewPrivateMessage extends StatefulWidget {
  @override
  _NewPrivateMessageState createState() => _NewPrivateMessageState();
}

class _NewPrivateMessageState extends State<NewPrivateMessage> {
  TextEditingController messageController = new TextEditingController();
  var _enteredMessage = '';

  void _sendMessage() async {
    final user = await FirebaseAuth.instance.currentUser();
    final userData =
        await Firestore.instance.collection('users').document(user.uid).get();

    Firestore.instance
        .collection('chat/${user.uid}' + '$friendUid/messages')
        .add({
      'username': userData['username'],
      'text': _enteredMessage,
      'time': Timestamp.now(),
      'userId': user.uid,
      'image_url': userData['image_url']
    });

    Firestore.instance
        .collection('chat/$friendUid' + '${user.uid}/messages')
        .add({
      'username': userData['username'],
      'text': _enteredMessage,
      'time': Timestamp.now(),
      'userId': user.uid,
      'image_url': userData['image_url']
    });

    messageController.clear();
    _enteredMessage = '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 15),
              child: TextFormField(
                controller: messageController,
                textInputAction: TextInputAction.send,
                decoration: InputDecoration(
                    hintText: ('Send a message...'),
                    labelStyle: TextStyle(color: Colors.black)),
                onChanged: (value) {
                  setState(() {
                    _enteredMessage = value;
                    value = '';
                  });
                },
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            color: Color(0xff058af7),
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
          )
        ],
      ),
    );
  }
}
