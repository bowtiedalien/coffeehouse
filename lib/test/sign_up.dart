import 'package:challenge_1/test/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:challenge_1/resources/models.dart';
import 'sign_in.dart';
import 'package:challenge_1/resources/data.dart';
import 'package:challenge_1/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  String _email;
  String _password;
  final _formKey = new GlobalKey<FormState>();

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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'You have to sign up to order!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    maxLines: 1,
                    validator: (value) =>
                        value.isEmpty ? 'Please enter your email' : null,
                    decoration: InputDecoration(
                        labelText: "Email", hintText: "youremail@example.com"),
                    onSaved: (input) => _email = input,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "password",
                    ),
                    validator: (value) =>
                        value.isEmpty ? 'Please enter your password' : null,
                    onSaved: (input) => _password = input,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "password again",
                    ),
                    validator: (value) => value != _password
                        ? 'you must enter the same password in both fields'
                        : null,
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
                        signUp();
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

  Future<void> signUp() async {
    final mymodel = Provider.of<MyModel>(context, listen: false);
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState
          .save(); //this calls the onSaved property of the form field and allow us access to its insides (i.e._email and _password)
      try {
        print(_email);
        print(_password);
        FirebaseUser user = (await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                    email: _email, password: _password))
            .user;
        userID = user.uid; //save User Id in a var
        print('userID from SignUp:' + userID);

        //create document on Firestore database to store user info
        Firestore.instance.collection('users').document().setData({
          'FirstName': '',
          'LastName': '',
          'address': '',
          'phone_number': '',
          'birthdate': '',
          'gender': '',
          'profile_picture': '',
        });

        if (userID != null) {
          mymodel.userIsSignedIn = true;
          setState(() {
            mymodel.showProfile();
          });
        }
      } catch (e) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  'Could not register new user!',
                ),
              );
            });
        //for me
        print(e.message);
      }
    }
  }
}
