import 'package:challenge_1/main.dart';
import 'package:challenge_1/resources/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'homepage.dart';
import 'profile_page.dart';
import 'shopping_cart.dart';
import 'dart:async';

FontWeight homeScreenTitleFontWeight;
Color homeScreenTitleColor;

//MyApp -- Splash Screen
class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget changeState() {
    changestate();
    return Container();
  }

  void changestate() {
    setState(() {
      homeScreenTitleFontWeight = FontWeight.bold;
      homeScreenTitleColor = Colors.white;
    });
  }

  //splash screen effect - wait for 3 seconds then redirect to HomePage
  @override
  void initState() {
    homeScreenTitleFontWeight = FontWeight.w100;
    homeScreenTitleColor = Colors.grey;

    super.initState();
    Future.delayed(
      Duration(seconds: 5),
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
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: <Widget>[
          Container(
            width: screenWidth - 50,
            margin: EdgeInsets.fromLTRB(59, 70, 0, 0),
            child: AnimatedDefaultTextStyle(
              style: TextStyle(
                fontSize: 40,
                fontWeight: homeScreenTitleFontWeight,
                color: homeScreenTitleColor,
              ),
              duration: const Duration(milliseconds: 500),
              child: Text(
                "Welcome to" + "\nCoffee House",
//                style: TextStyle(
//                    fontWeight: FontWeight.w100,
//                    fontSize: 20,
//                    color: Colors.white),
              ),
            ),
          ),
          changeState(),
          Container(
            margin: EdgeInsets.only(top: screenHeight / 7.2),
            child: Image.asset(
              'coffee.png',
              fit: BoxFit.scaleDown,
            ),
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
    return ChangeNotifierProvider(
      create: (context) => MyModel(),
      child: Scaffold(
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
              icon: Icon(Icons.shopping_basket),
            ),
            BottomNavigationBarItem(
              title: Text('profile'),
              icon: Icon(Icons.person),
            )
          ],
        ),
      ),
    );
  }
}
