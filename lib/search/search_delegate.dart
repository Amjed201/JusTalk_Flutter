import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Search extends SearchDelegate {
  String myUid;

  Search({this.myUid});

  var users = [];
  var friends = [];
  var recentUsers = [];

  @override
  List<Widget> buildActions(BuildContext context) {
    generateUsers();

    return [
      IconButton(
          icon: Icon(
            Icons.clear,
            color: Color(0xff058af7),
          ),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Color(0xff058af7),
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    final suggestions = (query == null)
        ? users
        : users
            .where((element) => element['username'].startsWith(query))
            .toList();
    return ListView.separated(
        itemCount: suggestions.length,
        separatorBuilder: (BuildContext context, int index) => Divider(
              indent: 15,
              endIndent: 15,
              height: 1,
              thickness: 2,
              color: Color(0xff058af7),
            ),
        itemBuilder: (ctx, index) {
          bool exist = false;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(suggestions[index]['image_url']),
              ),
              title: Text(
                suggestions[index]['username'],
                style: TextStyle(fontSize: 30, color: Colors.black),
              ),
              subtitle: Text(
                suggestions[index]['email'],
                style: TextStyle(fontSize: 20),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.person_add,
                  color: Color(0xff058af7),
                ),
                onPressed: () async {
                  var friendsDataFromFirebase = await Firestore.instance
                      .collection('users/$myUid/friends')
                      .getDocuments();
                  friends = friendsDataFromFirebase.documents;

                  for (int i = 0; i < friends.length; i++) {
                    if (friends[i]['friend_id'] == users[index]['userId']) {
                      exist = true;
                    }

                    if (exist) {
                      print('exist');
                      Scaffold.of(ctx).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${users[index]['username']} is already your friend.',
                            style: TextStyle(fontSize: 20),
                          ),
                          backgroundColor: Color(0xff058af7),
                        ),
                      );
                      return null;
                    }
                  }

                  await Firestore.instance
                      .collection('users/$myUid/friends')
                      .add({'friend_id': users[index]['userId']});
                  await Firestore.instance
                      .collection('users/${users[index]['userId']}/friends')
                      .add({
                    'friend_id': myUid,
                  });
                },
              ),
            ),
          );
        });
  }

  generateUsers() async {
    var dataFromFirebase =
        await Firestore.instance.collection('users').getDocuments();
    users = dataFromFirebase.documents;
    var toRemove = [];

    users.forEach((user) {
      if (user['userId'] == myUid) toRemove.add(user);
    });
    users.removeWhere((user) => toRemove.contains(user));

    users = users
        .where((element) => element['username'].startsWith(query))
        .toList();
  }
}

