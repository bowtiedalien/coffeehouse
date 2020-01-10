import 'package:flutter/material.dart';
import 'test/widget_test.dart';

//application start point
//this only calls MyApp which is responsible for the Splash Screen
void main() {
  runApp(MaterialApp(
    theme: ThemeData(primaryColor: Colors.brown[300]),
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}
