import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coffee House'),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: ListView(
          children: <Widget>[
            coffeeCategory('Cafe Latte', 'cafe_late.png'),
            coffeeCategory('Espresso', 'espresso.png'),
            coffeeCategory('Macchiato', 'macchiato.png'),
            coffeeCategory('Irish Coffee', 'irish_coffee.png'),
            coffeeCategory('Cappuccino', 'cappucino.png'),
            coffeeCategory('Long Black', 'long_black.png'),
            coffeeCategory('Vienna', 'vienna.png'),
            coffeeCategory('Affogato', 'affogato.png'),
            coffeeCategory('Flat White', 'flat_white.png'),
            coffeeCategory('Caffe Americano', 'caffe_americano.png'),
          ],
        ),
      )
    );
  }
}

//widget that displays coffee icon and its name
Widget coffeeCategory(String name, String image){
  return Container(
    height: 80,
    child: ListTile(
      leading: Image(
        width: 80,
        image: AssetImage(image),
      ),
      title: Text(name),
    ),
  );
}