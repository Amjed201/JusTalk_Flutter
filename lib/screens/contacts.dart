import 'package:chat_app_flutter/search/search_delegate.dart';
import 'package:chat_app_flutter/widgets/auth/Logout.dart';
import 'package:chat_app_flutter/widgets/contact_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  String myId;

  @override
  void initState() {
    // TODO: implement initState

    getUserId();
    super.initState();
  }

  getUserId() async {
    var user = await FirebaseAuth.instance.currentUser();
    setState(() {
      myId = user.uid;
      print(myId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: StreamBuilder(
          stream:
              Firestore.instance.collection('users/$myId/friends').snapshots(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final _friendsDocs = snapshot.data.documents;
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        showSearch(
                            context: context, delegate: Search(myUid: myId));
                      },
                      alignment: Alignment.centerLeft,
                    ),
                    Spacer(
                      flex: 2,
                    ),
                    Text(
                      'Chats',
                      style: TextStyle(fontFamily: 'futurist', fontSize: 25),
                    ),
                    Spacer(
                      flex: 1,
                    ),
                    Logout()
                  ],
                ),
              ),
              body: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) => Divider(
                        indent: 15,
                        endIndent: 15,
                        height: 1,
                        thickness: 2,
                        color: Color(0xff058af7),
                      ),
                  itemCount: _friendsDocs.length,
                  itemBuilder: (ctx, index) {
                    return (ContactItem(
                        friendUid: _friendsDocs[index]['friend_id']));
                  }),
            );
          }),
    );
  }
}
