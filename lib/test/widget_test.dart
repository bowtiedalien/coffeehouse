import 'package:flutter/material.dart';
import 'homepage.dart';
import 'profilePage.dart';
import 'ShoppingCart.dart';
import 'dart:async';

//MyApp -- Splash Screen
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
            Navigator.pushReplacement(
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
    double screenWidth = MediaQuery.of(context)
        .size
        .width; //save screen dimensions in a variable
    double screenHeight = MediaQuery.of(context)
        .size
        .height;
    return Scaffold(
      backgroundColor: Colors.brown[300],
      body: Column(
        children: <Widget>[
          Container(
              width: screenWidth - 50,
              margin: EdgeInsets.fromLTRB(59, 70, 0, 0),
              child: Text(
                "Welcome to Coffee House",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: Colors.white),
              )),
          Container(
            margin: EdgeInsets.only(top: screenHeight/7.2),
            child: Image.asset('coffee.png', fit: BoxFit.scaleDown,),
          ),
        ],
      ),
    );
  }
}

//Homepage - the bottom Nav Bar + it is where the redirection happens
//it redirects to one of the three pages; MyHomePage, ShoppingCart or ProfilePage

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedPage = 0;
  final _pageOptions = [
    MyHomePage(),
    ShoppingCart(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coffee House'),
      ),
      body: _pageOptions[_selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPage,
        onTap: (int index) {
          setState(() {
            _selectedPage = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            title: Text('home'),
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
              title: Text('shopping basket'),
              icon: Icon(Icons.shopping_basket)),
          BottomNavigationBarItem(
              title: Text('profile'), icon: Icon(Icons.person))
        ],
      ),
    );
  }
}