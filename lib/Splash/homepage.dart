import 'package:flutter/material.dart';
import 'package:challenge_1/test/ShoppingCart.dart';
import 'package:challenge_1/test/profilePage.dart';

//int _selectedPage;
//final _pageOptions = [
//  MyHomePage(),
//  ShoppingCart(),
//  ProfilePage(),
//];

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coffee House'),
      ),
      body: MyHomePage(),
//      _pageOptions[_selectedPage],
    );
  }
}

//declare all variables and functions here-------------------
List<DropdownMenuItem<String>> cupSizes =
    []; //array that stores available cup sizes
List<DropdownMenuItem<int>> flavours = [];
String selected;
int flavSelected;

const bgColor = const Color(0xFFAC5C0A);

void getCupSizes() {
  cupSizes = [];
  cupSizes.add(DropdownMenuItem(
    child: Text('Huge'),
    value: 'h',
  ));
  cupSizes.add(DropdownMenuItem(
    child: Text('normal'),
    value: 'n',
  ));
  cupSizes.add(DropdownMenuItem(
    child: Text('small'),
    value: 's',
  ));
}

void getFlavours() {
  flavours = []; //this is crucial - without it, application breaks.
  //error: There should be exactly one item with [DropdownButton]'s value: 2. Either zero or 2 or more [DropdownMenuItem]s were detected with the same value
  flavours.add(DropdownMenuItem(
    child: Text('chocolate'),
    value: 1,
  ));
  flavours.add(DropdownMenuItem(
    child: Text('vanilla'),
    value: 2,
  ));
}

List<String> coffeeNames = [
  'Affogato',
  'Cafe Late',
  'Caffe Americano',
  'Cappuccino',
  'Espresso',
  'Flat White',
  'Irish Coffee',
  'Long Black',
  'Macchiato',
  'Vienna'
];
List<String> coffeeImages = [
  'affogato.png',
  'cafe_late.png',
  'caffe_americano.png',
  'cappucino.png',
  'espresso.png',
  'flat_white.png',
  'irish_coffee.png',
  'long_black.png',
  'macchiato.png',
  'vienna.png'
];
List<int> coffeePrices = [10, 3, 5, 5, 5, 2, 10, 2, 5, 10];
List<String> coffeeDesc = [
  'coffee with ice cream',
  'coffee with milk and drawing on top',
  'dark coffee',
  'coffee with cream and drawing on top',
  'coffee with lots of cream and sugar',
  'coffee with little milk and drawing on top',
  'fancy coffee with nuts and milk',
  'black heavy coffee',
  'coffee with layers of stuff',
  'coffee with ice cream and nuts'
];
List<String> coffeeIng = [
  'coffee, ice cream',
  'coffee, milk',
  'coffee',
  'coffee, cream',
  'coffee, cream, sugar',
  'coffee, milk',
  'coffee, nuts, milk',
  'turkish coffee',
  'coffee, milk, caramel',
  'coffee, ice cream, nuts'
];

//-----------------------------------------
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    getCupSizes();
    getFlavours();
    int i = -1;
    return Scaffold(
      body: Container(
        margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
        child: ListView.builder(
            itemCount: coffeeNames.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.only(top: 0, bottom: 5),
                child: ExpansionTile(
                  title: Text(
                      i <= (coffeeNames.length) ? coffeeNames[i = i + 1] : null),
                  leading: Container(
                    margin: EdgeInsets.only(top:10),
                    width: 80,
                    height: 120,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Image(
                        image: AssetImage(
                            i <= (coffeeNames.length) ? coffeeImages[i] : null),
                      ),
                    ),
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text(coffeeNames[i]),
                      trailing: Text('\$' + coffeePrices[i].toString()),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(i <= (coffeeNames.length) ? coffeeDesc[i] : null),
                        Text('ingredients: ' +
                            (i <= (coffeeNames.length) ? coffeeIng[i] : null)),
                      ],
                    ),
                    ListTile(
                      title: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    border: Border.all(color: Colors.blueGrey),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(.5),
                                        blurRadius: 5.0, // soften the shadow
                                        offset: Offset(
                                          3.0, // Move to right 10  horizontally
                                          0.0, // Move to bottom 10 Vertically
                                        ),
                                      )
                                    ],
                                  ),
                                  padding: EdgeInsets.only(left: 7),
                                  margin: EdgeInsets.all(3),
                                  height: 35,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: selected,
                                      items: cupSizes,
                                      hint: Text('Cup Size'),
                                      onChanged: (String value1) {
                                        setState(() {
                                          selected = value1;
                                          //calling this to update the state when an option is chosen
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    border: Border.all(color: Colors.blueGrey),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(.5),
                                        blurRadius: 5.0, // soften the shadow
                                        offset: Offset(
                                          3.0, // Move to right 10  horizontally
                                          0.0, // Move to bottom 10 Vertically
                                        ),
                                      )
                                    ],
                                  ),
                                  padding: EdgeInsets.only(left: 7),
                                  margin: EdgeInsets.all(3),
                                  height: 35,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<int>(
                                      value: flavSelected,
                                      items: flavours,
                                      hint: Text('Add to flavours'),
                                      onChanged: (int value2) {
                                        setState(() {
                                          //calling this to update the state when an option is chosen
                                          flavSelected = value2;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            RaisedButton(
                                onPressed: () {
                                  //update ShoppingCart list with the item and its specifications
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                color: bgColor,
                                elevation: 3,
                                child: Text(
                                  'Add to shopping cart',
                                  style: TextStyle(color: Colors.white),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
      bottomNavigationBar: BottomNavigationBar(
//        currentIndex: _selectedPage,
//        onTap: (int index) {
//          print(index);
//          setState(() {
//            _selectedPage = index;
//          });
//        },
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
