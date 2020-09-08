import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:auto_direction/auto_direction.dart';
import 'package:image_picker/image_picker.dart';

class NewMessage extends StatefulWidget {
  String _friendUid;

  NewMessage(this._friendUid);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  File _pickedImage;

  TextEditingController messageController = new TextEditingController();
  var _enteredMessage = '';
  bool _isRTL = false;

  void _sendMessage() async {
    final user = await FirebaseAuth.instance.currentUser();
    final userData =
        await Firestore.instance.collection('users').document(user.uid).get();

    Firestore.instance
        .collection('chat/${user.uid}' + '${widget._friendUid}/messages')
        .add({
      'username': userData['username'],
      'text': _enteredMessage,
      'time': Timestamp.now(),
      'userId': user.uid,
      'image_url': userData['image_url'],
      'sharedImage' : null

    });

    Firestore.instance
        .collection('chat/${widget._friendUid}' + '${user.uid}/messages')
        .add({
      'username': userData['username'],
      'text': _enteredMessage,
      'time': Timestamp.now(),
      'userId': user.uid,
      'image_url': userData['image_url'],
      'sharedImage' : null


    });

    messageController.clear();
    _enteredMessage = '';
  }

  void _sendImage() async {
    final pickedImageFile = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 100, maxWidth: 300);
    setState(() {
      _pickedImage = File(pickedImageFile.path);
    });
    final user = await FirebaseAuth.instance.currentUser();

    final ref = FirebaseStorage.instance
        .ref()
        .child('shared_images')
        .child( user.uid+ '.jpg');
    await ref.putFile(_pickedImage).onComplete;

    final url = await ref.getDownloadURL();

    final userData =
    await Firestore.instance.collection('users').document(user.uid).get();


    Firestore.instance
        .collection('chat/${user.uid}' + '${widget._friendUid}/messages')
        .add({
      'username': userData['username'],
      'text': null,
      'time': Timestamp.now(),
      'userId': user.uid,
      'image_url': userData['image_url'],
      'sharedImage' : url

    });

    Firestore.instance
        .collection('chat/${widget._friendUid}' + '${user.uid}/messages')
        .add({
      'username': userData['username'],
      'text': null,
      'time': Timestamp.now(),
      'userId': user.uid,
      'image_url': userData['image_url'],
      'sharedImage' : url

    });


  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
              icon: Icon(
                Icons.image,
                color: Color(0xff058af7),
              ),
              onPressed: _sendImage),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 15),
              child: AutoDirection(
                text: _enteredMessage,
                onDirectionChange: (isRTL) {
                  setState(() {
                    this._isRTL = isRTL;
                  });
                },
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
