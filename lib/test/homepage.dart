import 'dart:convert';

import 'package:challenge_1/resources/models.dart';
import 'package:challenge_1/test/model_class.dart';
import 'package:challenge_1/test/shopping_cart.dart';
import 'package:flutter/material.dart';
import 'package:challenge_1/resources/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final db = Firestore.instance;

String cupSizeSelected;

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
            itemCount: productList.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.only(top: 0, bottom: 5),
                child: ExpansionTile(
                  title: Text(i <= (productList.length)
                      ? productList[i = i + 1].toMap()['name']
                      : null),
                  leading: Container(
                    margin: EdgeInsets.only(top: 10),
                    width: 80,
                    height: 120,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Image(
                        image: AssetImage(
                          i <= (productList.length) ? productList[i].picture : null,
                        ),
                      ),
                    ),
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text(productList[i].toMap()['name']),
                      trailing: Text(
                        '\$' + productList[i].price.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(i <= (productList.length) ? productList[i].description : null),
                        Text('ingredients: ' +
                            (i <= (productList.length) ? productList[i].ingredients : null)),
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
                                      value: cupSizeSelected,
                                      items: cupSizes,
                                      hint: Text('Cup Size'),
                                      onChanged: (String value1) {
                                        setState(() {
                                          cupSizeSelected = value1;
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
                                  if (cupSizeSelected == null) {
                                    print('no customisation was chosen');
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                              'You have to choose the size of your cup!',
                                            ),
                                          );
                                        });
                                  } else {
                                    //TODO: send data to the order list in Firestore
                                    orderName = productList[i].toMap()['name'];
                                    sendOrderList();
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          Future.delayed(Duration(seconds: 1),
                                              () {
                                            Navigator.of(context).pop(true);
                                          });
                                          return AlertDialog(
                                            title: Text(
                                              'Your order has been added to the cart successfuly!',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          );
                                        });
                                  }
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


List<Product> productList = [];

void getAvailableProducts() async{
  final QuerySnapshot result = await Firestore.instance.collection('product').getDocuments();
  List<DocumentSnapshot> documents = result.documents;
  if(documents.isNotEmpty){
    documents.forEach((data){
      print('document ID: ');
      print(data.documentID);
      print('data.data: ' + '${data.data}');

      productList.add(Product.fromJson(json.encode(data.data))); //here, we are creating dynamic objects. Just like in C++, you would use
      // object[0] = new Product(). In Dart 1, you would use 'new' keyword as well, but in Dart 2, it isn't required anymore.
      print('element of productlist: ');
    });
    for (Product product in productList){
      print('product info: ');
      print('Look under here: ');
//      print(productList[0].toMap()['name']);
      print(product.toMap()); //this prints all the values of the variables inside Product class, defined inside toMap()
    }

  }

}

