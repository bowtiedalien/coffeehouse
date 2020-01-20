import 'package:challenge_1/test/SignUp.dart';
import 'package:flutter/material.dart';
import 'package:challenge_1/resources/models.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context)
        .size
        .width;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          TextField(
              decoration: InputDecoration(
                  labelText: "Email", hintText: "youremail@example.com")),
          SizedBox(
            height: 15,
          ),
          TextField(
            decoration: InputDecoration(
              labelText: "password",
            ),
          ),
          SizedBox(
            height: 15,
          ),
          SizedBox(
            width: screenWidth - 20,
            height: 40,
            child: RaisedButton(
              child: Text(
                'SIGN IN',
                style: TextStyle(color: Colors.white),
              ),
              color: bgColor,
              onPressed: () {
                //check data from firebase
                //if user exists, sign in
                //otherwise, display "This email does not exist in our database"
              },
            ),
          ),
          Container(
            child: SizedBox(
              width: screenWidth - 40,
              height: 40,
              child: RaisedButton(
                child: Text(
                  'SIGN UP',
                  style: TextStyle(color: Colors.white),
                ),
                color: bgColor,
                onPressed: () {
                  hasAccount = false;
                  return; //check if this works: this should go back to parent widget and test the if condition, then redirect to SignUp
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
