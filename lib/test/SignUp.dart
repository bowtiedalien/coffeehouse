import 'package:challenge_1/test/profilePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:challenge_1/resources/models.dart';
import 'SignIn.dart';
import 'package:challenge_1/main.dart';
import 'package:provider/provider.dart';

class SignInSignUp extends StatefulWidget {
  @override
  _SignInSignUpState createState() => _SignInSignUpState();
}

class _SignInSignUpState extends State<SignInSignUp> {
  @override
  Widget build(BuildContext context) {
    final mymodel = Provider.of<MyModel>(context);
    if (mymodel.userIsSignedIn)
      return MyProfilePage();
    else {
      if (!mymodel.userHasAccount)
        return SignUp();
      else if (mymodel.userHasAccount) return SignIn();
    }
  }
}

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    final mymodel = Provider.of<MyModel>(context);
    double screenWidth = MediaQuery.of(context)
        .size
        .width; //save screen dimensions in a variable
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
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
                    controller: emailController,
                    decoration: InputDecoration(
                        labelText: "Email", hintText: "youremail@example.com")),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "password",
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  obscureText: true,
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
                    onPressed: () {
                      Firestore.instance
                          .collection('users')
                          .document()
                          .setData({
                        'email': emailController.text,
                        'password': passwordController.text
                      });
                      if (emailController.text == null ||
                          emailController.text == "" ||
                          passwordController.text == null ||
                          passwordController.text == "") {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  'You need to enter an email and a password',
                                ),
                              );
                            });
                      } else
                        mymodel.showProfile();
                    },
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
                  setState(() {
                    mymodel.signIn();
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
