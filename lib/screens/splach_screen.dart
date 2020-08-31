import 'package:flutter/material.dart';

class SplachScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff058af7),
      body: Center(
        child: Text(
          'JusTalk',
          style: TextStyle(
              fontFamily: 'futurist',
              color: Colors.white,
              fontSize: 100,
              letterSpacing: 2,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
