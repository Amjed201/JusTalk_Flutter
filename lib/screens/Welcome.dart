import 'dart:async';

import 'package:chat_app_flutter/widgets/auth/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _ChatWelcomeState createState() => _ChatWelcomeState();
}

class _ChatWelcomeState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff058af7),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              TypewriterAnimatedTextKit(
                pause: Duration(milliseconds: 0),
                totalRepeatCount: 1,
                speed: Duration(milliseconds: 600),
                text: ['JusTalk'],
                textStyle: TextStyle(
                    fontFamily: 'futurist',
                    color: Colors.white,
                    fontSize: 80,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold),
              ),
              FutureBuilder(
                  future: Future.delayed(Duration(milliseconds: 3000)),
                  builder: (_, s) {
                    if (s.connectionState == ConnectionState.done) {
                      return FadeAnimatedTextKit(
                        duration: Duration(milliseconds: 600),
                        repeatForever: true,
                        text: ['You ', 'You need ', 'You need to talk.'],
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      );
                      ;
                    }
                    return Text('');
                  }),
              SizedBox(
                height: 50,
              ),
              ButtonTheme(
                minWidth: 350,
                height: 50,
                child: RaisedButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      side: BorderSide(
                        color: Colors.white,
                      )),
                  onPressed: () {
                    setState(() {
                      AuthForm.isLogin = true;
                    });
                    Navigator.pushNamed(context, '/Login');
                  },
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0xff058af7),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ButtonTheme(
                minWidth: 350,
                height: 50,
                child: RaisedButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      side: BorderSide(color: Colors.white)),
                  onPressed: () {
                    setState(() {
                      AuthForm.isLogin = false;
                    });
                    Navigator.pushNamed(context, '/Register');
                  },
                  child: Text(
                    'Create Account',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff058af7),
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
