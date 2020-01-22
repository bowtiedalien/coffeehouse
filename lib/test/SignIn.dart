import 'package:challenge_1/resources/data.dart';
import 'package:flutter/material.dart';
import 'package:challenge_1/resources/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:challenge_1/main.dart';

var emailController = new TextEditingController();
var passwordController = new TextEditingController();

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    final mymodel = Provider.of<MyModel>(context);

    double screenWidth = MediaQuery.of(context).size.width;
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
                  getUsers(emailController.text); //debugging
                  Firestore.instance
                      .collection('users')
                      .document(userDocID)
                      .get()
                      .then((snapshot) {
                    if (snapshot.exists) {
                      if (snapshot.data['email'] == emailController.text &&
                          snapshot.data['password'] ==
                              passwordController.text) {
                        print('sign in successful');
                        setState(() {
                          mymodel.showProfile();
                        });
                      } else if(snapshot.data['email'] != emailController.text ||
                          snapshot.data['password'] !=
                              passwordController.text){
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
                    } else
                      print('unable to get document');
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
                    setState(() {
                      mymodel.signUp();
                    });
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
