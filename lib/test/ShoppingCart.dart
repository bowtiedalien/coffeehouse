import 'package:flutter/material.dart';
import 'package:challenge_1/resources/models.dart';
import 'profilePage.dart';

String paymentMethod; //stores the payment method chosen

Widget priceReport(double subt, double shp){
  return Column(
      children: <Widget>[
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
                  Text('\$' + (subt+shp).toString()),
                ],
              ),
            ],
          ),
        ),
      ]
  );
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
  @override
  Widget build(BuildContext context) {
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
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
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
                coffeeButton('Proceed to Checkout', (){ return ProfilePage();}),
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
    int _orderQuantity = 1;

    void add() {
      _orderQuantity++;
    }
    void minus() {
      if(_orderQuantity!=0)
        _orderQuantity--;
    }
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Image(
                image: AssetImage('affogato.png'),
                width: 50,
              ),
              Container(
                margin: EdgeInsets.only(left: 40, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Affogato'),
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
                              onTap: (){
                                print('plus was clicked');
                                add();
                                print(_orderQuantity);
                              },
                              child: Icon(Icons.add)
                          ),
                          Container(
                              margin: EdgeInsets.all(0),
                              padding: EdgeInsets.all(2),
                              child: Text(_orderQuantity.toString())),
                          GestureDetector(
                            //click action is not working
                            onTap: (){
                              print('minus was clicked');
                              minus();
                            },
                            child: Icon(const IconData(0xe15b, fontFamily: 'MaterialIcons'),
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
          Row(
            children: <Widget>[
              Text('delete'),
              Icon(Icons.delete),
            ],
          ),
        ],

      ),
    );
  }
}