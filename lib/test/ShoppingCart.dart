import 'package:challenge_1/resources/data.dart';
import 'package:flutter/material.dart';
import 'package:challenge_1/resources/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String paymentMethod; //stores the payment method chosen
bool orderFinalised = false;
bool plusClicked = false;
bool minusClicked = false;
int _orderQuantity = 1;
var _addressController = TextEditingController();

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

class ShoppingCart extends StatefulWidget {
  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    getOrderList();
    print('orders from Shopping Cart: ' + orders[0][0]);

    orderTiles(
        notifyParent: refresh()); //passing parent function to child widget

    if (orderFinalised)
      return orderInfoFinalised(_addressController.text, paymentMethod, 10, 2);
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 10, left: 10),
            child: Text('Shopping Cart',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            alignment: Alignment.topLeft,
          ),
          orderTiles(), //a loop that calls all orders from firebase
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
                    maxLines: 5, //max number of lines the user can enter
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
                      items: <String>['Credit Card', 'At the door']
                          .map<DropdownMenuItem<String>>((String value) {
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
                  if (_addressController.text != null &&
                      _addressController.text != "" &&
                      paymentMethod != null) {
                    orderFinalised = true;
                    sendOrderInfo();
                  } else {
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

class orderTiles extends StatefulWidget {
  final Function() notifyParent;

  orderTiles({Key key, @required this.notifyParent}) : super(key: key);

  @override
  _orderTilesState createState() => _orderTilesState();
}

class _orderTilesState extends State<orderTiles> {
  @override
  Widget build(BuildContext context) {
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
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: 1, //orders.length,
              itemBuilder: (context, int index) {
                return Row(
                  children: <Widget>[
                    Image(
                      image: AssetImage(
                          coffeeImages[coffeeNames.indexOf(orders[index][0])]),
                      width: 50,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 40, top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(orders[index][0]),
                          Text('\$15'),
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
                                  //click action is not working
                                  onTap: () {
                                    if (!orderFinalised) {
                                      add();
                                      setState(() {
                                        widget.notifyParent();
                                      });
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
                                  //click action is not working
                                  onTap: () {
                                    if (!orderFinalised) {
                                      minus();
                                      setState(() {});
                                      widget.notifyParent();
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class orderInfoFinalised extends StatefulWidget {
  final address;
  final payment;
  double subtotal;
  double shipp;

  orderInfoFinalised(this.address, this.payment, this.subtotal, this.shipp);

  @override
  _orderInfoFinalisedState createState() => _orderInfoFinalisedState();
}

class _orderInfoFinalisedState extends State<orderInfoFinalised> {
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
            orderTiles(), //a loop that calls all orders from firebase
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

void sendOrderInfo() {
  Firestore.instance
      .collection('order')
      .document('nYgTyxjkpQAOKjULyK2m')
      .updateData({
    'address': _addressController.text,
    'payment method': paymentMethod,
    'order quantity': _orderQuantity,
  });
}
