import 'package:flutter/material.dart';

//custom brown color
const bgColor = Color(0xFF442C0C);
//or is this better: #7C4C2C ?

BoxDecoration dropDownButtonDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(20.0),
  border: Border.all(color: Colors.brown[200]),
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
);

//any button in the app except the SignIn and SignUp
Widget coffeeButton(String title, onclick()) {
  return RaisedButton(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
    ),
    color: bgColor,
    elevation: 3,
    child: Text(
      title,
      style: TextStyle(color: Colors.white),
    ),
    onPressed: () {
      onclick();
    },
  );
}

//for containers with curved edges
BoxDecoration curvedEdge = BoxDecoration(
  borderRadius: BorderRadius.circular(20.0),
  border: Border.all(color: Colors.brown[200]),
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
);
