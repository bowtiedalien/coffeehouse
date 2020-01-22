import 'package:challenge_1/resources/data.dart';
import 'package:challenge_1/test/homepage.dart';
import 'package:flutter/material.dart';
import 'package:challenge_1/resources/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

String paymentMethod; //stores the payment method chosen

bool plusClicked = false;
bool minusClicked = false;
int _orderQuantity = 1;
bool orderLoading;
var _addressController = TextEditingController();
String orderName;

var orders = <Map>[]; //create an empty list of map

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
        child: MyShoppingCart(),);
  }
}

class MyShoppingCart extends StatefulWidget {
  @override
  _MyShoppingCartState createState() => _MyShoppingCartState();
}

class _MyShoppingCartState extends State<MyShoppingCart> {
  Future getOrderList() async {
    setState(() {
      orderLoading = true;
    });
    DocumentReference documentReference =
    Firestore.instance.collection('order').document('nYgTyxjkpQAOKjULyK2m');
    await documentReference.get().then((datasnapshot) {
      if (datasnapshot.exists) {
//        print(datasnapshot.data['order list']);
        print(datasnapshot.data['order list'][0]);
        //there is something wrong here
        //orders[0]['coffee name'] = datasnapshot.data['order list'][0]['coffee name'].toString();
        print('before problematic');
        orders.add({'coffee name': datasnapshot.data['order list'][0]['coffee name']});
        print('after problematic');
        orderName = orders[0]['coffee name'];
        setState(() {
          orderLoading = false;
          print(orderLoading);
        });
      } else {
        print('loading');
      }
    });
  }

  @override
  void initState() {
    getOrderList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    print('orders from Shopping Cart: ' + orders[0]['coffee name']);
//    print('is order loading: ' + orderLoading.toString());

    final model = Provider.of<ShoppingCartModel>(
        context);
    if (model.orderFinalised)
      return orderInfoFinalised(_addressController.text, paymentMethod, 10, 2);
    else
      return orderLoading
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 10, left: 10),
            child: Text('Shopping Cart',
                style:
                TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
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
                        context);
//                    sendOrderInfo();
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


class orderTiles extends StatefulWidget {
  @override
  _orderTilesState createState() => _orderTilesState();
}

class _orderTilesState extends State<orderTiles> {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ShoppingCartModel>(
        context);

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
              itemCount: orders.length, //orders.length,
              itemBuilder: (context, int index) {
                return Dismissible(
                  key: Key(orders[index].toString()),
                  background: Container(
                    color: bgColor,
                  ),
                  onDismissed: (direction){
                    setState(() {
                      orders.removeAt(index); //remove the order from the orders list
                    });
                  },
                  child: Row(
                    children: <Widget>[
                      Image(
                        image: AssetImage(
                          coffeeImages[coffeeNames.indexOf(orders[index]['coffee name'])],
                           ),
                        width: 50,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 40, top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(orders[0]['coffee name']),
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

//void sendOrderInfo() {
//  Firestore.instance
//      .collection('order')
//      .document()
//      .setData({
//    //TODO: how to dynamically create a subcollection
//    //'order list': [{'coffee name': orderName, 'cup size': cupSizeSelected, 'flavour': flavourSelected}],
//    'address': _addressController.text,
//    'payment method': paymentMethod,
//    'order quantity': _orderQuantity,
//  });
//}

class ShoppingCartModel with ChangeNotifier{
  bool orderFinalised = false;

  void finaliseOrder() {
      orderFinalised = true;
      notifyListeners();
  }
}
