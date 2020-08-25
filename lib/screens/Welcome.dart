import 'package:flutter/material.dart';
import 'package:chat_app_flutter/services/auth.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _ChatWelcomeState createState() => _ChatWelcomeState();
}

class _ChatWelcomeState extends State<WelcomeScreen> {
  AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//        #0074c8
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
              Padding(
                padding: const EdgeInsets.fromLTRB(30,30,0,0),
                child: Text('made by Amjed :)'
                ,style: TextStyle(
                    color: Colors.white,
                    fontSize: 14
                  ),),
              )
            ],
          ),
        ),
      )),
    );
  }
}
