import 'dart:convert';
import 'package:challenge_1/resources/models.dart';
import 'package:challenge_1/test/model_class.dart';
import 'package:challenge_1/test/shopping_cart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:challenge_1/resources/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

final db = Firestore.instance;

//var orderFlavours = [];
//var orderFlavours = <Map<String,int>>[];
Map<String, int> orderFlavours = {};
var orderCupSizes = [];
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
    //for debugging - checking if productList's length changes - should always be 10
//    print('productList.length before list: ');
//    print(productList.length);
    return Scaffold(
      body: Container(
        margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
        child: ListView.builder(
            itemCount: productList.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.only(top: 0, bottom: 5),
                child: ExpansionTile(
                  title: Text(productList[index].name),
                  leading: Container(
                    margin: EdgeInsets.only(top: 10),
                    width: 80,
                    height: 120,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Image(
                        image: AssetImage(
                         productList[index].picture
                        ),
                      ),
                    ),
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text(productList[index].name),
                      trailing: Text(
                        '\$ ${productList[index].price}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(productList[index].description),
                        Text(productList[index].ingredients),
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
                                      value: orderFlavours['${productList[index].name}'], //get the flavour attached to the name of this coffee order
                                      items: flavours,
                                      hint: Text('Add to flavours'),
                                      onChanged: (int value2) {
                                        setState(() {
                                          String currentCoffee = productList[index].name;
                                          print(orderFlavours[currentCoffee]);
                                          //calling this to update the state when an option is chosen
//                                          flavourSelected = value2;
                                        orderFlavours[currentCoffee] = value2;
                                          print(orderFlavours[currentCoffee]);
                                          print(orderFlavours);
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
//                                    orderName = productList[i].toMap()['name'];
//                                    listOfOrders.add(Order.fromMap({'coffee_name': productList[i].toMap()['name'], 'price': productList[i].toMap()['price']}));
                                  orderNames.add(productList[index].name);
                                  orderPrices.add(productList[index].price);
//                                  orderFlavours.add(flavourSelected);
                                  orderCupSizes.add(cupSizeSelected);
                                    print('listOfOrders.length before gatherOrderList: ' + listOfOrders.length.toString());
                                  gatherOrderList();
                                  print('listOfOrders.length after gatherOrderList: ' + listOfOrders.length.toString());
//                                    sendOrderList();
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
  print('productList.length before filling up: ');
  print(productList.length);
  if(documents.isNotEmpty){
    documents.forEach((data){
      print('document ID: ');
      print(data.documentID);
      print('data.data: ' + '${data.data}');

      productList.add(Product.fromJson(json.encode(data.data))); //here, we are creating dynamic objects. Just like in C++, you would use
      // object[0] = new Product(). In Dart 1, you would use 'new' keyword as well, but in Dart 2, it isn't required anymore.
      print('element of productlist: ');
    });
    print('productList.length right after filling up: ');
    print(productList.length);
    for (Product product in productList){
      print('product info: ');
      print('Look under here: ');
      print(product.toMap()); //this prints all the values of the variables inside Product class, defined inside toMap()
    }
  }

}

