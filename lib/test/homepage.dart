import 'package:challenge_1/resources/models.dart';
import 'package:flutter/material.dart';
import 'package:challenge_1/resources/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


final db = Firestore.instance;

//MyHomePage is the main screen in the app - shows coffee options
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
                  title: Text(i <= (coffeeNames.length)
                      ? coffeeNames[i = i + 1]
                      : null),
                  leading: Container(
                    margin: EdgeInsets.only(top: 10),
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
                      trailing: Text(
                        '\$' + coffeePrices[i].toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
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
                                    border:
                                        Border.all(color: Colors.brown[200]),
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
                                    border:
                                        Border.all(color: Colors.brown[200]),
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
                                      value: flavourSelected,
                                      items: flavours,
                                      hint: Text('Add to flavours'),
                                      onChanged: (int value2) {
                                        setState(() {
                                          //calling this to update the state when an option is chosen
                                          flavourSelected = value2;
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
//                                  print(index); //debugging
//                                  for(int i=0;i<coffeeNames.length; i++)
//                                    {
//                                      print('shoppingBasket[i] => ${shoppingBasket[i]}');
//                                      if(shoppingBasket[i].isEmpty) {
//                                        print('flavourSelected is: ' +
//                                            flavourSelected.toString());
//                                        shoppingBasket[i].add(
//                                            coffeeNames[index]);
//                                        shoppingBasket[i].add(flavourSelected
//                                            .toString()); //here, each number has a flavour equivalent,
//                                        // we can keep it in a reference list or something.
//                                        shoppingBasket[i].add(selected);
//                                      }
//                                    }
//
//                                  for(int i=0; i<shoppingBasket.length;i++)
//                                    {
//                                      print(shoppingBasket[i]);
//                                    }
                                  //note: use firebase with this., orders should be a collection.
                                  //Inside Orders,
                                  //there is 'OrderId', 'Coffee Name', 'Flavours', 'Cup Size' as documents
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
    );
  }
}
