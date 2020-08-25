import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  //no user error

  // sign in anonymously
  Future signAnonymously() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register user

  Future<dynamic> registerUser(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return user;
    } catch (e) {
      String error=e.message();
      print(error);
      if(error == 'PlatformException(ERROR_INVALID_EMAIL, The email address is badly formatted., null)')
        {print('Enter a valid email');}
      return null;
    }
  }

  //sign in with email and password

  Future signUser(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return user;
    } catch (e) {
      String error=e.message();
      print(error);
      if(error=='PlatformException(ERROR_USER_NOT_FOUND, There is no user record corresponding to this identifier. The user may have been deleted., null)')
        {print('No user found');}
      if(error =='PlatformException(ERROR_WRONG_PASSWORD, The password is invalid or the user does not have a password., null)')
        {print('Wrong password');}
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print (e.toString());
      return null;
    }
  }
//
// }

}
