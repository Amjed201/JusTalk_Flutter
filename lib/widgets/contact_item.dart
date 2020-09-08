import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

FirebaseUser _user;

class ContactItem extends StatefulWidget {
  String friendUid;

  ContactItem({this.friendUid});

  @override
  _ContactItemState createState() => _ContactItemState();
}

class _ContactItemState extends State<ContactItem> {
  void pushChatScreen(String username, String userImage) async {
    Navigator.pushNamed(context, '/Chat', arguments: {
      'username': username,
      'userImage': userImage,
      'friend_id': widget.friendUid
    });
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
    return FutureBuilder(
          future: Firestore.instance
              .collection('users')
              .document(widget.friendUid)
              .get(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              CircularProgressIndicator();
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListTile(
                onTap: () {
                  pushChatScreen(
                      snapshot.data['username'], snapshot.data['image_url']);
                },
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: snapshot.hasData
                      ? NetworkImage(snapshot.data['image_url'])
                      : null,
                ),
                title: snapshot.hasData
                    ? Text(
                        snapshot.data['username'],
                        style: TextStyle(fontSize: 30, color: Colors.black),
                      )
                    : null,
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xff058af7),
                ),
//              subtitle: Text(
//                snapshot.data['email'],
//                style: TextStyle(fontSize: 20),
//              ),
              ),
            );
          });
  }
}
