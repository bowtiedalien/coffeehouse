import 'dart:convert';

import 'package:challenge_1/resources/data.dart';
import 'package:challenge_1/test/homepage.dart';
import 'package:flutter/material.dart';
import 'package:challenge_1/resources/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'model_class.dart';

String paymentMethod; //stores the payment method chosen
Order someOrder;
List<Order> listOfOrders = []; //this gets sent to Firestore - it has all orders inside it

bool plusClicked = false;
bool minusClicked = false;
int _orderQuantity = 1;
bool orderLoading;
var _addressController = TextEditingController();
//String orderName;
var orderNames = [];
var orderPrices = [];

String orderDocumentID; //use this to store the document ID where the orders[] is stored, so that we can retrieve that document only not the others and display it in the Shopping Cart
var orders = <Map<String, dynamic>>[];

Widget priceReport(double subt, double shp) {
  return Column(children: <Widget>[
    //cart subtotal
    SizedBox(
      width: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              Text('Cart subtotal'),
            ],
          ),
          Column(
            children: <Widget>[
              Text('\$' + subt.toString()),
            ],
          ),
        ],
      ),
    ),
    //shipping
    SizedBox(
      width: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              Text('Shipping'),
            ],
          ),
          Column(
            children: <Widget>[
              Text('\$' + shp.toString()),
            ],
          ),
        ],
      ),
    ),
    //total
    SizedBox(
      width: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              Text('Total'),
            ],
          ),
          Column(
            children: <Widget>[
              Text('\$' + (subt.toDouble() + shp.toDouble()).toString()),
            ],
          ),
        ],
      ),
    ),
  ]);
}

Widget cardTitle(String title) {
  return Container(
    margin: EdgeInsets.only(top: 10, bottom: 5, left: 10),
    child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          title,
          style: TextStyle(fontSize: 20),
        )),
  );
}

class ShoppingCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ShoppingCartModel(),
      child: MyShoppingCart(),
    );
  }
}

class MyShoppingCart extends StatefulWidget {
  @override
  _MyShoppingCartState createState() => _MyShoppingCartState();
}

class _MyShoppingCartState extends State<MyShoppingCart> {
  //TODO: get all documents of all orders from here, and display them all in the ListView. do not call a specific document like this.
  //TODO: add the data you get from Firestore to the array called orders
  Future getOrderList() async {
    setState(() {
      orderLoading = true;
    });

    final QuerySnapshot allDocs = await Firestore.instance.collection('order')
        .getDocuments();
    List<DocumentSnapshot> docs = allDocs.documents;
    if (docs.isNotEmpty) {
      docs.forEach((d) {
        print("printing name and price ..");
        print(d.data['orders'][0]['coffee_name']);
        print(d.data['price']);
        print('length of orders list: ' + '${orders.length}');
//        orders.add(
//            {'name': d.data['orders'][0]['name'], 'price': d.data['price']});
//        for(int i=0; d.data['orders'][i]==null; i++) {
        int i=0;
          if(d.data['orders'][i] != null) {
            orders.insert(i, {
              'name': d.data['orders'][i]['coffee_name'],
              'price': d.data['price'],
            },);
            i++;
          }

        //}
        print('length of orders list: ' + '${orders.length}');
        setState(() {
          orderLoading = false;
          print(orderLoading);
        });
      });
    }
    else {
      print('loading');
    }
  }

  @override
  void initState() {
    getOrderList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ShoppingCartModel>(context);
    if (model.orderFinalised)
      return OrderInfoFinalised(_addressController.text, paymentMethod, 10, 2);
    else
      return orderLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 10, left: 10),
                    child: Text('Shopping Cart',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                    alignment: Alignment.topLeft,
                  ),
                  OrderTiles(), //a loop that calls all orders from firebase
                  Divider(),
                  Container(
                    child: Column(
                      children: <Widget>[
                        cardTitle('Shipping Address'),
                        Container(
                          padding: EdgeInsets.all(20),
                          width: 240,
                          height: 100,
                          decoration: curvedEdge,
                          child: TextField(
                            controller: _addressController,
                            keyboardType: TextInputType.multiline,
                            maxLines:
                                5, //max number of lines the user can enter
                          ),
                        ),
                        cardTitle('Payment Method'),
                        Container(
                          decoration: dropDownButtonDecoration,
                          padding: EdgeInsets.only(left: 7),
                          margin: EdgeInsets.all(3),
                          height: 35,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: paymentMethod,
                              //the default value of the button
                              onChanged: (String value) {
                                setState(() {
                                  paymentMethod = value;
                                });
                              },
                              //understand this part > we are taking a string array, mapping it to another type, then converting it to a list?
                              items: <String>[
                                'Credit Card',
                                'At the door'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              hint: Text('choose payment'),
                            ),
                          ),
                        ),
                        Divider(),
                        priceReport(10.0, 2.0),
                        SizedBox(
                          height: 30,
                        ),
                        coffeeButton('Proceed to Checkout', () {
                          //add verification for payment type and address - user HAS to enter them
                          if (_addressController.text == null ||
                              _addressController.text == "" ||
                              paymentMethod == null) {
                            print('textfield empty');
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'You need to enter both an address and a payment method!',
                                    ),
                                  );
                                });
                          } else {
                            final model = Provider.of<ShoppingCartModel>(
                                context,
                                listen:
                                    false); //set listen: false when the consumer will only use the methods of the model and will not update.
//                    sendOrderInfo();
                            sendOrderList(); //sending again the order list in case the user deleted any of the orders
                            model.finaliseOrder();
                          }
                          setState(() {
                            //refresh page to make it read-only
                          });
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            );
  }
}

class OrderTiles extends StatefulWidget {
  @override
  _OrderTilesState createState() => _OrderTilesState();
}

class _OrderTilesState extends State<OrderTiles> {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ShoppingCartModel>(context);

    void add() {
      _orderQuantity++;
      setState(() {});
    }
    void minus() {
      if (_orderQuantity != 0) _orderQuantity--;
      setState(() {});
    }

    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(left: 20, right: 20),
      height: 120 * orders.length.toDouble(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, int index) {
                
                return Dismissible(
                  key: Key(orders[index].toString()), //I don't know if I'm doing this correctly
                  background: Container(
                    color: bgColor,
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      orders.removeAt(
                          index);
                    });
                  },
                  child: Row(
                    children: <Widget>[
                      Image(
                        image: AssetImage(
                          coffeeImages[coffeeNames
                              .indexOf(orders[index]['name'])],
                        ),
                        width: 50,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 40, top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(orders[index]['name']), //TODO: this is index 0 only right now because I still haven't figured out how to add more than one order in the list anyway, so it was always have just one element. Fix it later to be a loop when you figure out how to add more than one order
                            Text(orders[index]['price'].toString()),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: Colors.brown[200]),
                              ),
                              margin: EdgeInsets.only(top: 5),
                              height: 25,
                              child: Row(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      if (!model.orderFinalised) {
                                        add();
                                        setState(() {});
                                        print(_orderQuantity);
                                      }
                                    },
                                    child: Icon(Icons.add),
                                  ),
                                  Container(
                                      margin: EdgeInsets.all(0),
                                      padding: EdgeInsets.all(2),
                                      child: Text(_orderQuantity.toString())),
                                  GestureDetector(
                                    onTap: () {
                                      if (!model.orderFinalised) {
                                        minus();
                                        setState(() {});
                                      }
                                    },
                                    child: Icon(
                                        const IconData(0xe15b,
                                            fontFamily: 'MaterialIcons'),
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                              //quantity button here
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OrderInfoFinalised extends StatefulWidget {
  final address;
  final payment;
  double subtotal;
  double shipp;

  OrderInfoFinalised(this.address, this.payment, this.subtotal, this.shipp);

  @override
  _OrderInfoFinalisedState createState() => _OrderInfoFinalisedState();
}

class _OrderInfoFinalisedState extends State<OrderInfoFinalised> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 10, left: 10),
              child: Text('Shopping Cart',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              alignment: Alignment.topLeft,
            ),
            OrderTiles(), //a loop that calls all orders from firebase
            Divider(),
            Container(
              child: Column(
                children: <Widget>[
                  cardTitle('Shipping Address'),
                  Container(
                    padding: EdgeInsets.all(20),
                    width: 240,
                    height: 70,
                    child: Center(
                        child: Text(
                      widget.address,
                      style: TextStyle(color: Colors.blueAccent),
                    )),
                  ),
                  cardTitle('Payment Method'),
                  Container(
                    padding: EdgeInsets.only(left: 7),
                    margin: EdgeInsets.all(3),
                    height: 35,
                    child: Center(
                        child: Text(
                      paymentMethod,
                      style: TextStyle(color: Colors.blueAccent),
                    )),
                  ),
                  Divider(),
                  SizedBox(
                    height: 20,
                  ),
                  priceReport((widget.subtotal), (widget.shipp)),
                  SizedBox(
                    height: 60,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.check,
                        size: 40,
                        color: bgColor,
                      ),
                      Text(
                        'Your order is' + '\non its way!',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                        softWrap: true,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//void sendOrderInfo() {
//  Firestore.instance
//      .collection('order')
//      .document()
//      .setData({
//    //TODO: how to dynamically create a subcollection
//    'address': _addressController.text,
//    'payment method': paymentMethod,
//    'order quantity': _orderQuantity,
//  });
//}

void sendOrderList() async {
  //create a new document in Firestore, add to it the order information (coffee name, cup size, and flavour)
//  Firestore.instance.collection('order').document().setData({
//    'orders': [
//      {
//        'coffee_name': orderName,
//        'cup_size': cupSizeSelected,
//        'flavour': flavourSelected,
//      },
//    ],
//  });


  print('from inside sendOrderList: ');

  //filling up the listOfOrders list
  for (int i = 0; i < orderNames.length; i++) {
    listOfOrders.add(
        Order.fromMap({'coffee_name': orderNames[i], 'flavour': orderFlavours[i], 'cup_size': orderCupSizes[i]}));
  }

  //converting all items in listOfOrders to map type
  List<Map> ordersAsMaps = [];
  listOfOrders.forEach((Order f) {
    Map oneOrder = f.toMap();
    print(oneOrder);
    ordersAsMaps.add(oneOrder);
  });

  print('printing ordersAsMaps: ');
  print(ordersAsMaps);

//  Test myOrder;
//  myOrder.toMap();
//  for(int i=0;i<orderNames.length; i++) {
//    myOrder.orders.add(Order.fromMap({'coffee_name': orderNames[i], 'price': orderPrices[i]}));
//  }
//  print(myOrder);
//  print('$listOfOrders');
    DocumentReference docRef = await Firestore.instance.collection('order').document();
    docRef.setData(
        {'orders': FieldValue.arrayUnion(ordersAsMaps)});
    orderDocumentID = docRef.documentID;

}

class ShoppingCartModel with ChangeNotifier {
  Order myOrder;

  bool orderFinalised = false;

  void finaliseOrder() {
    orderFinalised = true;
    notifyListeners();
  }
}
