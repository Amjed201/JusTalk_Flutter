
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app_flutter/services/auth.dart';

//Firebase signOut service
AuthService _authService = AuthService();

FirebaseUser loggedInUser;

//Firebase auth
final _auth = FirebaseAuth.instance;

class Users extends StatefulWidget {
  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  //Cloud Firestore
  final _firestore = Firestore.instance;



  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.uid);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        backgroundColor: Color(0xff058af7),
        title: Text('Users'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('users/zo8Bq6XzAIXQoacoFnFO2ceNX1y1/contacts').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final users = snapshot.data.documents.reversed;

                List<Text> usersList=[];

                for (var user in users) {

//                  final email=user.data['email'];
                  final username=user.data['username'];
//                  final password=user.data['password'];

                  Text userInfo=Text('  $username ' );
                  usersList.add(userInfo);
//                  print('$email , $username');

                }

                return Expanded(
                  child: ListView(
                    reverse: true,
                    children: usersList,
                  ),
                );
              }),

        ],
      ),
    );
  }
}

