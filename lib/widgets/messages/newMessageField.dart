import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  TextEditingController messageController = new TextEditingController();
  var _enteredMessage = '';

  void _sendMessage() async {
    final user=await FirebaseAuth.instance.currentUser();
    final userData=await Firestore.instance.collection('users').document(user.uid).get();
    Firestore.instance.collection('chat').add({
      'username' :userData['username'],
      'text': _enteredMessage,
      'time': Timestamp.now(),
      'userId' : user.uid,
       'image_url' : userData['image_url']});
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
