import 'package:chat_app_flutter/widgets/auth/auth_form.dart';
import 'package:flutter/material.dart';

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
                  Text(
                    'JusTalk',
                    style: TextStyle(
                        fontFamily: 'futurist',
                        color: Colors.white,
                        fontSize: 60,
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'You need to talk.',
                    style: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
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
