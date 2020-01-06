import 'package:flutter/material.dart';
import 'Splash/splash.dart';

//application start point
void main() {
  runApp(
      MaterialApp(
        theme: ThemeData(primaryColor: Colors.brown[300]),
        debugShowCheckedModeBanner: false,
        home: MyApp(),
      )
  );
}

