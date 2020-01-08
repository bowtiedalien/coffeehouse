import 'package:flutter/material.dart';
import 'package:challenge_1/Splash/homepage.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Hello from Profile Page'),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        onTap: (int index) {
          setState(() {
            HomePage();
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
