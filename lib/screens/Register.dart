//import 'dart:async';
//
//import 'package:chat_app_flutter/services/auth.dart';
//import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:rounded_loading_button/rounded_loading_button.dart';
//
//class RegisterScreen extends StatefulWidget {
//  @override
//  _LoginScreenState createState() => _LoginScreenState();
//}
//
//class _LoginScreenState extends State<RegisterScreen> {
//  //animated loading indicator
//  final RoundedLoadingButtonController _btnController =
//      new RoundedLoadingButtonController();
//
//  //Firebase auth
//  final _auth = FirebaseAuth.instance;
//
//  final _firestore = Firestore.instance;
//
//  //Firebase register service
//  AuthService _authService = AuthService();
//
//  //setup controller for the TextFormField
//  TextEditingController usernameController = new TextEditingController();
//
//  TextEditingController emailController = new TextEditingController();
//  TextEditingController passwordController = new TextEditingController();
//
//  //setting username/email /password  for the user
//  String username;
//  String email;
//  String password;
//
//  //validation form key
//  final _formKey = GlobalKey<FormState>();
//
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      resizeToAvoidBottomPadding: false,
//      appBar: AppBar(
//        backgroundColor: Color(0xff058af7),
//        title: Text('Sign Up'),
//        leading: Builder(
//          builder: (BuildContext context) {
//            return IconButton(
//              icon: Icon(Icons.arrow_back),
//              onPressed: () {
//                Navigator.pop(context);
//              },
//            );
//          },
//        ),
//      ),
//      body: SingleChildScrollView(
//        child: ConstrainedBox(
//          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
//
//          child: Padding(
//            padding: const EdgeInsets.fromLTRB(10, 30, 0, 0),
//            child: Column(
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: [
//                Text(
//                  '   Create a new account',
//                  style: TextStyle(
//                    color: Colors.grey[600],
//                    fontSize: 30,
//                    fontWeight: FontWeight.bold,
//                  ),
//                ),
//                SizedBox(
//                  height: 30,
//                ),
//                Form(
//                  key: _formKey,
//                  child: Column(
//                    children: [
//                      TextFormField(
//
//                        validator: (value) {
//                          if (value.isEmpty) {
//                            return 'Please enter a username';
//                          }
//                          if(value.length < 3){
//                            return 'Your username is less than 3 characters';
//
//                          }
//                          return null;
//                        },
//                        controller: usernameController,
//                        decoration: InputDecoration(
//                          enabledBorder: UnderlineInputBorder(
//                            borderSide: BorderSide(color: Color(0xff058af7)),
//                          ),
//                          focusedBorder: UnderlineInputBorder(
//                              borderSide: BorderSide(color: Color(0xff058af7))),
//                          icon: Icon(
//                            Icons.person,
//                            color: Color(0xff058af7),
//                          ),
//                          labelText: ('Username'),
//                          labelStyle: TextStyle(color: Colors.grey),
//                          hintText: ('Enter your username'),
//                        ),
//                      ),
//                      SizedBox(
//                        height: 15,
//                      ),
//                      TextFormField(
//                        validator: (value) {
//                          if (value.isEmpty || !value.contains('@')) {
//                            return 'Please enter a valid email';
//                          }
//
//                          return null;
//                        },
//                        keyboardType: TextInputType.emailAddress,
//                        controller: emailController,
//                        decoration: InputDecoration(
//                          enabledBorder: UnderlineInputBorder(
//                            borderSide: BorderSide(color: Color(0xff058af7)),
//                          ),
//                          focusedBorder: UnderlineInputBorder(
//                              borderSide: BorderSide(color: Color(0xff058af7))),
//                          icon: Icon(
//                            Icons.email,
//                            color: Color(0xff058af7),
//                          ),
//                          labelText: ('Email'),
//                          labelStyle: TextStyle(color: Colors.grey),
//                          hintText: ('Enter your Email'),
//                        ),
//                      ),
//                      SizedBox(
//                        height: 15,
//                      ),
//                      TextFormField(
//                        validator: (value) {
//                          if (value.isEmpty) {
//                            return 'please enter a password';
//                          }
//                          if (value.length < 8){
//                            return 'your password is less than 8 characters';
//                          }
//
//                          return null;
//                        },
//                        controller: passwordController,
//                        obscureText: true,
//                        decoration: InputDecoration(
//                            enabledBorder: UnderlineInputBorder(
//                              borderSide: BorderSide(color: Color(0xff058af7)),
//                            ),
//                            focusedBorder: UnderlineInputBorder(
//                                borderSide: BorderSide(color: Color(0xff058af7))),
//                            icon: Icon(
//                              Icons.lock,
//                              color: Color(0xff058af7),
//                            ),
//                            labelText: ('Password'),
//                            hintText: ('Enter your password'),
//                            helperText: ('password must be at least 8 characters'),
//                            helperStyle: TextStyle(fontSize: 13),
//                            labelStyle: TextStyle(color: Colors.grey)),
//                      ),
//                    ],
//                  ),
//                ),
//                SizedBox(
//                  height: 20,
//                ),
//                Padding(
//                  padding: const EdgeInsets.fromLTRB(0, 10, 20, 0),
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: [
//                      RoundedLoadingButton(
//                        controller: _btnController,
//                        elevation: 10,
//                        color: Color(0xff058af7),
//                        onPressed: () async {
//                          _formKey.currentState.validate();
//                          bool isValid =_formKey.currentState.validate();
//                          if(isValid){
//                            _btnController.success();
//                          }
//                          else{
//                            _btnController.error();
//                            Timer(Duration(seconds: 1), () {
//                              _btnController.reset();
//                            });
//
//                          }
//                          FocusScope.of(context).unfocus();
//
//                          username=usernameController.text.trim();
//                          email = emailController.text.trim();
//                          password = passwordController.text.trim();
//
//                          dynamic result =
//                              await _authService.registerUser(email, password);
//                          if (result == null) {
//                            _btnController.error();
//                            Timer(Duration(seconds: 1), () {
//                              _btnController.reset();
//                            });
//                            print('error occurred');
//                          } else {
//                            _btnController.success();
//
//                            _firestore.collection('users').document(result.uid).setData(
//                              {
//                                'userId' : result.uid,
//                                'username' : username,
//                                'email' : email,
//                                'password' : password
//                              }
//                            );
//
//
//                              Navigator.pushNamedAndRemoveUntil(
//                                  context, '/Chats', (_) => false);
//                            print('success');
//                          }
//                        },
//                        child: Text(
//                          'Sign up',
//                          style: TextStyle(
//                            color: Colors.white,
//                            fontSize: 20,
//                          ),
//                        ),
//                      ),
//                    ],
//                  ),
//                )
//              ],
//            ),
//          ),
//        ),
//      ),
//    );
//  }
//}
import 'dart:async';
import 'dart:io';

import 'package:chat_app_flutter/widgets/auth/auth_form.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = FirebaseAuth.instance;

  void _submitRegister(
    String email,
    String password,
    String username,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) async {
    AuthResult authResult;

    try {
      authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final ref = FirebaseStorage.instance
          .ref()
          .child('user_image')
          .child(authResult.user.uid + '.jpg');
      await ref.putFile(image).onComplete;

      final url = await ref.getDownloadURL();

      await Firestore.instance
          .collection('users')
          .document(authResult.user.uid)
          .setData({
        'userId': authResult.user.uid,
        'username': username,
        'email': email,
        'image_url': url
      });
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
        _submitRegister,
      ),
    );
  }
}
