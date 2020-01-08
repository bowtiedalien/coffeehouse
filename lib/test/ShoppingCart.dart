import 'package:challenge_1/Splash/homepage.dart';
import 'package:flutter/material.dart';

class ShoppingCart extends StatefulWidget {
  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends  State<ShoppingCart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Hello from Shopping Cart'),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
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
