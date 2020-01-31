import 'package:challenge_1/resources/data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:challenge_1/resources/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:challenge_1/main.dart';


//TODO: delete later after you edit the SignUp page
var emailController = new TextEditingController();
var passwordController = new TextEditingController();

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = new GlobalKey<FormState>();
  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    final mymodel = Provider.of<MyModel>(context);

    double screenWidth = MediaQuery.of(context).size.width;
    print('userIsSignedIn: ' + '${mymodel.userIsSignedIn}');
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min, //so it doesn't take infinite height
            children: <Widget>[
              TextFormField(
                maxLines: 1,
                validator: (value) =>
                    value.isEmpty ? 'Please enter your email' : null,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    labelText: "Email", hintText: "youremail@example.com"),
                onSaved: (input) => _email = input,
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                maxLines: 1,
                obscureText: true,
                autofocus: false,
                decoration: InputDecoration(
                  labelText: "Password",
                ),
                validator: (value) =>
                    value.isEmpty ? 'Please enter your password' : null,
                onSaved: (input) => _password = input,
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
                    signIn();
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
      ),
    );
  }

  Future<void> signIn() async {
    final mymodel = Provider.of<MyModel>(context, listen: false);
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState
          .save(); //this calls the onSaved property of the form field and allow us access to its insides (i.e._email and _password)
      try {
        print(_email);
        print(_password);
        FirebaseUser user = (await FirebaseAuth.instance
                .signInWithEmailAndPassword(email: _email, password: _password))
            .user;
        userID = user.uid; //save User Id in a var
        if(userID!=null){
          mymodel.userIsSignedIn = true;
        }
        print('signIn() says userID is ' + userID);
          setState(() {
            mymodel.showProfile();
          });
      } catch (e) {
        //Programmer's Note: the following error-handling is not logically correct. Why? Because the dialog will always show for whichever error that might occur.
        //yes, there is the "Email is badly formatted" error, but there are also errors related with other things like network connection, or any other failures unrelated to email/password validation.
        //A better way to do it, is to somehow figure out the type of error, and produce a suitable message according to that.
        //This dialog should be shown for errors of the following messages:
        //1. 'There is no user record corresponding to this identifier. The user may have been deleted.' - when user email is not registered
        //2. 'The password is invalid or the user does not have a password.' - the password is not correct
        //3. 'Email is badly formatted' - the email is not in the right format
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  'Email or password not correct!',
                ),
              );
            });
        //for me
        print(e.message);
      }
    }
  }
}
