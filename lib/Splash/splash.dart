import 'package:flutter/material.dart';
import 'homepage.dart';
import 'dart:async';

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //splash screen effect - wait for 3 seconds then redirect to HomePage
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: 3),
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double ScreenWidth = MediaQuery.of(context)
        .size
        .width; //save screen dimensions in a variable
    return Scaffold(
      backgroundColor: Colors.brown[300],
      body: Column(
        children: <Widget>[
          Container(
              width: ScreenWidth - 50,
              margin: EdgeInsets.fromLTRB(59, 70, 0, 0),
              child: Text(
                "Welcome to Coffee House",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: Colors.white),
              )),
          Container(
            margin: EdgeInsets.fromLTRB(0, 130, 0, 0),
            child: Image(
              image: AssetImage('coffee.png'),
            ),
          ),
        ],
      ),
    );
  }
}
