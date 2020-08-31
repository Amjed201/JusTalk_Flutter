import 'dart:async';
import 'package:chat_app_flutter/widgets/auth/user_image.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'dart:io';

class AuthForm extends StatefulWidget {
  static var isLogin = true;
  static final _formKey = GlobalKey<FormState>();
  static var _userEmail = '';
  static var _userName = '';
  static var _userPassword = '';

  //animated loading indicator
  static RoundedLoadingButtonController btnController =
      new RoundedLoadingButtonController();

  AuthForm(this.submitFn);

  final void Function(
    String email,
    String password,
    String userName,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  File _userPickedImage;

  void _pickedImage(File image) {
    _userPickedImage = image;
  }

  void _trySubmit() {
    final isValid = AuthForm._formKey.currentState.validate();
    FocusScope.of(context).unfocus();


    if (_userPickedImage == null && !AuthForm.isLogin) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Please pick an image.'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      AuthForm.btnController.error();
      Timer(Duration(milliseconds: 500), (){
        AuthForm.btnController.reset();

      });

      return;
    }

    if (isValid) {
      AuthForm._formKey.currentState.save();
      widget.submitFn(AuthForm._userEmail.trim(), AuthForm._userPassword.trim(),
          AuthForm._userName.trim(),_userPickedImage, AuthForm.isLogin, context);
    } else {
      AuthForm.btnController.error();
      Timer(Duration(seconds: 1), () {
        AuthForm.btnController.reset();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Color(0xff058af7),
        title: AuthForm.isLogin ? Text('Sign In') : Text('Sign up'),
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
                  AuthForm.isLogin
                      ? '   Sign in to your account'
                      : '   Create a new account',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Form(
                  key: AuthForm._formKey,
                  child: Column(
                    children: [
                      if (!AuthForm.isLogin) UserImage(_pickedImage),
                      if (!AuthForm.isLogin)
                        TextFormField(
                          key: ValueKey('username'),
                          validator: (value) {
                            if (value.isEmpty || value.length < 4) {
                              return 'Please enter at least 4 characters';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff058af7)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff058af7))),
                            icon: Icon(
                              Icons.person,
                              color: Color(0xff058af7),
                            ),
                            labelText: ('Username'),
                            labelStyle: TextStyle(color: Colors.grey),
                            hintText: ('Enter your username'),
                          ),
                          onSaved: (value) {
                            AuthForm._userName = value;
                          },
                        ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        key: ValueKey('email'),
                        validator: (value) {
                          if (value.isEmpty || !value.contains('@')) {
                            return 'Please enter a valid email';
                          }

                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
//                        controller: emailController,
                        onSaved: (value) {
                          AuthForm._userEmail = value;
                        },
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
                        key: ValueKey('password'),
                        onSaved: (value) {
                          AuthForm._userPassword = value;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'please enter a password';
                          }
                          if (value.length < 8) {
                            return 'your password is less than 8 characters';
                          }
                          return null;
                        },
//                        controller: passwordController,
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
                        controller: AuthForm.btnController,
                        elevation: 10,
                        color: Color(0xff058af7),
                        onPressed: _trySubmit,
                        child: Text(
                          AuthForm.isLogin ? 'Sign in' : 'Sign up',
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
