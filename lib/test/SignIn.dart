import 'package:challenge_1/resources/data.dart';
import 'package:challenge_1/test/SignUp.dart';
import 'package:challenge_1/test/profilePage.dart';
import 'package:flutter/material.dart';
import 'package:challenge_1/resources/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

var emailController = new TextEditingController(); 
var passwordController = new TextEditingController();

class SignIn extends StatefulWidget {
  final Function() notifyParent;

  SignIn({Key key, @required this.notifyParent}) : super(key: key);

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
      child: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
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
                  Firestore.instance.collection('users').document('P86syncJAcKjY9PKq60l').get().then((snapshot){
                    if (snapshot.exists) {
                      if(snapshot.data['email'] == emailController.text && snapshot.data['password'] == passwordController.text)
                        {
                          print('sign in successful');
                          isSignedIn = true;
                          setState(() {

                          });
                          widget.notifyParent();
                        }
                      else
                        {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'Email or password not correct!',
                                  ),
                                );
                              });
                        }
                    }
                  });
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text('-OR-'),
            SizedBox(
              height: 20,
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
      ),
    );
  }
}
