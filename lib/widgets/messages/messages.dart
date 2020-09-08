import 'package:chat_app_flutter/screens/contacts.dart';
import 'package:chat_app_flutter/widgets/messages/messsage_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

FirebaseUser _user;

class Messages extends StatefulWidget {
  String _friendUid;

  Messages(this._friendUid);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  void getCurrentUser() async {
    _user = await FirebaseAuth.instance.currentUser();
  }

  @override
  void initState() {
    // TODO: implement initState
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
            stream: Firestore.instance
                .collection(
                    'chat/${_user.uid}' + '${widget._friendUid}/messages')
                .orderBy('time', descending: true)
                .snapshots(),
            builder: (ctx, streamSnapshot) {
              if (streamSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final chatDocs = streamSnapshot.data.documents;
              return ListView.builder(
                reverse: true,
                itemCount: chatDocs.length,
                itemBuilder: (ctx, index) => MessageBubble(
                  username: chatDocs[index]['username'],
                  text: chatDocs[index]['text'] == null
                      ? ''
                      : chatDocs[index]['text'],
                  imageUrl: chatDocs[index]['image_url'],
                  isMe: chatDocs[index]['userId'] == futureSnapshot.data.uid,
                  sharedImage: chatDocs[index]['sharedImage'],
                ),
              );
            });
      },
    );
  }
}
