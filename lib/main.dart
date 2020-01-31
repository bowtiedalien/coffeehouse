import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'test/widget_test.dart';
import 'resources/models.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'test/sign_in.dart';

void main() {
  //WidgetsFlutterBinding.ensureInitialized(); //initialises flutter's framework - need to use if I'm using systemChannels before runApp()
  runApp(MaterialApp(
    theme: ThemeData(primaryColor: bgColor),
    debugShowCheckedModeBanner: false,
    home: ChangeNotifierProvider<MyModel>(
      create: (context) => MyModel(),
      child: MyApp(), //change this back to MyApp()
    ),
  ));
  SystemChannels.textInput.invokeMethod('TextInput.hide');
}

class MyModel with ChangeNotifier {
  //setters and getters:
  bool _userIsSignedIn = FirebaseAuth.instance.currentUser() != null; //if the currentUser is not null, set userIsSignedIn to true

  bool get userIsSignedIn {
    return _userIsSignedIn;
  }

  set userIsSignedIn(bool v) {
    _userIsSignedIn = v;
    notifyListeners();
  }

  //--------------

  bool userHasAccount = false;

  void signOut() {
    userIsSignedIn = false;
    notifyListeners();
  }

  void signIn() {
    userHasAccount = true;
    notifyListeners();
  }

  void signUp() {
    userHasAccount = false;
    notifyListeners();
  }

  void showProfile() {
    userIsSignedIn = true;
    notifyListeners();
  }
}
