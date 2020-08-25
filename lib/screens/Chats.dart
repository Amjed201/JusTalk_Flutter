import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app_flutter/services/auth.dart';

//Firebase signOut service
AuthService _authService = AuthService();

FirebaseUser loggedInUser;

//Firebase auth
final _auth = FirebaseAuth.instance;

class ChatsScreen extends StatefulWidget {
  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  //Cloud Firestore
  final _firestore = Firestore.instance;

  TextEditingController chatController = TextEditingController();

  String messageText;

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

  void getMessages() async {
    final messages = await _firestore.collection('messages').getDocuments();
    for (var message in messages.documents) {
      print(message.data);
    }
  }

  void messagesStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.documents) {
        print(message.data);
      }
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
        actions: [
          FlatButton.icon(
              icon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              label: Text(
                'Sign out',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                showAlertDialog(context);
              })
        ],
        backgroundColor: Color(0xff058af7),
        title: Text('Chats'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('messages').orderBy('time', descending: false).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final messages = snapshot.data.documents.reversed;

                List<MessageBubble> messageBubbles = [];
                for (var message in messages) {
                  final messageText = message.data['text'];
                  final messageSender = message.data['sender'];
                  final messageTime = message.data['time'] as Timestamp;



                  final currentUser = loggedInUser;


                  final messageWidget = MessageBubble(
                    text: messageText,
                    sender: messageSender,
                    isMe: currentUser.email == messageSender,
                    time: messageTime,
                  );
                  messageBubbles.add(messageWidget);
                }

                return Expanded(
                  child: ListView(
                    reverse: true,
                    children: messageBubbles,
                  ),
                );
              }),
          Divider(
            indent: 8,
            endIndent: 8,
            height: 1,
            thickness: 2,
            color: Color(0xff058af7),
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: TextFormField(
                      controller: chatController,
                      textInputAction: TextInputAction.send,
                      decoration: InputDecoration(
                          hintText: ('Type your message here'),
                          labelStyle: TextStyle(color: Colors.black)),
                    ),
                  ),
                ),
                FlatButton(
                  child: Text(
                    'Send',
                    style: TextStyle(color: Color(0xff058af7), fontSize: 18),
                  ),
                  onPressed: () {
                    messageText = chatController.text;
                    chatController.clear();
                    _firestore.collection('messages').add(
                        {'sender': loggedInUser.email, 'text': messageText,'time': FieldValue.serverTimestamp()});
                    print(messageText);
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String text;
  final String sender;
  final bool isMe;
  final Timestamp time;

  MessageBubble({this.text, this.sender, this.isMe,this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            '$sender',
            style: TextStyle(color: Colors.black54),
          ),
          SizedBox(
            height: 1,
          ),
          Material(
              elevation: 5,
              borderRadius: isMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))
                  : BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
              color: isMe ? Color(0xff058af7) : Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Text(
                  '$text',
                  style: TextStyle(
                      color: isMe ? Colors.white : Colors.black54,
                      fontSize: 18),
                ),
              )),
        ],
      ),
    );
  }
}

showAlertDialog(BuildContext context) {
  // set up the buttons
  Widget NoButton = FlatButton(
    child: Text(
      "No",
      style: TextStyle(fontSize: 20, color: Colors.red),
    ),
    onPressed: () {
      Navigator.of(context).pop();

    },
  );
  Widget YesButton = FlatButton(
    child: Text(
      "Yes",
      style: TextStyle(fontSize: 20, color: Colors.red),
    ),
    onPressed: () async {
      await _authService.signOut();
      final user = await _auth.currentUser();
      if (user == null) {
        Navigator.pushReplacementNamed(context, '/Welcome');
      }
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.warning,
          color: Colors.red,
          size: 40,
        ),
        SizedBox(
          width: 8,
        ),
        Text(
          "Sign out",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ],
    ),
    content: Text(
      "Are you sure you want to sign out?",
      style: TextStyle(color: Colors.grey[700], fontSize: 18),
    ),
    actions: [
      NoButton,
      YesButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
