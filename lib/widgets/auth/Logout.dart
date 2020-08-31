import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Logout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      icon: Icon(
        Icons.more_vert,
        color: Theme.of(context).primaryIconTheme.color,
      ),
      items: [
        DropdownMenuItem(
          child: Container(
            child: Row(
              children: <Widget>[
                Icon(Icons.exit_to_app),
                SizedBox(width: 8),
                Text('Logout'),
              ],
            ),
          ),
          value: 'logout',
        ),
      ],
      onChanged: (itemIdentifier) async {
        if (itemIdentifier == 'logout') {
          await FirebaseAuth.instance.signOut();
          Navigator.pushReplacementNamed(context, '/Welcome');
        }
      },
    );
  }
}
