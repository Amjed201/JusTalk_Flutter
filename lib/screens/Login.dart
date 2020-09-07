import 'dart:async';
import 'dart:io';

import 'package:chat_app_flutter/widgets/auth/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;

  void _submitLogin(
    String email,
    String password,
    String username,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) async {
    AuthResult authResult;
    try {
      authResult = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );


      AuthForm.btnController.success();
      Timer(Duration(milliseconds: 500), () {
        Navigator.pushNamedAndRemoveUntil(context, '/Contacts', (_) => false);
      });
    } on PlatformException catch (err) {
      var message = 'An error occurred, please check your credentials!';
      AuthForm.btnController.error();
      Timer(Duration(milliseconds: 500), () {
        AuthForm.btnController.reset();
      });

      if (err.message != null) {
        message = err.message;
      }

      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
    } catch (err) {
      AuthForm.btnController.error();
      Timer(Duration(milliseconds: 500), () {
        AuthForm.btnController.reset();
      });
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        _submitLogin,
      ),
    );
  }
}
