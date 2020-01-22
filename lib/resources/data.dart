import 'package:flutter/material.dart';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

bool profilePageIsFetched = false;
//GLOBAL
String userDocID =
    'QgEqFX4AklQfLY85jnDV'; //stores all the info of the current logged in user

//declare all variables and functions here-------------------
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
int flavourSelected;

void getCupSizes() {
  cupSizes = [];
  cupSizes.add(DropdownMenuItem(
    child: Text('Huge'),
    value: 'huge',
  ));
  cupSizes.add(DropdownMenuItem(
    child: Text('normal'),
    value: 'normal',
  ));
  cupSizes.add(DropdownMenuItem(
    child: Text('small'),
    value: 'small',
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

Future getUsers(String enteredEmail) async {
  final QuerySnapshot result =
      await Firestore.instance.collection('users').getDocuments();
  List<DocumentSnapshot> documents = result.documents;
  if (documents.isNotEmpty) {
    //wait until you have the data
    documents.forEach((data) {
      if (data.data['email'] == enteredEmail) {
        print(data.documentID);
        userDocID = data.documentID;
        //return the document number
      } else {
        print('retrieving data');
      }
    });
  }
}
