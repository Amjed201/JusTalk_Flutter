import 'package:chat_app_flutter/screens/chat_screen.dart';
import 'package:chat_app_flutter/widgets/auth/Logout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

String friendUid = '';
FirebaseUser _user;

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  void pushChatScreen(String username, String userImage) async {
    final userData =
        await Firestore.instance.collection('users').document(_user.uid).get();


    Navigator.pushReplacementNamed(context,'/Chat',
        arguments: {'username': username, 'userImage': userImage});
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
              title: Text(
                'TALKERS',
                style: TextStyle(fontFamily: 'futurist', fontSize: 25),
              ),
              actions: [Logout()],
            ),
            body: ListView.builder(
                itemCount: contactDocs.length,
                itemBuilder: (ctx, index) {
                  String _userImage = contactDocs[index]['image_url'];
                  String _username = contactDocs[index]['username'];
                  friendUid = contactDocs[index]['userId'];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      onTap: () {
                        pushChatScreen(_username, _userImage);
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
                  );
                }),
          );
        });
  }
}
