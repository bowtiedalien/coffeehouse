import 'package:flutter/material.dart';
import 'test/widget_test.dart';
import 'resources/models.dart';

//application start point
//this only calls MyApp which is responsible for the Splash Screen
void main() {
  runApp(MaterialApp(
    theme: ThemeData(primaryColor: bgColor),
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}
