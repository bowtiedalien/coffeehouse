import 'package:flutter/material.dart';
import 'package:challenge_1/resources/models.dart';
import 'SignIn.dart';

bool hasAccount = false;

class SignInSignUp extends StatefulWidget {
  @override
  _SignInSignUpState createState() => _SignInSignUpState();
}

class _SignInSignUpState extends State<SignInSignUp> {
  @override
  Widget build(BuildContext context) {
    if(!hasAccount)
      return SignUp();
    else if(hasAccount)
      return SignIn();
  }
}

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context)
        .size
        .width; //save screen dimensions in a variable
    double screenHeight = MediaQuery.of(context).size.height;
    double bottomMargin = screenHeight/11; //stupid error-prone value of a margin - how can I calculate this better?
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
//            margin: EdgeInsets.only(bottom: bottomMargin),
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'You have to sign up to order!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
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
                TextField(
                  decoration: InputDecoration(
                    labelText: "password again",
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: screenWidth - 20,
                  height: 40,
                  child: RaisedButton(
                    child: Text(
                      'SIGN UP',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: bgColor,
                    onPressed: () {},
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Text('-OR-'),
              ],
            ),
          ),
          Container(
            child: SizedBox(
              width: screenWidth - 40,
              height: 40,
              child: RaisedButton(
                child: Text(
                  'SIGN IN',
                  style: TextStyle(color: Colors.white),
                ),
                color: bgColor,
                onPressed: () {
                  hasAccount = true;
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
