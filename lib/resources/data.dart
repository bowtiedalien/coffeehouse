import 'package:flutter/material.dart';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

//declare all variables and functions here-------------------

bool isSignedIn = true;
String userName; //this gets set once
String userImage;
String userPhone;
String userGender;
String userAddress;
String userBirthdate;
String userEmail = 'sarahxd62@yahoo.com';

//List<String> shoppingBasket = []; //temporarily stores the coffee names ordered until I create the firebase collection
int n = 2;
List<List<String>> shoppingBasket = new List.generate(n, (i) => []);

List<DropdownMenuItem<String>> cupSizes =
    []; //array that stores available cup sizes
List<DropdownMenuItem<int>> flavours = [];
String selected;
int flavourSelected;

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

Widget getData() {
  var test = {
    'name': 'sara'
  }; //what a map is, 'name' is the key, 'sara' is the value. Hence in a map, keys are linked to values.
  return StreamBuilder(
      stream: Firestore.instance
          .collection('users')
          .document('37zlwhMsLr5NMPUociLP')
          .snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          final snapshotData = snapshot.data;
          Map userDocument = snapshotData.data;
          print(userDocument);
          return Text(
            "Hello " + userDocument.values.first,
            style: TextStyle(color: Colors.blue, fontSize: 40),
          );
        }
        return const Text("Loading...");
      });
}

Future getDocs() async {
  final QuerySnapshot result =
      await Firestore.instance.collection('users').getDocuments();
  List<DocumentSnapshot> documents = result.documents;
  if(documents.isNotEmpty) { //wait until you have the data
    documents.forEach((data) {
      if (data.data['email'] == 'sarahxd62@yahoo.com') {
        print(data.data['FirstName'] + ' ' + data.data['LastName']);
        userName = data.data['FirstName'] + ' ' + data.data['LastName'];
        userAddress = data.data['address'];
        userGender = data.data['gender'];
        userPhone = data.data['phone number'];
        userImage = data.data['profile picture'];
        userBirthdate = data.data['birthdate'];
      }
      else
        print('retrieving data');
      //print(data.data);
    });
  }
}
