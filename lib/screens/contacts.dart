import 'package:chat_app_flutter/widgets/auth/Logout.dart';
import 'package:chat_app_flutter/widgets/messages/messsage_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

String friendUid = '';
FirebaseUser _user;
String userNameTitle;

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  void privateRoom() async {
    final userData =
        await Firestore.instance.collection('users').document(_user.uid).get();

    Navigator.pushNamed(context, '/PrivateChat');
  }

  void getCurrentUser() async {
    _user = await FirebaseAuth.instance.currentUser();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance.collection('users').snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }


          //////////////////////////////////////////////////////////////////
          final contactDocs = snapshot.data.documents;

          var toRemove = [];

          contactDocs.forEach((contact) {
            if (contact['userId'] == _user.uid) toRemove.add(contact);
          });
          contactDocs.removeWhere((contact) => toRemove.contains(contact));
          //////////////////////////////////////////////////////////////////


          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('TALKERS'
              ,style: TextStyle(fontFamily: 'futurist',
                fontSize:25),),
              actions: [Logout()],
            ),
            body: ListView.builder(
                itemCount: contactDocs.length,
                itemBuilder: (ctx, index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () {
                          userNameTitle = contactDocs[index]['username'];
                          friendUid = contactDocs[index]['userId'];
                          privateRoom();
                        },
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              NetworkImage(contactDocs[index]['image_url']),
                        ),
                        title: Text(
                          contactDocs[index]['username'],
                          style: TextStyle(fontSize: 30),
                        ),
                        subtitle: Text(
                          contactDocs[index]['email'],
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    )),
          );
        });
  }
}

class PrivateMessages extends StatefulWidget {
  @override
  _PrivateMessagesState createState() => _PrivateMessagesState();
}

class _PrivateMessagesState extends State<PrivateMessages> {
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
                .collection('chat/${_user.uid}' + '$friendUid/messages')
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
                  text: chatDocs[index]['text'],
                  imageUrl: chatDocs[index]['image_url'],
                  isMe: chatDocs[index]['userId'] == futureSnapshot.data.uid,
                ),
              );
            });
      },
    );
  }
}
