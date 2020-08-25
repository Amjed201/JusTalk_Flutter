import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app_flutter/services/auth.dart';
import 'package:flutter/services.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //firebase auth
  final _auth = FirebaseAuth.instance;

  final _firestore = Firestore.instance;

  //Firebase login service
  AuthService _authService = AuthService();

  //setup controller for the TextFormField
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  //setting email and password for the user
  String email;
  String password;

  //validator form key
  final _formKey = GlobalKey<FormState>();

  //animated loading indicator
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Color(0xff058af7),
        title: Text('Sign In'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 30, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '   Sign in to your account',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty || !value.contains('@')) {
                            return 'Please enter a valid email';
                          }

                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff058af7)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff058af7))),
                          icon: Icon(
                            Icons.email,
                            color: Color(0xff058af7),
                          ),
                          labelText: ('Email'),
                          labelStyle: TextStyle(color: Colors.grey),
                          hintText: ('Enter your Email'),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'please enter a password';
                          }
                          if (value.length < 8) {
                            return 'your password is less than 8 characters';
                          }
                          return null;
                        },
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff058af7)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff058af7))),
                            icon: Icon(
                              Icons.lock,
                              color: Color(0xff058af7),
                            ),
                            labelText: ('Password'),
                            hintText: ('Enter your password'),
                            helperText:
                                ('password must be at least 8 characters'),
                            helperStyle: TextStyle(fontSize: 13),
                            labelStyle: TextStyle(color: Colors.grey)),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RoundedLoadingButton(
                        controller: _btnController,
                        elevation: 10,
                        color: Color(0xff058af7),
                        onPressed: () async {
                          bool isValid =_formKey.currentState.validate();
                          if(isValid){
                            _btnController.success();
}
                          else{
                            _btnController.error();
                            Timer(Duration(seconds: 1), () {
                              _btnController.reset();
                            });

                          }
                          FocusScope.of(context).unfocus();

                          email = emailController.text.trim();
                          password = passwordController.text.trim();


                          dynamic result =
                              await _authService.signUser(email, password);
                          if (result == null) {
                            _btnController.error();
                            Timer(Duration(seconds: 1), () {
                              _btnController.reset();
                            });
                            print('error occurred');
                          } else {
                            _btnController.success();
                              Navigator.pushNamedAndRemoveUntil(
                                  context, '/Chats', (_) => false);
                            print('success');
                          }
                        },
                        child: Text(
                          'Sign in',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
